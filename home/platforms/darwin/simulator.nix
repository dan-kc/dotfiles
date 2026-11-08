{ pkgs, ... }:
{
  home.packages = [
    (import ./simulator-cleanup.nix { inherit pkgs; })
    (import ./sim-claim.nix { inherit pkgs; })
  ];

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
