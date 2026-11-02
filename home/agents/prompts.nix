{ pkgs }:
let
  # Use pkgs.stdenv.isDarwin / isLinux here when platform-specific text is needed.
  common = ''
    Drive instructions to completion.

    Always lean on your instinct, avoid asking the user questions unless:
    - The task may be harmful to the user
    - The feature will be difficult to test or verify

    After completing the solution, present the descisions made as a list.
    - Descision (single line inc options)
    - The trade offs
    - The explaination of the descsision and why these trade-off are good.
  '';
in
{
  # Each agent can extend the common text independently.
  claude = common;
  pi = common;
  codex = common;
}
