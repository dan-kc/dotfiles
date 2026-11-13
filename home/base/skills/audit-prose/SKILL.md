---
name: audit-prose
description: Audit repository comments and documentation for redundant prose and unnecessary length while preserving useful contracts, rationale, and reader guidance. Use when asked whether comments and docs earn their place.
argument-hint: "[path filter, optional]"
---

Audit comments and documentation, restricted to `$ARGUMENTS` if given. Read-only: don't edit files unless the user asks afterwards. Follow any `REVIEW.md` in the repo.

## Criteria

- Inline comments should explain a non-obvious constraint, rationale, or hazard. Remove ones that restate names, types, or control flow. Uncommented code is fine.
- Public docs should help readers use supported interfaces correctly. Being derivable from code doesn't make them redundant.
- Setup docs should let readers complete a task without reverse-engineering the repo. Point to scripts; don't copy them into prose.
- Design notes and review exceptions that record a decision and its rationale earn their place.
- Keep one authoritative source per fact. A short pointer elsewhere is fine.
- Prefer clear wording with nothing extra. Don't suggest rewording purely as taste.

## Review

Inspect docs, docstrings, and comments across source, tests, scripts, and config. Skip vendored and generated files. Read the relevant code before judging a passage.

For each passage, ask what a reader would lose if it disappeared. Recommend removal only if nothing useful is lost. Leave compiler/linter directives, required notices, and tool instructions alone. Try to disprove each finding before reporting it; zero findings is fine. Report any areas you couldn't review.

## Report

Two lists, ordered by impact. Write "None found." for an empty list.

### 1. Prose to remove

Location: `path/to/file:line`
Text: the passage, or an excerpt identifying it.
Why: why nothing useful is lost. Cite where the fact already lives, if applicable.

### 2. Prose to shorten

Location: `path/to/file:line`
Text: the current passage.
Replacement: the proposed wording.
Why: what must remain and what can go.
