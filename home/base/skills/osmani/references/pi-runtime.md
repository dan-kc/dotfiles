# Pi runtime contract

This pack targets this repository's pi configuration: pi-subagents 0.75.0,
the `question` extension, pi-guardrails, and OpenRouter server-side search/fetch.
Read this once when using an Osmani skill in a session. The user's request,
project `AGENTS.md`, and actual tool schema take precedence over examples here.

## Skills and paths

Pi discovers all 24 enabled `SKILL.md` files recursively. Invoke one with
`/skill:<name>`, or use `read` on its listed file path when it applies.
There is no separate Skill tool or installed Osmani lifecycle command layer.
Skill names in prose mean read that sibling's `SKILL.md`, then follow it.
Resolve links and bundled scripts relative to the loaded skill file, never
relative to the project's working directory. Write outputs in the project,
not under `~/.pi/agent/skills` or the Nix store; installed skills are read-only.

## Available tools

| Need | Pi mechanism |
|---|---|
| Inspect files | `read`, `grep`, `find`, `ls`; `bash` with `rg` for broader searches |
| Change files | `edit` / `write`, or the project's existing tools through `bash` |
| Run checks | `bash` with repository commands; enter the project's Nix/dev environment when required |
| Clarify a choice | `question` for a useful option list; ordinary chat for free-form input |
| Delegate | `subagent`; see [orchestration-patterns.md](orchestration-patterns.md) |
| Search/fetch docs | OpenRouter server-side web search/fetch on supporting models, or a verified local CLI through `bash` |

Do not invent client `WebSearch`/`WebFetch` tool names for provider-side tools.
Check actual retrieval support before delegating research to another provider.
This setup intentionally omits the browser-testing skill and live browser tools.
Do not install, discover, or launch Playwright/Cypress/CDP/DevTools tooling as
part of these workflows. Browser execution, screenshots, Lighthouse/axe scans,
and live Core Web Vitals measurements are not mandatory completion gates.
Use source inspection, existing non-browser checks, and supplied artifacts.
Mark visual/accessibility/performance behavior unverified where no evidence
exists; do not count source inspection as a browser measurement. If an explicit
user acceptance criterion needs browser evidence, report the gap for the user
to resolve rather than silently passing it or adding tools.

## Agent roles

Keep the existing `scout`, `planner`, `reviewer`, and `worker` profiles for general
pi work. For Osmani workflows use the installed specialist profiles:
`code-reviewer`, `security-auditor`, `test-engineer`, and
`web-performance-auditor`. Their prompts preserve Addy's domain instructions
and report formats. The parent provides the relevant skill paths in each brief.

Code/security/performance reviewers inspect without editing or executing project
code; the performance auditor interprets supplied measurement artifacts rather
than installing or driving browser tools. `test-engineer` can write and execute
tests, but gets a read-only coverage brief during the shipping fan-out. The local
generic `reviewer` remains restricted to file reads and read-only Git inspection.
`planner` only reads and plans. Use `worker` for general implementation and checks.

Children do not inherit the parent's conversation by default. Supply the scope,
constraints, exact paths, relevant skill paths, evidence, and expected report.
Use `context: "fresh"` explicitly for an independent review. These local profiles
inherit project/global instructions; fresh context does not remove those rules.
The parent handles user questions and reconciles results. Children should return
missing information or review requests to the parent, not spawn more children.

Omit `model` to inherit the parent model. In interactive doubt-driven review,
offer a different-model second opinion each cycle: discover available exact
`provider/id` values with `subagent({ action: "models" })`, recommend a suitable
choice, and wait for the user to select or skip before launching. Honor explicit
standing model choices. State the models used, skips, and gaps. Do not hardcode
model names, launch external model CLIs, or change execution mode on failure.

## Scope, checkpoints, and verification

This setup deliberately restores Addy's human checkpoints. Confirm the concrete
intent with an explicit yes and deliver it without starting downstream work in
that turn. Present a capability map when needed and wait for approval before
module specs. Save and present the spec, then stop; planning begins only after
approval in a later turn. Save and present the plan and task list, then stop;
implementation begins only after their approval. Honor review checkpoints within
the plan. A general build request does not waive these phase gates; an explicit
user instruction to bypass a gate takes precedence. Preserve guardrail prompts
and project review gates. Prepare concrete artifacts before requesting approval.

After implementation is approved, commit each verified logical increment with a
descriptive message. Incremental commits are enabled for this setup; do not ask
again for every slice. The parent owns staging/commits from delegated work.
Capture the initial staged/unstaged state and commit only task-owned changes;
preserve unrelated edits and their staging state. Never use blanket staging or
reset, discard the user's changes, or silently stash/commit their work to make
worktree allocation succeed. Push, merge, publish, production data changes, and
deployment still need authorization covering the actual action.

Use the skill's relevant checks for the detected stack and changed surface.
Examples using npm, browser budgets, databases, or service telemetry do not make
those technologies mandatory. For Nix configuration, prefer formatting and
evaluation/build checks as appropriate; do not invent unit tests for prose edits.
Record checks that passed, failed, or were unavailable. A capability gap is not
a passing check. Keep secrets out of tool output and reports.
