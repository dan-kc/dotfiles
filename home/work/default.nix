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
        value.source =
          if name == "explain" then ../base/skills/explain else ../base/skills/pstack + "/${name}";
      })
      (
        [
          "bro"
          "explain"
          "unslop"
        ]
        ++ builtins.filter (lib.hasPrefix "principle-") (
          builtins.attrNames (builtins.readDir ../base/skills/pstack)
        )
      )
  );

  local.agent = {
    command = "claude";
    # claude continues the most recent conversation via a flag, not a subcommand
    resumeArgs = "--continue";
  };
}
