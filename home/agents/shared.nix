{ pkgs, ... }:
let
  prompts = import ./prompts.nix { inherit pkgs; };
in
{
  home.file = {
    ".claude/CLAUDE.md".source = pkgs.writeText "agent-instructions.md" prompts.claude;
    ".pi/agent/AGENTS.md".source = pkgs.writeText "agent-instructions.md" prompts.pi;
    ".codex/AGENTS.md".source = pkgs.writeText "agent-instructions.md" prompts.codex;
  };
}
