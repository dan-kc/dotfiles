---
name: arena
description: "Spawn N parallel candidates at the same task, pick a base, graft the strongest parts of the losers into it. Use for /arena, 'arena this', 'throw it in the arena', or when one attempt at a non-trivial artifact would lock in the wrong shape."
disable-model-invocation: true
---

# Arena

Fan out N parallel attempts at the same task. Read every candidate end to end. Pick the strongest as the base. Graft the best ideas from the others into it. Verify the synthesized result.

## Start

Open a todolist with one entry per phase before launching anything.

1. Frame
2. Fan out
3. Cross-judge
4. Pick
5. Graft
6. Verify

## Phase A: Frame

The N candidates will receive the same prompt, so the prompt is the contract.

1. State the artifact each candidate is producing.
2. Derive the rubric. State what success looks like for _this_ task, then turn it into 3-6 concrete gradeable criteria. The rubric is the picker's tool in Phase D. Candidates only see the task.
3. Pick the runners from Pi's live registry by calling `subagent({ action: "models" })`. Use exact `provider/id` values returned by Pi; do not depend on Cursor configuration, hardcoded model slugs, or models that are not in the live registry. For a three-candidate arena, choose three distinct models when available. When a fourth suitable model from another family is available, reserve it for the cross-judge. Prefer different model families for judgment-sensitive bakeoffs. If fewer than three are available, use the distinct models Pi offers and repeat only when there is no suitable alternative. Record the exact models used. If an explicit model cannot launch, report the failure and choose another listed model; do not silently fall back to an unpinned model.
4. Assign each candidate a distinct relative output path inside its managed worktree, per the **separate-before-serializing-shared-state** principle skill.

## Phase B: Fan out

Spawn all N candidates in one Pi workflow: a single `js workflow` block calling `runs.all`, followed by `subagent({ workflow: true, worktree: true })` in the same reply. Each item names its key, agent, task, exact `provider/id` model, and distinct relative output path. Pi manages one git worktree per candidate; do not pass Cursor's `run_in_background` option. Return each result and `artifactPaths` so the parent can inspect the artifacts and captured handoffs.

Each rationale names the alternatives the candidate considered and what it rejected.

Managed worktrees require a git repository with a clean working tree at the chosen source checkout. If allocation is rejected for a dirty or unsuitable checkout, stop the fan-out and report the requirement; do not disable isolation or let candidates write in the same checkout. Select a clean, appropriate base ref or checkout when available.

If a candidate fails to produce output, proceed with N-1 and note the dropout in the synthesis record.

## Phase C: Cross-judge

After all Phase B candidates complete, choose one available model from the live Pi registry, again using `subagent({ action: "models" })` and an exact `provider/id`. Prefer the reserved fourth model from a family not represented among the candidates; otherwise choose an available model from a family different from the parent when possible. Spawn one read-only judge subagent on that model. It sees the rubric and the candidate artifacts by path label, scores each criterion, and recommends a base with rationale. It runs in parallel with the parent's reading in Phase D, not with the candidates themselves. Don't spawn the judge while candidates are still writing. The judge only reads captured candidate artifacts, so it does not need a writable worktree.

## Phase D: Pick a base

Read every candidate end to end before picking.

Score each candidate against the rubric criterion by criterion, not on holistic feel. Compare against the cross-judge. Agreement on the base confirms the pick. Disagreement means one of you is biased or the rubric was ambiguous. Read both rationales before deciding.

Pick the base on which candidate a future maintainer can extend most easily without breaking invariants. Prefer the cleaner boundary or smaller API when two feel tied, per the Laziness Protocol.

Record the pick and the reason in a short synthesis note alongside the base artifact, including the cross-judge's verdict.

## Phase E: Graft

Walk each losing candidate once more and identify what is worth porting into the base. The signal is usually one or two things per candidate, not most of it.

Fold each graft in by hand, per the **redesign-from-first-principles** principle skill. Don't paste mechanically. The result has to remain coherent under one mental model.

Record what was grafted, from which candidate, and what was rejected and why.

When N candidates converge on the same shape, that is a strong agreement signal. Note the convergence in the record and ship the consensus shape. No graft is needed. When N candidates wildly diverge, Phase A was under-specified. Reframe and re-run rather than averaging the divergence.

## Phase F: Verify

The synthesized artifact has to hold up under the same scrutiny as any other output, per the **prove-it-works** principle skill.

If verification surfaces a problem the arena did not catch, either Phase A was wrong (re-frame and re-run) or one candidate caught it and you missed the graft (go back to Phase E). Don't paper over.

## Outputs

One synthesized artifact. One short synthesis note alongside, naming the base, the grafts (with source candidate), the rejections, the dropouts if any, and the verification result.
