---
name: architect
description: "Sketch types, signatures, and module structure before code, then stay in the loop while implementation fills in. Use for /architect, 'architect this', 'design this', or non-trivial work where jumping to code would lock in the wrong shape."
disable-model-invocation: true
---

# Architect

Design before implementing. Sketch types, function signatures, module boundaries, and the caller's usage with `not implemented` bodies and pseudocode. Race several candidate designs through parallel subagents, synthesize one winner, then fill in code against it. If implementation proves the sketch wrong, throw it out and redesign.

## Start

Work the phases in order. The numbered list is the checklist. Finish one before starting the next, and treat skipping a phase as a decision you state with a reason.

1. Ground
2. Sketch
3. Agree
4. Implement
5. Scrap

## Phase A: Ground the problem

Build a real mental model of every system the new code touches. Trace the runtime flow through the relevant subsystems. Naming a file is not grounding. You need the traced shape. Entry points, the core types as they exist today, who owns each piece of state, where the new code must hook in, and the callers you cannot break.

For a small area, read the files yourself. For anything larger, launch a `scout` child with a single `subagent({ agent: "scout", task })` call and keep its summary in your context instead of the raw files. Read its listed key sections yourself when the sketch will hinge on them.

If the design redefines ownership or layering, also dig out why the existing shape is what it is (`git log`, old PRs, docs) so the rationale becomes a constraint rather than a guess.

Skip Phase A only when the work is genuinely greenfield with no surrounding system to integrate.

## Phase B: Sketch

Before launching candidates, call `subagent({ action: "models" })` and choose from the returned live Pi model registry. Use exact `provider/id` values from that result; never assume model names, provider availability, or a Cursor configuration file. Pick three different models when at least three suitable models are available, two when only two are available, and use the same model for two candidates only when the registry offers no alternative. Record the models used. If an explicit model cannot launch, report the failure and choose another listed model; do not silently fall back to an unpinned model.

Spawn the candidates with one `subagent` call running a workflow script. Write a `js workflow` block that fans the candidates out with `runs.all`, one child per candidate, then call `subagent({ workflow: true, worktree: true })` in the same reply. Set each child's `model` to its chosen exact `provider/id`. The workflow-level `worktree: true` gives every candidate its own managed git worktree. Each child's task text carries the runner prompt from [`references/runner-prompt.md`](references/runner-prompt.md), the Phase A grounding summary, and the relative path where it writes its design package. Each candidate writes its package per [`references/rationale-template.md`](references/rationale-template.md). Return each child's result and `artifactPaths` from the workflow so the parent can inspect every design and its captured worktree handoff.

Managed worktrees require the selected source checkout to be a git repository with a clean working tree. If allocation is rejected for a dirty or unsuitable checkout, stop the fan-out and report the exact requirement; do not disable isolation or have candidates share the source checkout. A clean, appropriate base ref or checkout may be selected when available.

Run at least two candidates, three when the design space has real contenders. Give each runner a distinct structural bet so the candidates diverge, for example one deep module with a small interface, one data-first shape built around a table or registry, one explicit state machine or reducer. Pair each bet with a different available model when possible, since identical models tend to converge. The bet and model both stay on when both are available, and a second flavor of the first shape does not count. Design it twice. Whole-shape alternatives, not point fixes inside one shape.

Then synthesize yourself. Read every candidate package. Screen each against [`references/design-red-flags.md`](references/design-red-flags.md) and revise or reject on what you find. Assume the next contributor is an agent that sees only the files it opened, copies the nearest example, and takes the shortest path that compiles. Prefer the design where a change that looks right from one file is right for the whole repo.

Compare the survivors on interface depth. Prefer the design that hides more complexity behind a smaller, simpler public surface. A rich interface can keep call chains short by concentrating capability instead of scattering it across layers.

Pick a base, graft in what the other candidates did better, and record the choice in the rationale's "Synthesis decision" section.

## Phase C: Agree (opt-in)

Default: proceed directly to implementation with the synthesized design. No human checkpoint.

Opt in to a checkpoint when the invoker explicitly asks: "/architect with checkpoint," "stop and show me before implementing," or similar. Then surface the synthesized design and pause for sign-off.

The synthesis can ship as its own commit either way, as a scaffold-first step. Planned and scoped breakage during fill-in is fine. For adversarial pressure on the design before implementing, hand the sketch to a `reviewer` agent and ask it to attack the shape, not the formatting.

If the human pushes back on the shape (in a checkpoint or after the fact), treat that as Phase A evidence. Re-ground and re-run Phase B before writing more code.

## Phase D: Implement against the sketch

Replace `not implemented` bodies with code, pseudocode with logic. The synthesized sketch is the contract.

Deviations from the sketch are signal worth surfacing, not friction to absorb silently. If a function needs a parameter the sketch didn't anticipate, ask whether the sketch was wrong, the requirement was missed, or the implementation is overreaching.

## Phase E: Scrap when the architecture is wrong

If implementation keeps producing friction the sketch can't absorb, throw the sketch out. Don't bolt fixes onto a wrong design.

The signal is a _pattern_, not single instances. Tells:

- The same shape of workaround appearing repeatedly across unrelated code.
- Multiple unrelated edge cases that all need special-case branches.
- Types that need escape hatches (`any`, casts, optional fields always set in practice) to compile.
- The "we need a lock" reflex when the sketch said the state wasn't shared.
- Callers having to know the abstraction's internal rules to use it.
- Two or more independent Phase D deviations of the same shape across the implementation.

Use judgment. A few edge cases don't condemn an architecture. Some problems are legitimately complex. Complexity in the data is not complexity in the design.

When you scrap:

1. Re-ground on what has been built, per Phase A, run against the new code.
2. Redesign as if the new constraints had been day-one assumptions.
3. Subtract before adding. The new sketch should be smaller than the old one before it grows.
4. Return to Phase B and re-run the race.

## Outputs

The caller's usage is written first and the type sketch derived from it. One file with new types and signatures for small changes. Module map plus type definitions for larger work. The rationale ships alongside, shaped per [`references/rationale-template.md`](references/rationale-template.md), including the usage sketch and the synthesis decision.
