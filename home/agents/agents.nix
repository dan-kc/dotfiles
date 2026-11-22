{ pkgs }:
let
  common = ''
    Drive instructions to completion.

    Always lean on your instinct, avoid stopping to ask the user for input unless it is something potentially dangerous. 
    Present important descisions that user ought to know at completion.       
    Be succinct and do not list descisions that are obvious. "No importand descisions to note." is a valid answer.

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
    ```

  '';

  claude = "";
  for_captain = ''
    ### Talking to the user about code

    Assume the user's only interface is the thread. They cannot open files. Avoid quoting function names, filenames or line numbers as the user cannot act on these. Whenever you discuss code, show the code or diff in the chat. Truncate bits (e.g: `// ...`) as needed to show the essense of what you are conveying.
    Never point at code with only a path and line range (e.g. "`lib.rs:216-227`, `collaboration.rs:250-328`").
    Show changes as diffs:

    ```diff
     fn handle(req: Request) -> Response {
    -    let body = req.body().unwrap();
    +    let Some(body) = req.body() else {
    +        return Response::bad_request();
    +    };
         // ...
     }
    ```

  '';
in
agent: if agent == "claude" then common + claude else common
