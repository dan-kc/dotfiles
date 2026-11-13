---
name: audit-tests
description: Audit test coverage and quality, reporting missing behaviour coverage, tests to strengthen or remove, and potential flakes. Use when asked to audit or assess tests, not as a general correctness review.
argument-hint: "[path filter, optional]"
---

Audit tests, restricted to `$ARGUMENTS` if given. Read-only: don't edit files or run tests unless the user asks afterwards. Follow any `REVIEW.md` in the repo.

## Criteria

- Test behaviour at a supported boundary: API, CLI, library, or UI. Unit tests of public contracts are fine.
- Assert observable outputs, errors, or effects, not private state or internal call order. Expected values come from the contract, not the implementation.
- Each test covers one scenario. Multiple steps and assertions are fine when the scenario needs them.
- Tests are deterministic, but don't fake away the behaviour under test.

## Review

Read the supported entry points first, then the matching tests. Focus on reachable behaviour that matters; don't invent features or demand a test per branch. Check parameterised tests, helpers, and other test layers before calling something missing. Skip generated and vendored files.

Challenge each candidate: could the behaviour break while this test stays green? Would a harmless refactor break it? What protection is lost by removing it? Zero findings is fine. Report any areas you couldn't review.

## Report

Four lists, ordered by impact. Write "None found." for an empty list. Write example tests in the project's language using real APIs.

### 1. Missing tests

Behaviour: the user does X then Y.
Expectation: what they observe.
Proposed test: the smallest test that would catch a regression.

### 2. Tests to strengthen

Test: `path/to/file:line`
Problem: the weak assertion or coupling to internals.
Fix: the replacement, keeping the protection it already gives.

### 3. Tests to remove

Test: `path/to/file:line`
Why: why no unique protection is lost. For duplicates, cite the test that remains.

### 4. Potential flakes

Look for sleeps, timeouts, clocks, timezones, randomness, ordering, shared state, external services, and async races.

Test: `path/to/file:line`
Risk: what can vary and how it fails.
Fix: a deterministic replacement (isolated fixture, controlled clock, wait-for-condition, etc.).
