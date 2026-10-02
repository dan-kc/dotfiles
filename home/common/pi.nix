{
  pkgs,
  config,
  ...
}:
let
  piExtensionExamples = "${pkgs.pi-coding-agent}/lib/node_modules/pi-monorepo/examples/extensions";
  piSubagentExample = "${piExtensionExamples}/subagent";
  piGuardrailsVersion = "0.19.0";
in
{
  home.file = {
    ".pi/agent/extensions/subagent/index.ts".source = "${piSubagentExample}/index.ts";
    ".pi/agent/extensions/subagent/agents.ts".source = "${piSubagentExample}/agents.ts";
    ".pi/agent/extensions/question.ts".source = "${piExtensionExamples}/question.ts";
    ".pi/agent/extensions/context.ts".source = ./pi/extensions/context.ts;
    ".pi/agent/extensions/openrouter-web-search.ts".source = ./pi/extensions/openrouter-web-search.ts;
    ".pi/agent/extensions/guardrails.json".text = builtins.toJSON {
      "$schema" =
        "https://raw.githubusercontent.com/aliou/pi-guardrails/v${piGuardrailsVersion}/schema.json";
      version = piGuardrailsVersion;
      enabled = true;
      applyBuiltinDefaults = true;
      onboarding = {
        completed = true;
        version = piGuardrailsVersion;
      };
      features = {
        policies = true;
        permissionGate = true;
        pathAccess = true;
      };
      pathAccess = {
        mode = "ask";
        allowedPaths = [
          {
            kind = "file";
            path = "/dev/null";
          }
          {
            # Read-only at the filesystem level; grants pi access to the Nix
            # environment (store paths, built outputs, docs) without prompting.
            kind = "directory";
            path = "/nix/store";
          }
          {
            kind = "directory";
            path = "/nix/var";
          }
        ];
      };
      policies.rules = [
        {
          id = "protect-ssh-keys";
          name = "SSH keys";
          patterns = [ { pattern = "~/.ssh/**"; } ];
          protection = "noAccess";
        }
        {
          id = "protect-gnupg";
          name = "GnuPG keys";
          patterns = [ { pattern = "~/.gnupg/**"; } ];
          protection = "noAccess";
        }
        {
          id = "protect-cloud-credentials";
          name = "Cloud provider credentials";
          patterns = [
            { pattern = "~/.aws/**"; }
            { pattern = "~/.netrc"; }
            { pattern = "~/.kube/config"; }
          ];
          protection = "noAccess";
        }
        {
          # Read-only so pi can inspect its own agents/extensions but cannot
          # self-modify generated config (managed in Nix anyway).
          id = "protect-pi-config";
          name = "Pi agent config";
          patterns = [ { pattern = "~/.pi/**"; } ];
          protection = "readOnly";
        }
        {
          # Shell startup files and git config are persistence vectors
          # (aliases, hooks, env vars injected into future sessions).
          id = "protect-shell-and-git-config";
          name = "Shell startup files and git config";
          patterns = [
            { pattern = "~/.bashrc"; }
            { pattern = "~/.bash_profile"; }
            { pattern = "~/.profile"; }
            { pattern = "~/.zshrc"; }
            { pattern = "~/.zprofile"; }
            { pattern = "~/.zshenv"; }
            { pattern = "~/.gitconfig"; }
            { pattern = "~/.gitignore_global"; }
          ];
          protection = "readOnly";
        }
      ];
      permissionGate = {
        requireConfirmation = true;
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
        patterns = [
          {
            pattern = "brew";
            description = "Homebrew package manager";
          }
        ];
      };
    };

    ".pi/agent/agents/scout.md".source = ./pi/agents/scout.md;
    ".pi/agent/agents/planner.md".source = ./pi/agents/planner.md;
    ".pi/agent/agents/reviewer.md".source = ./pi/agents/reviewer.md;
    ".pi/agent/agents/worker.md".source = ./pi/agents/worker.md;

    ".pi/agent/prompts/implement.md".source = "${piSubagentExample}/prompts/implement.md";
    ".pi/agent/prompts/scout-and-plan.md".source = "${piSubagentExample}/prompts/scout-and-plan.md";
    ".pi/agent/prompts/implement-and-review.md".source =
      "${piSubagentExample}/prompts/implement-and-review.md";

    ".pi/agent/themes/nix-colors.json".text = builtins.toJSON {
      "$schema" =
        "https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json";
      name = "nix-colors";
      vars = builtins.mapAttrs (_: color: "#${color}") config.colorScheme.palette;
      colors = {
        accent = "base0D";
        border = "base03";
        borderAccent = "base0D";
        borderMuted = "base02";
        success = "base0B";
        error = "base08";
        warning = "base0A";
        muted = "base04";
        dim = "base03";
        text = "";
        thinkingText = "base04";
        scrollbarTrack = "base02";
        scrollbarThumb = "base04";

        selectedBg = "base02";
        searchMatchBg = "base0A";
        searchMatchText = "base00";
        userMessageBg = "base01";
        userMessageText = "base05";
        customMessageBg = "base01";
        customMessageText = "base05";
        customMessageLabel = "base0E";
        toolPendingBg = "base01";
        toolSuccessBg = "base01";
        toolErrorBg = "base01";
        toolTitle = "base0D";
        toolOutput = "";

        mdHeading = "base0A";
        mdLink = "base0D";
        mdLinkUrl = "base04";
        mdCode = "base0C";
        mdCodeBlock = "";
        mdCodeBlockBorder = "base03";
        mdQuote = "base04";
        mdQuoteBorder = "base03";
        mdHr = "base03";
        mdListBullet = "base0C";

        toolDiffAdded = "base0B";
        toolDiffRemoved = "base08";
        toolDiffContext = "base04";

        syntaxComment = "base03";
        syntaxKeyword = "base0E";
        syntaxFunction = "base0D";
        syntaxVariable = "base08";
        syntaxString = "base0B";
        syntaxNumber = "base09";
        syntaxType = "base0A";
        syntaxOperator = "base0C";
        syntaxPunctuation = "base05";

        thinkingOff = "base03";
        thinkingMinimal = "base04";
        thinkingLow = "base0D";
        thinkingMedium = "base0C";
        thinkingHigh = "base0E";
        thinkingXhigh = "base09";
        thinkingMax = "base08";
        bashMode = "base0A";
      };
      export = {
        pageBg = "base00";
        cardBg = "base01";
        infoBg = "base02";
      };
    };
  };

  programs.pi-coding-agent = {
    enable = true;
    settings = {
      defaultProvider = "openai-codex";
      defaultModel = "gpt-5.6-sol";
      defaultThinkingLevel = "medium";
      theme = "nix-colors";
      quietStartup = true;
      lastChangelogVersion = pkgs.pi-coding-agent.version;
      npmCommand = [ "${pkgs.nodejs}/bin/npm" ];
      packages = [ "npm:@aliou/pi-guardrails@${piGuardrailsVersion}" ];
    };
    # The zsh wrapper passes a single space to --system-prompt: Pi treats it as
    # a custom prompt, suppressing its default preamble without adding visible
    # content. The replaced generic prompt remains available at
    # ${pkgs.pi-coding-agent}/lib/node_modules/pi-monorepo/dist/core/system-prompt.js.
    context = ''
      You are a pair programmer working with a senior engineer who is new to the current codebase.

      For coding work, keep the user actively involved while you investigate and implement:

      - Build a shared understanding of the relevant code before changing it.
      - Explain codebase-specific behaviour and constraints without teaching basic programming concepts unless asked.
      - Surface meaningful design choices, tradeoffs, and uncertainty before committing to a direction.
      - Ask focused questions when an answer affects the design or scope.
      - Work in small, coherent increments: usually one concept, function, or similarly reviewable change at a time.
      - Before each increment, explain the problem it addresses and the intended change.
      - After each increment, show what changed, how it was verified, and what remains.
      - Pause at useful checkpoints so the user can question the reasoning or redirect the implementation.
      - Do not silently complete a multi-part implementation or present a large finished solution for retrospective review.

      Treat the user as the decision-making partner. Recommend a direction when appropriate, but make the relevant tradeoffs visible.
    '';
  };

  nixpkgs.overlays = [
    (_final: prev: {
      pi-coding-agent = prev.pi-coding-agent.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          pi_bundle="$out/lib/node_modules/pi-monorepo/dist/bundle"
          command_file=$(grep -R -l 'name:"quit",description:`Quit ' "$pi_bundle" | head -n1)
          subagent_file="$out/lib/node_modules/pi-monorepo/examples/extensions/subagent/index.ts"

          substituteInPlace "$command_file" \
            --replace-fail '{name:"quit",description:`Quit ''${APP_NAME}`}' \
                           '{name:"quit",description:`Quit ''${APP_NAME}`},{name:"exit",description:`Quit ''${APP_NAME}`}' \
            --replace-fail 'if(text==="/quit"){this.editor.setText(""),await this.shutdown();return}' \
                           'if(text==="/quit"||text==="/exit"){this.editor.setText(""),await this.shutdown();return}'

          substituteInPlace "$subagent_file" \
            --replace-fail 'const COLLAPSED_ITEM_COUNT = 10;' \
                           'const COLLAPSED_ITEM_COUNT = 5;' \
            --replace-fail 'renderDisplayItems(displayItems, 5)' \
                           'renderDisplayItems(displayItems, 3)'
        '';
      });
    })
  ];
}
