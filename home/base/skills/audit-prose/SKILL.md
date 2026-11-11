---
name: audit-prose
description: Audit repository comments and documentation for redundant prose and unnecessary length. Use when asked to review or assess whether comments and docs earn their place.
argument-hint: "[path filter, optional]"
---

Audit all comments and documentation in the repo, restricted to `$ARGUMENTS` if given. Read-only: don't edit files unless the user asks afterwards.

## Criteria

- Keep prose only when it conveys domain invariants or constraints that originate outside the code and cannot be derived from it. Examples include business rules, external protocol requirements, and operational constraints.
- Remove prose that restates names, types, control flow, tests, configuration, or other facts available in the repo. This includes API inventories, directory walkthroughs, and setup commands already defined in scripts.
- Explain the external reason for a constraint, not merely what the implementation does. A comment saying that a timeout is 30 seconds adds nothing; an upstream service requiring disconnection after 30 seconds explains the constraint.
- Keep each necessary fact in one authoritative place. Remove duplicates or replace them with a reference where the reference is needed.
- Use the fewest words that preserve the invariant, its conditions, and its consequences. Remove filler, generic advice, stale notes, and speculative explanations.
- Un-commented code is fine. Do not recommend prose to meet a coverage target or explain code that can be read directly.

## Review

Inspect documentation files, docstrings, and inline and block comments across source, tests, scripts, and configuration. Skip vendored and generated files; inspect their maintained sources where applicable. Read the relevant code before deciding that prose is redundant. Report any areas you could not review.

For each passage, ask what externally imposed fact would be lost if it disappeared. If none would be lost, recommend removal. If only part earns its place, keep that part and shorten it. Verify claimed external constraints against available evidence; flag uncertainty rather than inventing a rationale.

Treat executable examples and tool directives according to their function. Do not recommend deleting compiler or linter directives, required notices, or instructions that control tooling merely because they use comment or documentation syntax.

Report two lists, ordered by impact.

## 1. Prose to remove

For each:

Location: `path/to/file:line`
Text: the redundant passage, or a short excerpt identifying a larger section.
Why: what makes it unnecessary. Cite the code or authoritative source that already conveys the fact, where applicable.

## 2. Prose to shorten

For each:

Location: `path/to/file:line`
Text: the current passage.
Replacement: the shortest wording that preserves the external invariant.
Why: what must remain and what can go.

Write "None found." for an empty list. Do not manufacture findings or add comments to compensate for removals.
