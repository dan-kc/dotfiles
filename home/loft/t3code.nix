{
  config,
  lib,
  pkgs,
  ...
}:
let
  t3code = pkgs.callPackage ../../pkgs/t3code { };
  startT3code = pkgs.writeShellApplication {
    name = "start-t3code";
    runtimeInputs = with pkgs; [
      coreutils
      jq
      tailscale
      git
      gh
      bash
      nix
      codex
      pi-coding-agent
    ];
    text = ''
      # Retry via systemd until Tailscale is authenticated and has an address.
      tailnet_ip="$(tailscale ip -4)"
      if [[ -z "$tailnet_ip" ]]; then
        echo "T3 Code is waiting for a Tailscale IPv4 address." >&2
        exit 1
      fi

      umask 077
      mkdir -p "$T3CODE_HOME/userdata"
      settings="$T3CODE_HOME/userdata/settings.json"
      if [[ ! -e "$settings" ]]; then
        printf '{}\n' > "$settings"
      fi
      settings_tmp="$(mktemp "$settings.XXXXXX")"
      trap 'rm -f "$settings_tmp"' EXIT
      # Keep app-managed settings, while managing these two provider entries.
      jq --arg codex '${pkgs.codex}/bin/codex' \
         --arg pi '${pkgs.pi-coding-agent}/bin/pi' '
        .providerInstances.codex.driver = "codex"
        | .providerInstances.codex.enabled = true
        | .providerInstances.codex.config.binaryPath = $codex
        | .providerInstances.codex.config.setupMode = "existing"
        | del(.providerInstances.codex.config.enabled)
        | .providerInstances.pi.driver = "pi"
        | .providerInstances.pi.enabled = true
        | .providerInstances.pi.config.binaryPath = $pi
        | del(.providerInstances.pi.config.enabled)
      ' "$settings" > "$settings_tmp"
      mv "$settings_tmp" "$settings"

      # Zsh's interactive environment is not inherited by systemd services.
      export OPENROUTER_API_KEY
      OPENROUTER_API_KEY="$(cat /run/secrets/openrouter_api_key)"
      exec ${t3code}/bin/t3 serve --host "$tailnet_ip" --port 3773
    '';
  };
in
{
  home.packages = [ t3code ];

  systemd.user.services.t3code = {
    Unit = {
      Description = "T3 Code with Pi and Codex over Tailscale";
      # Tailscale may need time to start or a first interactive login.
      StartLimitIntervalSec = 0;
    };
    Service = {
      ExecStart = lib.getExe startT3code;
      WorkingDirectory = "${config.home.homeDirectory}/projects";
      Environment = [
        "T3CODE_HOME=%h/.t3"
        "PATH=/etc/profiles/per-user/daniel/bin:/run/current-system/sw/bin"
      ];
      Restart = "on-failure";
      RestartSec = 10;
      UMask = "0077";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
