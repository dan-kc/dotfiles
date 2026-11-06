{
  lib,
  pkgs,
  ...
}:
let
  # `rm` trashes (see zsh aliases); purge entries after a week so deletions eventually free space.
  purge = [
    "${pkgs.trash-cli}/bin/trash-empty"
    "-f"
    "7"
  ];
in
lib.mkMerge [
  (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    launchd.agents.trash-expiry = {
      enable = true;
      config = {
        ProgramArguments = purge;
        RunAtLoad = true;
        StartCalendarInterval = [
          {
            Hour = 12;
            Minute = 0;
          }
        ];
      };
    };
  })
  (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    systemd.user.services.trash-expiry = {
      Unit.Description = "Purge trash entries older than a week";
      Service = {
        Type = "oneshot";
        ExecStart = lib.escapeShellArgs purge;
      };
    };
    systemd.user.timers.trash-expiry = {
      Timer = {
        OnCalendar = "daily";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  })
]
