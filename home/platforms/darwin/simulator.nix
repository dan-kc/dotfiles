{ pkgs, ... }:
{
  home.packages = [
    (import ./simulator-cleanup.nix { inherit pkgs; })
    (import ./sim-claim.nix { inherit pkgs; })
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
      value.source = ./skills/shared-ios-simulator;
    }) [
      ".agents/skills"
      ".claude/skills"
    ]
  );
}
