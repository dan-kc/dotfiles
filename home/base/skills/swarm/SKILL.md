---
name: swarm
description: "Fan out N parallel workers, drain them, and return one report. Use for /swarm, 'swarm this', or parallel coverage, races, gauntlets, and exploration."
disable-model-invocation: true
---

# Swarm

Fan out N parallel workers. They may cover separate slices, race the same brief, or mix both. The parent waits, aggregates, and returns one report.

## Start

Open a todolist with one entry per phase before launching anything.

1. Frame
2. Fan out
3. Aggregate
4. Report

## Phase A: Frame

1. State the done predicate and the artifact or report the swarm must return.
2. Choose the shape. Partition into slices, race N workers on identical briefs, or mix both. For a race or mixed shape, declare `first pass`, `rank all`, or `best-of` before spawning.
3. Set N from the user or derive it from the shape. N is total workers, not a concurrency limit.
4. Pick the worker models. Default: omit `model`, so every worker runs on the parent model. For a model race or a family-diverse swarm, call `subagent({ action: "models" })` and name each arm's exact `provider/id` up front. Never assume model names or invent slugs. If a chosen model cannot launch, report the failure and pick another listed model.
5. Give each worker its own output path when it writes. When workers modify or verify commits, run the fan-out with `worktree: true` so Pi gives each worker its own managed git worktree, and each brief names the exact SHAs. A measurement brief also names the method (sample count, what one sample is, order). The worker records both in its result.

## Phase B: Fan out

Spawn all N workers in one Pi workflow: a single `js workflow` block fanning them out with `runs.all`, followed by `subagent({ workflow: true })` in the same reply. Each item names its key, `agent: "worker"`, its task, and its `model` from step 4 (unset for inherit-parent). Pi child processes run locally with isolated context, so give each task explicit file pointers and prevent concurrent writes to shared paths.

When a worker must start from a non-default base, name that base ref in its brief and in the workflow's `baseRef` when workers run in worktrees.

Every brief stands alone. Include the goal, scope, exact slice or race arm, how to verify, and what to report. Reports use `PASS`, `ISSUES`, or `BLOCKED` with evidence. A worker that can prove a defect reports `ISSUES` and lists every issue it can prove, not only the first.

If a worker drops out, proceed with N-1 and note it.

## Phase C: Aggregate

Read the terminal results. Drop a result that does not record the SHAs and method its brief names, and respawn that worker once. After a second miss, record a gap. A gap does not count as a pass. For coverage, every required slice needs a result. For a race, apply the selection rule declared up front. Use first pass, rank all, or best-of. Do not paste raw worker dumps.

Keep a compact result table, one-line evidenced issues, and explicit gaps or dropouts.

## Phase D: Report

Return one consolidated in-chat report with the table, issue one-liners, gaps or dropouts, and the race rule when used.
