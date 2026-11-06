{ pkgs }:
let
  # Use pkgs.stdenv.isDarwin / isLinux here when platform-specific text is needed.
  common = ''
    Drive instructions to completion.

    Keep READMEs succinct. Don't document every feature or repeat what's clear from the code.

    Always lean on your instinct, avoid asking the user questions unless:
    - The task may be harmful to the user
    - The feature will be difficult to test or verify

    After completing the solution, present the descisions made as a list.
    - Descision (single line inc options)
    - The trade offs
    - The explaination of the descsision and why these trade-off are good.
  '';

  claude = ''

    ## Delegation
    - Prefer T3 `delegate_task` to Codex (ChatGPT), latest GPT Astra model.
    - Never use computer use or browser control yourself. Delegate it to Codex GPT Astra.
    - In T3, Codex's Chrome extension calls (`cua.createBrowserTab`, `cua.getBrowser`) always fail with "The browser access host is unavailable" (openai/codex#57641). Tell the delegate to skip them and drive Chrome natively: `cua.getApp("Google Chrome")`, `pressKey("super+t")`, `typeText(url)`, `pressKey("Return")`, `getAXState()`.
  '';
in
agent: if agent == "claude" then common + claude else common
