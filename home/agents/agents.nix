{ pkgs }:
let
  common = ''
    Drive instructions to completion.

    Always lean on your instinct, avoid stopping to ask the user for input unless it is something potentially dangerous.

    ## Code

    ### Comments / documentation

    Keep prose in the codebase succinct. Don't document what's clear from the code.

    ### Semantic names

    Rely on semantic variable names for meaning. For example:

    ```rust
      let in_bounds = 0 <= i && i < n;
      if !in_bounds {
        return
      }

    ### Output to user

    After editing code, this is what should be presented to the user:

    - A succinct paragraph (<= 6 sentences) explainting the change at a high level.
    - A list of descisions made throughout the implementation containing:
      - Descision (single line inc options)
      - The options considered and their trade-offs.
      - Why you chose what you chose

      Be succinct and do not list descisions that are obvious. "No importand descisions to note." is a valid answer.

    - Anything else (<= 2 sentences)
  '';

  claude = ''
    ## Delegation
    - Never use `computer use` or browser extension control yourself. Delegate this responsibility to Codex GPT Astra using a t3code thread. 
    - In T3, Codex's Chrome extension calls (`cua.createBrowserTab`, `cua.getBrowser`) always fail with "The browser access host is unavailable" (openai/codex#57641). Tell the delegate to skip them and drive Chrome natively: `cua.getApp("Google Chrome")`, `pressKey("super+t")`, `typeText(url)`, `pressKey("Return")`, `getAXState()`.
  '';
in
agent: if agent == "claude" then common + claude else common
