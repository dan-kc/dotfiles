{ lib, pkgs, ... }:
let
  skills = [
    ./skills/audit-prose
    ./skills/audit-tests
    ./skills/yeet
  ];

  explicitOnly = "disable-model-invocation: true\n";

  codexSkill =
    skill:
    let
      skillText = builtins.readFile (skill + "/SKILL.md");
    in
    if lib.hasInfix explicitOnly skillText then
      assert lib.assertMsg (builtins.pathExists (
        skill + "/agents/openai.yaml"
      )) "${baseNameOf skill} needs agents/openai.yaml for its Codex invocation policy";
      pkgs.runCommand "${baseNameOf skill}-codex-skill" { } ''
        mkdir -p "$out"
        cp -R ${skill}/. "$out/"
        chmod -R u+w "$out"
        substituteInPlace "$out/SKILL.md" \
          --replace-fail ${lib.escapeShellArg explicitOnly} ""
      ''
    else
      skill;

  install = root: skill: source: {
    "${root}/${baseNameOf skill}".source = source;
  };
in
{
  home.file = lib.mkMerge (
    lib.concatMap (skill: [
      (install ".claude/skills" skill skill)
      (install ".agents/skills" skill (codexSkill skill))
    ]) skills
  );
}
