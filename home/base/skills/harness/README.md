# Harness review commands

Five user-invoked adversarial review skills for pi. They are hidden from model skill discovery (`disable-model-invocation: true`), while remaining accessible through native `/skill:review-*` commands. Thin prompt templates provide the short commands below. No additional tools or model SDKs are installed.

| Command | Lens | Accepted target |
| --- | --- | --- |
| `/review-correctness` | Contract violations and incorrect outcomes | Diff or code |
| `/review-tests` | Untested user behaviors and tests coupled to internals | Diff or code |
| `/review-principles` | Domain models, boundaries, simplicity, maintainability | Diff or code |
| `/review-security` | Reachable vulnerabilities and trust boundaries | Diff or code |
| `/review-regressions` | Previously supported behavior broken by a change | Diff only |

Every command accepts `target` and `models`. Omitted target means tracked unstaged changes. Omitted models means `[z-ai/glm-5.3-flash]`; the registry must resolve it to an available exact provider/id, normally `openrouter/z-ai/glm-5.3-flash`. An unavailable model is reported, not replaced.

```text
/review-tests target: staged
/review-correctness target: src/orders.ts:40-130
/review-security target: unstaged models: [z-ai/glm-5.3-flash, openai/example-model]
/review-regressions target: main...HEAD
```

The second model above is illustrative; use identifiers from pi's live registry. Pasted code/patches and explicit patch paths also work. Code ranges include the file path and line numbers. `A...B` is merge-base-to-B; `A..B` compares endpoints. Untracked files need an explicit code target; they are not included in git diff.

The caller freezes one target, launches one fresh `harness-reviewer` per selected model, then checks, filters, and combines findings. Children inherit neither parent conversation nor global/project context. Relevant written contracts must be supplied explicitly. All reviews are read-only; test writing and fixes are separate work. Regression review and its final synthesis use only the patch.

Rubrics draw on pstack's adversarial review and lead judgment, domain modeling, type/boundary discipline, idempotency, and behavior-focused tests; and Osmani's correctness, testing, security, and adversarial doubt workflows. The shared protocol preserves their emphasis on evidence and independent judgment without importing lifecycle gates or conflicting autonomy rules into review commands.

Validation uses the installed pi skill/prompt loaders and pi-subagents registry and workflow validator. All five skills are discoverable for user invocation and omitted from the model skill prompt; aliases preserve target/model arguments; the reviewer disables context inheritance; and a mocked two-model workflow preserves model/report association. Home Manager evaluation confirms installation in both personal pi configurations and absence from Claude. No live model review or Home Manager activation was performed during these checks.
