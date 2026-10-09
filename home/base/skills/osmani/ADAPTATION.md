# Osmani skills for this Pi setup

24 skills are enabled through the pi-only Home Manager source. The dedicated
`browser-testing-with-devtools` skill is intentionally removed at the user’s request.
Every skill reads [pi-runtime.md](references/pi-runtime.md) once per session.
The remaining skill names stay stable. Four upstream specialist profiles are
installed alongside the existing general pi profiles.
Claude's configuration and the adapted pstack collection receive no new changes
from this adaptation.

## What changed

| Area                    | Pi behavior                                                                                                                 |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| Invocation              | `/skill:<name>` and file reads; no assumed Osmani slash-command wrappers                                                    |
| Questions               | Installed `question` tool or chat, with prior answers and authorization retained                                            |
| Delegation              | Upstream code-reviewer/security-auditor/test-engineer/web-performance-auditor profiles, alongside existing general profiles |
| Independent review      | Fresh child context; explicit second-opinion offer each interactive doubt cycle using the model registry                    |
| Parallel work           | pi-subagents 0.75.0 `runs.all`, terminal results, managed worktrees and patch handoffs                                      |
| Browser verification    | Dedicated skill and mandatory live checks removed; no browser tools installed or launched                                   |
| Documentation retrieval | Supporting OpenRouter server-side search/fetch or verified local tools; no assumed MCP                                      |
| Context                 | `AGENTS.md`, bounded reads, scout digests, pi compaction and durable handoffs                                               |
| Lifecycle               | Explicit intent confirmation; human approval of capability map, spec, and plan before downstream phases                     |
| Git                     | Commit each verified increment; parent owns commits and preserves unrelated staged/unstaged work                            |
| Constraints             | Project tooling/dev environment, including Nix; no assumed post-edit hook or another harness's config                       |
| Diagnostics             | Secret scans and the floor-guard example avoid printing matched source snippets                                             |

The reviewer profile can inspect code and Git evidence but cannot run builds,
edit files, or perform mutation testing. Those tasks belong to the parent,
test-engineer, or a worker. The imported
code/security/performance reviewers are also read-only; test-engineer can write
and execute tests but is read-only during the shipping coverage pass. Fresh
children still inherit this setup's global/project instructions;
their independence is from the parent's conversation, not those instructions.

## Review coverage

Reviewed every imported skill, all shared and skill-specific references, the
ideation examples/frameworks/rubric, and the bundled initializer script against
the local pi module, extensions, existing and imported specialist profiles, and installed pi-subagents
0.75.0 documentation/schema. The shared runtime contract applies to all entry
points; engineering guidance stays intact where no harness adaptation is needed.

| Skills                                                  | Adaptation focus                                                                   |
| ------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| using-agent-skills                                      | Pi invocation, selective loading, workflow scale                                   |
| interview-me, idea-refine                               | Pi questions, explicit intent-confirmation gate, correct script paths              |
| spec-driven-development, planning-and-task-breakdown    | Restored human approval gates, read-only planner, sibling links                    |
| incremental-implementation, git-workflow-and-versioning | Restored per-increment commits, safe recovery, managed worktrees                   |
| doubt-driven-development, code-review-and-quality       | Fresh pi reviewers, different models, read-only review restrictions                |
| context-engineering, source-driven-development          | Pi context and actual retrieval capabilities                                       |
| browser-testing-with-devtools, test-driven-development  | Browser skill removed; testing uses existing non-browser tooling and test-engineer |
| constraint-driven-development                           | Pi/Nix environment, lifecycle commands, redacted guard reports                     |
| performance-optimization, security-and-hardening        | Available profiling tools, redacted scans and corrected example fences             |
| api-and-interface-design, frontend-ui-engineering       | Shared runtime and stack-appropriate checks; domain guidance retained              |
| code-simplification, debugging-and-error-recovery       | Pi project rules and shared execution/recovery contract                            |
| ci-cd-and-automation, shipping-and-launch               | Shared authorization and applicability contract; deployment guidance retained      |
| deprecation-and-migration, documentation-and-adrs       | Pi rules and shared contract; migration/documentation guidance retained            |
| observability-and-instrumentation                       | Shared runtime and applicability contract; telemetry guidance retained             |

## User-selected workflow

- Preserve upstream specialist rubrics and report formats in four pi profiles.
- Preserve the three-specialist shipping fan-out and parent synthesis.
- Restore explicit intent confirmation and later-turn spec/plan approval gates.
- Offer a cross-model second opinion in each interactive doubt cycle, using pi's
  registry instead of external CLIs. Wait for selection/skip; honor standing choices.
- Restore a commit after each verified logical increment. The parent stages only
  task-owned changes and preserves unrelated staging/edits.
- Remove the browser-testing skill and mandatory live browser checks. The web
  performance auditor reads source and supplied measurement artifacts only.
- Retain targeted recovery instead of blanket hard reset.

## Remaining limitations

No short Osmani command wrappers are installed. Invoke native `/skill:<name>`
commands; the shipping skill points to the specialist fan-out recipe. Agent Teams
is represented through parent-mediated investigation, not teammate messaging.
UI behavior without supplied evidence remains unverified, rather than passed.

## Validation scope

Validation passed against the installed packages:

- Pi discovers `bro` and all 24 enabled Osmani skills without diagnostics.
- All local Markdown references resolve.
- pi-subagents discovers all four specialist profiles with the intended tools
  and global/project instruction inheritance.
- The parallel-review example validates against pi-subagents 0.75.0.
- The floor-guard example returns its documented 0/1/2 exit statuses and does
  not print matched source snippets.
- The bundled ideation shell script passes `bash -n`.
- Home Manager evaluates with Osmani enabled in both personal pi configurations
  and absent from Claude's configuration.

These checks do not launch model children or prove every workflow has executed
successfully on every model or project. Live browser execution is intentionally excluded. Home Manager has not been activated.
