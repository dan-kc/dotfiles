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
    ".claude/CLAUDE.md".source = ./CLAUDE.md;
  }
  // builtins.listToAttrs (
    builtins.map
      (name: {
        name = ".claude/skills/${name}";
        value.source = ../common/skills + "/${name}";
      })
      (
        [ "bro" "explain" "unslop" ]
        ++ builtins.filter (lib.hasPrefix "principle-") (builtins.attrNames (builtins.readDir ../common/skills))
      )
  );

  local.agent = {
    command = "claude";
    # claude continues the most recent conversation via a flag, not a subcommand
    resumeArgs = "--continue";
  };
}
