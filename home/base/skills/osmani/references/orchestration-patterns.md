# Pi orchestration patterns

The main pi session owns delegation and synthesis. Use the existing profiles,
load domain skills by path, and keep one level of children. Read
[pi-runtime.md](pi-runtime.md) for role restrictions and authorization.

## Direct work is the default

Do small, bounded tasks in the main session. For a substantial investigation,
use `scout`; for a design plan, `planner`; for independent Osmani code review,
`code-reviewer`; for security, `security-auditor`; for test work, `test-engineer`;
for a web-specific audit, `web-performance-auditor`. Use `worker` for general
implementation or verification. The existing generic `reviewer` remains available.
Do not add a router agent that only paraphrases another agent's result.

One child uses one call. Substitute a concrete brief and project cwd:

```js
subagent({
  agent: "code-reviewer",
  context: "fresh",
  task: "Read the specified diff and acceptance criteria. Review correctness and security. Do not edit or run builds. Return evidenced findings with file:line, severity, and gaps."
});
```

A brief must include the goal, scope, constraints, exact file/skill paths,
expected artifact or report, and verification evidence. Point at source files
and contracts rather than repeatedly summarizing summaries. A reviewer needs
artifact + contract, not the author's conclusion.

## Shipping reviews in parallel

Use one `js workflow` block and one `subagent({ workflow: true, async: true })`
call in the same assistant reply. Example for a project with `SPEC.md`; replace
these paths with the actual contract and Osmani skill locations first:

```js workflow
const results = await runs.all([
  {
    key: "correctness",
    agent: "code-reviewer",
    context: "fresh",
    task: "Read SPEC.md, git diff, and ~/.pi/agent/skills/osmani/skills/code-review-and-quality/SKILL.md. Perform Addy's five-axis review and return your standard report. Do not edit or run builds. Include file:line, evidence, severity, and verification gaps."
  },
  {
    key: "security",
    agent: "security-auditor",
    context: "fresh",
    task: "Read SPEC.md, git diff, and ~/.pi/agent/skills/osmani/skills/security-and-hardening/SKILL.md. Audit changed trust boundaries and vulnerabilities. Do not edit or run builds. Return your standard security report with evidence and gaps."
  },
  {
    key: "tests",
    agent: "test-engineer",
    context: "fresh",
    task: "Read SPEC.md, git diff, changed tests, and ~/.pi/agent/skills/osmani/skills/test-driven-development/SKILL.md. Analyze coverage gaps for happy paths, boundaries, errors, and concurrency. This shipping pass is read-only: do not write tests or execute project code. Return your standard coverage report."
  }
]);
return results.map((result, index) => ({
  angle: ["correctness", "security", "tests"][index],
  runId: result.runId,
  ok: result.ok,
  output: result.output,
  artifactPaths: result.artifactPaths
}));
```

`runs.all` returns an ordered array. Leave child `async` unset so the workflow
awaits final results. Top-level `async: true` lets the parent receive a workflow
receipt and continue independent work. Use `subagent({ action: "status", id })`
with the returned run id when needed; a dispatch receipt is not a completed
review. Consume terminal child reports before declaring coverage complete.

Preserve Addy's shipping fan-out: skip it only when the change touches at most
two files, is under 50 lines, and does not touch auth, payments, data access, or
configuration/environment. The main session merges the three reports into a
GO/NO-GO decision, checks applicable accessibility/infrastructure/documentation,
and supplies a rollback plan. Critical findings block GO unless explicitly
accepted by the user. A GO verdict does not itself authorize deployment.

For cross-model second opinions, query `subagent({ action: "models" })`, offer
a shortlist, and wait for a choice or skip before launching. Honor an explicit
standing choice. Set exact `model: "provider/id"` values from the registry;
otherwise omit `model` to inherit the parent. Report launch failures and gaps.

The parent rechecks every finding, distinguishes defects from suggestions,
then fixes within scope or assigns a `worker`/`test-engineer`. Read-only review children do not
mutate code or run verification. A `worker` can run checks in a bounded brief,
returning exact commands, outcomes, and changed files. The parent commits each verified slice.

## Parallel implementation

Freeze shared contracts first. Independent writers use `worktree: true` on each
workflow child (or as a workflow default). Give each a distinct task and artifact
path; return `artifactPaths` so the parent can inspect patches/handoffs.

Managed worktrees require a clean Git source checkout. If dirty, report the
requirement and select an appropriate clean checkout when available. Do not
silently stash, commit, discard edits, or drop isolation. Sequential work with
one writer is an alternative only when it still meets the task's contract.

`baseRef` accepts supported named refs (`HEAD`, `refs/heads/release`,
`refs/tags/v1`, `origin/main`), not raw commit IDs or expressions like `HEAD~1`.
Record the resolved commit in each result; named refs can move. Managed worktrees
start from that commit and do not include an uncommitted parent diff. Review
uncommitted work read-only in its actual cwd, or pass a captured artifact.

Inspect and integrate each child patch in dependency order. Handoffs and a
successful child exit do not prove the combined changes work: run integration
checks after applying them. Let pi-subagents manage owned worktree cleanup;
never delete a dirty or uncaptured worktree by hand.

## Competing hypotheses

For an intermittent bug, fan out `scout` children with distinct hypotheses and
shared reproduction evidence. Each reports observations and a distinguishing
test, rather than modifying code. The parent compares them, then passes the
strongest counter-evidence to a fresh specialist reviewer or a `test-engineer`/`worker` assigned to run
that test. Stop when evidence rules out the alternatives and the reproduction
passes after the fix.

This is parent-mediated investigation. It does not assume teammate messaging,
Agent Teams, shared task-list services, or disabled mission/lane features.

## Sequential lifecycle

The user directs specify → plan → implement → verify → review → ship. Preserve
Addy's phase gates: present and confirm intent; stop after presenting the spec
and wait for approval in a later turn; do the same for the concrete plan/task
list before implementing. Approve capability maps before module specs and honor
human checkpoints inside the task list. Keep scope and acceptance criteria in
durable artifacts. Delegate bounded work; avoid a coordinator that only relays
summaries. During approved implementation, commit each verified logical slice.

A spec-only, plan-only, or interview-only request ends at its requested artifact.
Deployment, merge, and publishing are separate actions unless the user has
already authorized them. No Osmani `/spec`, `/plan`, `/build`, `/ship`, or similar
wrapper commands are installed; use `/skill:<name>` or read the skill directly.

## Bounded review and recovery

Cap fix/review loops at three substantive cycles, or stop earlier when findings
are resolved or only optional suggestions remain. Do not review the same
unchanged artifact again for reassurance. Unresolved issues after the cap are
reported as unresolved, not converted into a pass.

On a child or workflow failure, preserve its run/status and any partial diff.
Diagnose and retry through the same pi-subagents protocol when justified. Do not
switch to an external agent CLI or claim a self-review was independent. Report
missing coverage. Workflow scripts have no filesystem, shell, or arbitrary pi
tool access; give that work to the appropriate child.

Validate nontrivial scripts without launching children using
`subagent({ action: "validate", workflow: true })` and a block in the same reply,
or `subagent({ action: "validate", workflow: "./workflows/review.js" })`.

## Sources

Verified against the installed pi-subagents 0.75.0 package and local agent files.
See the [pinned workflow guide](https://github.com/nicobailon/pi-subagents/blob/v0.75.0/docs/workflows.md)
and [tool reference](https://github.com/nicobailon/pi-subagents/blob/v0.75.0/docs/tool-reference.md).
