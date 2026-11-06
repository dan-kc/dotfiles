{ pkgs, ... }:
let
  instructions = agent: pkgs.writeText "agent-instructions.md" (import ./agents.nix { inherit pkgs; } agent);
in
{
  home.file = {
    ".claude/CLAUDE.md".source = instructions "claude";
    ".pi/agent/AGENTS.md".source = instructions "pi";
    ".codex/AGENTS.md".source = instructions "codex";
  };
}
