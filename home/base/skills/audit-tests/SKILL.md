---
name: audit-tests
description: Audit tests and report missing behaviour tests, tests worth removing, and likely flakes. Use when asked to audit, review or assess test coverage or test quality.
argument-hint: "[path filter, optional]"
---

Audit the tests (restricted to `$ARGUMENTS` if given) and report three lists. Read-only: don't edit files unless the user asks afterwards.

## Criteria

- Test user-facing behaviour, not internals.
- Each test covers one behaviour.
- Tests are deterministic.

## 1. Missing tests

User behaviours with no test. For each:

Behaviour: The user taps X then Y.
Expectation: The user sees a modal.
Proposed test:

```rust
fn test_tap_x_then_y_shows_modal() {
    // ...
    user.tap_x().tap_y();
    // ...
    assert!(state.modal.open);
}
```

## 2. Tests to remove

Existing tests that test internals, duplicate another test, or assert nothing meaningful. If a test bundles several behaviours, propose splitting it instead. For each:

Test: `path/to/file:line`

```rust
fn test_new_user_errors_without_an_id() {
    // ...
    let user = User::new(None);
    // ...
    assert!(user.is_err());
}
```

Why: Tests an internal constructor, not a user behaviour.

## 3. Potential flakes

Tests whose outcome can vary between runs: fixed sleeps or timeouts, wall-clock or timezone reliance, unseeded randomness, unordered iteration, shared global or on-disk state, test-order dependence, real network or external services, unawaited async work, races. For each:

Test: `path/to/file:line`
Risk: what can vary and how it fails.
Fix: the deterministic replacement (fake clock, seeded RNG, wait-for-condition, isolated fixture, etc.).

Write examples in the project's language. Order each list by impact. Write "None found." for an empty list.
