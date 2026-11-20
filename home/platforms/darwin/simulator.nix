{ config, lib, pkgs, ... }:
let
  device = config.simulator.device;
  skill = pkgs.runCommand "shared-ios-simulator-skill" { } ''
    cp -R ${./skills/shared-ios-simulator} "$out"
    chmod -R u+w "$out"
    substituteInPlace "$out/SKILL.md" --replace-fail @device@ ${device}
  '';
in
{
  options.simulator.device = lib.mkOption {
    type = lib.types.str;
    default = "4469D43E-D1C0-4E0B-9CAC-8684C5522DAF";
    description = "UDID of the one simulator agents share on this Mac.";
  };

  config = {
    home.packages = [
      (import ./simulator-cleanup.nix { inherit pkgs; })
      (import ./sim-claim.nix { inherit pkgs device; })
    ];

    # T3's agent-device daemon inherits this; agents never detach, so idle claims must expire.
    launchd.agents.agent-device-idle-timeout = {
      enable = true;
      config = {
        ProgramArguments = [ "/bin/launchctl" "setenv" "AGENT_DEVICE_SESSION_IDLE_TIMEOUT_MS" "1200000" ];
        RunAtLoad = true;
      };
    };

    home.file = builtins.listToAttrs (
      map (directory: {
        name = "${directory}/shared-ios-simulator";
        value.source = skill;
      }) [
        ".agents/skills"
        ".claude/skills"
      ]
    );
  };
}
