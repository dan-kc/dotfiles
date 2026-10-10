---
name: review-tests
description: Explicit user command for fresh adversarial discovery of untested user behaviors and tests coupled to implementation details.
disable-model-invocation: true
---

# Review tests

Inputs: `target` (diff or code; default tracked unstaged changes), `models: [model, ...]` (default `[z-ai/glm-5.3-flash]`).

Read [the shared protocol](../references/protocol.md). The caller freezes the target and spawns one new `harness-reviewer` with `context: "fresh"` per requested available model. Supply this file's **Child rubric**, target, requirements, and matching source/test paths; children apply the rubric, never the dispatch steps. Require a behavioral coverage report, then independently filter and aggregate all terminal results. This command inspects tests; it does not write/run them.

## Child rubric

Be the adversary of the author's test suite. Discover user behavior the change affects that the tests fail to exercise or assert. "User" includes CLI users, API clients, library callers, and actors interacting through supported public boundaries. Browser tooling is not required or installed.

### Discover independently, then inspect coverage

1. Read the intent/public contract and affected public entry points **before reading the tests**. Derive plausible action sequences from the behavior, not a checklist of internal functions or implementation branches.
2. Challenge happy paths and relevant alternatives: repeat/retry after timeout, cancellation and resume, invalid/empty input and recovery, permission changes, stale reads, competing updates, reordered responses, partial failure, restart, boundary values, and interactions with existing supported behavior. Apply only scenarios reachable within the target's scope and contracts.
3. Read the matching tests. Map each important scenario to specific assertions, not merely test names, executed lines, or coverage percentages. Classify it covered, partially asserted, missing, or unknown because evidence is absent.
4. Ask: could the user-visible behavior be wrong while this test remains green? Conversely, would a behavior-preserving refactor make this test fail?

### Assert behavior, not internals

- Invoke the supported entry point and assert concrete observable outputs, responses, persisted effects, emitted public events, or documented errors.
- Unit tests of public/domain contracts are welcome. Private helper invocation, internal state layout, method-call order/counts, and source/prompt substring checks are not behavior evidence unless that property is itself a documented external contract. Reading internals to understand a defect is allowed; requiring tests to pin them is not.
- Prefer real domain logic; replace nondeterministic external boundaries with controlled fakes. Mocking the subject or its internal collaborators can erase the behavior being tested. Boundary-effect assertions can be valid when their payload/result is the actual contract; call-count-only checks are usually weak.
- Expected outcomes must come from the contract, not the same implementation or helper under test. Reject fixture-asserts-fixture and tautological assertions.
- An absence/error assertion can be rigorous (no second charge, rejected input, deleted resource). Assess its setup, real execution, and counterfactual; do not mechanically reject every negative assertion or force unrelated positive ones.
- Propose a concrete public-boundary test that would detect the claimed defect. Describe the failing-before/fixed-after evidence needed; do not claim execution happened. No blanket demand for a test of every internal function.

### Required report

For each material gap, state actor and initial state, action sequence, expected observable result, current test/assertion evidence or the search establishing its absence, risk, and a minimal proposed test. Distinguish **missing behavior coverage**, **weak/internal assertions**, and **demonstrated implementation defects**. Missing coverage is not automatically a proven bug. Include the reviewed behavior-to-test map; avoid exhaustive low-risk permutations or invented features. Unknown coverage must be reported as unknown. An important untested retry path outweighs dozens of internal helper tests.
