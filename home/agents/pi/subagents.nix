{
  pkgs,
  ...
}:
let
  piSubagentsVersion = "0.75.0";
in
{
  # Native subagent delegation for environments without T3 Code orchestration.
  # Skip this module where t3code runs: T3's delegate_task covers the same
  # ground (plus worktrees, model options, cross-provider), and the duplicate
  # delegation guidance creates tool-selection friction.
  home.file = {
    # pi-subagents reads its config from the directory its package occupies.
    ".pi/agent/extensions/subagent/config.json".text = builtins.toJSON {
      # Register subagent from the first request; no loader tool.
      toolActivation = "eager";
      # Trim feature groups this setup does not use from the tool schema.
      # Re-enable by removing names from this list.
      disabledFeatures = [
        "missions"
        "panes"
        "watchdog"
        "lane-management"
        "lane-metadata"
        "external-machines"
        "control-overrides"
        "extension-bindings"
        "spawn-budget-grants"
        "preflight"
      ];
    };
  };

  programs.pi-coding-agent.settings.packages = [
    "npm:pi-subagents@${piSubagentsVersion}"
  ];
}
