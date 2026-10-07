{
  pkgs,
  lib,
  ...
}:
let
  # Single source of truth: low-battery warning levels, in percent.
  # The watcher script below is generated from this list; editing the list
  # is the only change needed to add or remove a warning level.
  levels = [
    30
    31
    32
    33
    34
    35
    36
    37
    38
    20
    10
    5
  ];

  sorted = builtins.sort (a: b: a > b) levels;
  levelsStr = lib.concatStringsSep " " (map toString sorted);

  battery-watch = pkgs.writeShellScriptBin "battery-watch" ''
    # Low-battery watcher: pops one notification per level as the battery
    # discharges down through each entry of LEVELS. State is a single
    # integer: the next level that will fire. A level re-arms only once
    # the battery has charged above it, so nothing re-fires mid-descent
    # and nothing goes permanently silent. Safe across reboot/crash.
    set -u

    LEVELS="${levelsStr}"   # descending, e.g. "20 10 5"
    BAT=/sys/class/power_supply/BAT0
    STATE_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}/battery-watch"
    STATE="$STATE_DIR/armed"

    mkdir -p "$STATE_DIR"
    exec 9>"$STATE_DIR/lock"
    ${pkgs.util-linux}/bin/flock -n 9 || exit 0   # a second instance is a no-op

    # The highest level strictly below capacity (the armed set after charging
    # up to cap); 0 when cap is at or below every level.
    arm_from_cap() {
      local cap=$1 t
      for t in $LEVELS; do
        [ "$cap" -gt "$t" ] && { echo "$t"; return; }
      done
      echo 0
    }

    # The next level below the one just consumed; 0 when none remain.
    arm_next_below() {
      local level=$1 t passed=0
      for t in $LEVELS; do
        [ "$passed" -eq 1 ] && { echo "$t"; return; }
        [ "$t" -eq "$level" ] && passed=1
      done
      echo 0
    }

    save() {
      printf '%s\n' "$1" > "$STATE.tmp"
      mv "$STATE.tmp" "$STATE"
    }

    # Fresh install or lost state: fully armed (never silent).
    # A non-numeric state file is treated the same way (recovers instead
    # of spinning on every tick).
    init_state() {
      local armed
      armed=$(cat "$STATE" 2>/dev/null)
      case "$armed" in
        # missing/corrupt: fully armed
        *[!0-9]*|"") armed=$(arm_from_cap 101) ;;
        *) : ;;
      esac
      printf '%s\n' "$armed" > "$STATE.tmp"
      mv "$STATE.tmp" "$STATE"
    }
    init_state

    while :; do
      sleep 60
      cap=$(cat "$BAT/capacity" 2>/dev/null) || continue
      st=$(cat "$BAT/status" 2>/dev/null) || continue

      if [ "$st" != "Discharging" ]; then
        # Charging/full: re-arm levels only after capacity rises above the
        # currently armed level. A capacity dip while still charging must not
        # move the next warning downward and skip a level on unplug.
        armed=$(cat "$STATE")
        want=$(arm_from_cap "$cap")
        [ "$cap" -gt "$armed" ] && [ "$want" != "$armed" ] && save "$want"
        continue
      fi

      armed=$(cat "$STATE")
      # Notify first, persist after: a crash here re-fires one level
      # (a rare duplicate) rather than going silently past it.
      if [ "$armed" -ne 0 ] && [ "$cap" -le "$armed" ]; then
        ${pkgs.libnotify}/bin/notify-send -a battery-watch -u critical -t 0 \
          "Battery low: $cap%" "Only $cap% left — plug in your charger"
        save "$(arm_next_below "$armed")"
      fi
    done
  '';
in
{
  home.packages = [ battery-watch ];
}
