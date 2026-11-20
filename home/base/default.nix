{ pkgs, ... }:
{
  imports = [
    ./terminal.nix
    ./fonts.nix
    ./ghostty.nix
    ./skills.nix
    ./trash.nix
  ];

  services.home-manager.autoExpire = {
    enable = true;
    timestamp = "-30 days";
  };

  home.packages = [ pkgs.gh ];

  home.file = {
    # Skills available to every agent (pi and codex both read ~/.agents/skills).
    # ".agents/skills/pair-programmer".source = ./skills/pair-programmer;
    ".agents/skills/bro".source = ./skills/pstack/bro;
    ".agents/skills/unslop".source = ./skills/pstack/unslop;
    ".claude/skills/unslop".source = ./skills/pstack/unslop;
  }
  // (
    let
      skills = builtins.readDir ./skills/pstack;
    in
    builtins.listToAttrs (
      builtins.map
        (name: {
          name = ".pi/agent/skills/${name}";
          value.source = ./skills/pstack + "/${name}";
        })
        (
          builtins.filter (
            name:
            skills.${name} == "directory"
            && builtins.elem name [
              "bro"
            ]
          ) (builtins.attrNames skills)
        )
    )
  );

  # Never change
  home.stateVersion = "24.05";
}
