{ inputs, pkgs, ... }:
{
  home.packages = [ inputs.lgtm.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  home.file = builtins.listToAttrs (
    map (directory: {
      name = "${directory}/lgtm";
      value.source = ../../base/skills/lgtm;
    }) [
      ".agents/skills"
      ".claude/skills"
    ]
  );
}
