{
  lib,
  ...
}:
{
  # The work machine owns its existing .zshenv outside Home Manager.

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "claude-code" ];

  programs.claude-code.enable = true;

  home.file = {
    "./.zshenv".enable = false;
  }
  // builtins.listToAttrs (
    builtins.map (name: {
      name = ".claude/skills/${name}";
      value.source = ../common/skills + "/${name}";
    }) [ "architect" "bro" "explain" "unslop" ]
  );

  local.agent = {
    command = "claude";
    # claude continues the most recent conversation via a flag, not a subcommand
    resumeArgs = "--continue";
  };
}
