---
name: review-regressions
description: Explicit user command for fresh adversarial diff-only review of previously supported behavior broken by a change.
disable-model-invocation: true
---

# Review regressions

Inputs: `target` (**diff only**; default tracked unstaged changes), `models: [model, ...]` (default `[z-ai/glm-5.3-flash]`).

Read [the shared protocol](../references/protocol.md). Reject standalone code targets: request the before/after patch instead of inventing a baseline. Freeze the patch and launch a new `harness-reviewer` with `context: "fresh"` for each resolved requested model. Supply only patch, revision metadata, this file's **Child rubric**, and reporting rules. Children never dispatch other reviewers. The caller also stays inside the diff-only evidence boundary when filtering and aggregating results; surrounding code cannot rescue an unsupported finding.

## Child rubric

Find previously supported behavior that the patch itself shows will now break. This is a deliberately limited adversarial review, not a whole-codebase audit. Read removed/context lines as the old implementation and added/context lines as the new implementation. Do not read files, tests, prior revisions, repository history, external documentation, conversation context, or other reviewers' work. Only read the provided patch artifact and this supplied rubric/protocol.

Look for:

- Removed cases, guards, validation, error handling, cleanup, and fallbacks.
- Changed defaults, null/empty semantics, return types, output formatting, status codes, ordering, pagination, or persisted representations.
- Broken compatibility apparent within the patch: renamed/removed public parameters, exported symbols, configuration keys, or serialization fields.
- New side effects, lost idempotency, skipped awaits, reordered operations, narrowed conditions, or changed ownership checks where their effect is shown.
- Deleted tests/assertions that document a behavior also demonstrably changed. Deleting a test alone does not prove that behavior broke.

For every finding provide **old behavior**, **new behavior**, the same reachable input/action under both, exact patch evidence for both, user/caller impact, and a minimal regression test at the public boundary. Distinguish intended visible changes from accidental breakage; if intention is unknowable, say so and qualify the finding. A new feature's missing case is not a regression unless the old behavior was supported. Do not substitute style, code quality, or general test coverage findings for a before/after behavioral break.

If omitted context would decide the claim, report the limitation instead of asserting a defect. "No substantiated findings from this diff" is a valid result and never a guarantee of full compatibility. Never claim outside-code validation.
