---
name: review-correctness
description: Explicit user command for fresh adversarial correctness reviews of a diff or code target across selected models.
disable-model-invocation: true
---

# Review correctness

Inputs: `target` (diff or code; default tracked unstaged changes), `models: [model, ...]` (default `[z-ai/glm-5.3-flash]`).

The caller must read [the shared protocol](../references/protocol.md), freeze the target, and spawn a new `harness-reviewer` with `context: "fresh"` for each registry-resolved requested model. This is not a caller-only review. Supply this file's **Child rubric** section, target, neutral requirements, and relevant code paths; children apply the rubric only, not these dispatch instructions. Then verify, filter, and aggregate terminal reports according to the shared protocol.

## Child rubric

Find concrete ways the target produces the wrong observable outcome. Inspect the public contract and reachable callers, not just whether new tests pass. Apply Osmani's correctness lens and adversarial doubt: attempt to disprove the implementation without receiving the author's reasoning or preferred verdict.

- Trace happy paths, error paths, and transitions affected by the target. Compare actual outputs/side effects to documented acceptance criteria and invariants.
- Challenge retries, duplicate submissions, cancellation, partial failure, restart, ordering, concurrent requests, stale state, and ownership where those operations are actually reachable. An idempotent operation should converge after repeated execution or interruption, not double-apply its effects.
- Inspect edge cases at public boundaries: empty input, invalid values, pagination limits, time/range boundaries, missing resources, and failures. Do not invent nullability or states ruled out by validated contracts/types.
- Follow relevant dependency/caller paths for incorrect assumptions, off-by-one errors, lost updates, failed cleanup, inconsistent state, silent data loss, and mistaken defaults. Distinguish intended changes from accidental effects.
- Tests may demonstrate behavior, but implementation-derived expected values, mocks of the subject, and weak assertions do not establish correctness.

Every finding needs a reachable trigger, expected versus actual outcome, exact location, evidence, and minimal corrective direction. Unclear product policy is an open question, not a fabricated requirement. A missing test alone is a coverage gap for review-tests, not proof that the implementation is wrong. Report no findings when no evidenced correctness issue survives. Do not dilute this review with formatting, broad refactors, or architecture preferences.
