{
  pkgs,
  config,
  ...
}:
let
  piExtensionExamples = "${pkgs.pi-coding-agent}/lib/node_modules/pi-monorepo/examples/extensions";
  piSubagentsVersion = "0.75.0";
  piGuardrailsVersion = "0.19.0";
in
{
  home.file = {
    ".pi/agent/extensions/question.ts".source = "${piExtensionExamples}/question.ts";
    # pi-subagents reads its config from the directory its package occupies.
    ".pi/agent/extensions/subagent/config.json".text = builtins.toJSON {
      # Register subagent from the first request; no loader tool.
      toolActivation = "eager";
      # Trim feature groups this setup does not use from the tool schema.
      # Re-enable by removing names from this list.
      disabledFeatures = [
        "missions"
        "panes"
        "watchdog"
        "lane-management"
        "lane-metadata"
        "external-machines"
        "control-overrides"
        "extension-bindings"
        "spawn-budget-grants"
        "preflight"
      ];
    };
    ".pi/agent/extensions/context.ts".source = ./extensions/context.ts;
    ".pi/agent/extensions/openrouter-server-tools.ts".source = ./extensions/openrouter-server-tools.ts;
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

    ".pi/agent/agents/scout.md".source = ./agents/scout.md;
    ".pi/agent/agents/planner.md".source = ./agents/planner.md;
    ".pi/agent/agents/reviewer.md".source = ./agents/reviewer.md;
    ".pi/agent/agents/worker.md".source = ./agents/worker.md;
    ".pi/agent/agents/comment-sicko.md".source = ./agents/comment-sicko.md;

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
      defaultProvider = "openrouter";
      defaultModel = "z-ai/glm-5.3-flash";
      defaultThinkingLevel = "medium";
      theme = "nix-colors";
      quietStartup = true;
      lastChangelogVersion = pkgs.pi-coding-agent.version;
      npmCommand = [ "${pkgs.nodejs}/bin/npm" ];
      packages = [
        "npm:@aliou/pi-guardrails@${piGuardrailsVersion}"
        "npm:pi-subagents@${piSubagentsVersion}"
      ];
    };
    context = builtins.readFile ./pi-context.md;
  };

  nixpkgs.overlays = [
    (_final: prev: {
      pi-coding-agent = prev.pi-coding-agent.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + (builtins.readFile ./pi-post-install.sh);
      });
    })
  ];
}
