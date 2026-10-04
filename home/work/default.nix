{
  lib,
  ...
}:
{
  # The work machine owns its existing .zshenv outside Home Manager.

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "claude-code" ];

  programs.claude-code.enable = true;

  home.file =
    let
      skills = builtins.readDir ../common/skills;
    in
    {
      "./.zshenv".enable = false;
    }
    // builtins.listToAttrs (
      builtins.map (name: {
        name = ".claude/skills/${name}";
        value.source = ../common/skills + "/${name}";
      }) (builtins.filter (name: skills.${name} == "directory") (builtins.attrNames skills))
    );

  local.agent = {
    command = "claude";
    # claude continues the most recent conversation via a flag, not a subcommand
    resumeArgs = "--continue";
  };
}
