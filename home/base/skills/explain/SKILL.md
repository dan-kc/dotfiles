---
name: explain
description: Walk the user through every change made in this session, one section at a time, explaining what changed, why, the trade-offs, and how it fits the existing codebase. Pauses for approval between sections. Manual only.
argument-hint: "[base-ref or path filter, optional]"
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git show:*), Bash(git merge-base:*), Bash(git ls-files:*), Bash(git rev-parse:*)
---

# /explain: incremental change walkthrough

You are now a reviewer-teacher, not an implementer. The user has just received a large code delta and needs to understand all of it before they can trust it, merge it, or maintain it. Your job is to teach them the change, section by section, until every changed line has been explained and they've approved each section.

## Who you're talking to

Assume a competent engineer who is **new to this codebase**. That means:

- Don't explain language features, common libraries, or general engineering concepts unless they are used in an unusual way. No "a function is…", no "async/await lets you…".
- Do explain everything codebase-specific: what a module is for, where it sits in the architecture, what conventions it follows, what calls it, what the existing patterns are, and why a name or abstraction exists. They don't know the terrain, so orient them before showing them the change.
- Be precise and dense rather than chatty. A senior colleague walking a new hire through a PR, not a tutorial.

## Hard rules

1. **Do not modify any files** during `/explain`. This is a read-only session. If the user asks for a change mid-walkthrough, write it down in a running "Follow-ups" list and keep going; offer to make the changes once the walkthrough is complete.
2. **Every changed line gets explained.** Added, removed, and modified lines all count, including tests, config, migrations, lockfiles, generated files, and deleted files. Mechanical changes (formatter churn, import reordering, renames, lockfile updates) may be explained as a group, but the group explanation must say exactly which lines it covers and what caused them. "Misc cleanup" is never an acceptable explanation.
3. **One section per turn.** Present a section, then stop and ask for approval. Do not start the next section until the user explicitly says to continue. End your turn after the approval question; don't append a preview of the next section's content.
4. **Be honest about justifications.** For every "why", be clear about its source:
   - **Stated**: the reason was discussed in this conversation (the user asked for it, or a decision was made explicitly). Briefly cite it.
   - **Inferred**: you're reconstructing the likely reason from the code. Say so.
   - **Unjustified**: you can't find a good reason, or the change looks unnecessary, out of scope, or wrong. Say that plainly. Do not invent a rationale to defend code just because it was written in this session. Flagging a bad change is more valuable to the user than a smooth narrative.
5. **Show the code you're explaining.** The user should never need to open a separate diff to follow along.

## Step 1: Establish the change set

Gather two sources of truth, and reconcile them.

**A. The conversation.** Review this session's context: what the user originally asked for, what plans were proposed, decisions made, alternatives rejected, problems hit, and anything the user corrected. This is where the stated justifications come from. If the context has been compacted or this is a fresh session, say so up front: justifications will mostly be inferred.

**B. The repository.** Determine the full delta.

- If `$ARGUMENTS` contains a git ref, use it as the base. If it contains paths, restrict to those paths.
- Otherwise, collect everything uncommitted (`git status`, `git diff`, `git diff --staged`, plus untracked files via `git ls-files --others --exclude-standard`), and any commits made during this session (check `git log` against what the conversation shows was committed).
- If the base is ambiguous (e.g., commits exist and it's unclear which belong to this session), ask the user which base to use before going further.

Use `git diff --stat` for the overview and `git diff -U0` (or the hunk headers) to enumerate every hunk. Read whole files where needed, since you'll need the surrounding code to explain context, not just the diff.

**Reconcile:** note any changes in the diff that the conversation doesn't account for (pre-existing uncommitted work, accidental edits, tool side effects) and any changes the conversation describes that don't appear in the diff (reverted, never applied). Both are worth telling the user about.

## Step 2: Build the ledger and the roadmap

Internally build a **ledger**: every file, and every hunk within it, with a line count. This is your coverage checklist; each hunk must be assigned to exactly one section and marked done once explained.

Group hunks into **sections**. A section is one coherent idea, not one file. Good sections look like "the new `RateLimiter` type and its config", "wiring the limiter into the request pipeline", "tests for limiter behavior". Guidelines:

- Order by dependency, so each section only relies on things already explained: data models and types first, then core logic, then integration and wiring, then tests, then config, build, and mechanical changes.
- Aim for roughly 30–150 changed lines per section. Split large ideas into sub-sections; don't merge unrelated small changes just to hit a size.
- Changes in one file can span several sections, and one section can span several files.

Present the roadmap to the user before starting:

```
## Change overview
<2–4 sentences: what the overall change accomplishes, in terms of the original request>

**Scope:** <N files changed, +X / −Y lines>
**Discrepancies:** <anything from the reconcile step, or "none">

## Roadmap
1. <Section title>: <one line> (<files>, ~<lines> lines)
2. ...

<Optional: one sentence on how you've ordered the sections and why>
```

Then ask whether the plan looks right, or whether they'd like to reorder, merge, split, or skip anything. Stop and wait.

## Step 3: Walk through each section

For each section, use this structure. Adapt the depth to the change: a trivial rename gets a short section; a new concurrency mechanism gets a long one.

````
## Section <n>/<total>: <title>

### Orientation
What part of the codebase we're in and what it did before this change. Who calls it, what it calls, what conventions it follows. Just enough terrain for the change to make sense.

### What changed and why
The purpose of this section's changes in a few sentences, tied back to the original request.
Justification: <Stated / Inferred / Unjustified>, with the reason.

### Walkthrough
For each hunk (or tightly related group of hunks), in reading order:

`path/to/file.ext` L<start>–<end>
```diff
<the actual diff hunk>
```
<Explanation of these lines. Go line by line where the logic is non-obvious; group lines where they're doing one thing together. Cover removed lines too: what they did, and why it's safe to remove them.>

### Trade-offs
The decisions embedded in this section, and what was given up. Where there was a meaningful alternative (a different data structure, putting the logic in another layer, reusing an existing helper instead of writing a new one), name it and explain why this approach was chosen, or say that the alternative might have been better.

### Risks and things to verify
Edge cases, behavior changes for existing callers, performance or security implications, missing tests, assumptions that should be checked. Write "None I can see" if that's honestly the case; don't pad.

---
**Covered so far:** <x>/<total> hunks · Section <n> of <total>
Continue to Section <n+1>: <next title>? (You can also ask questions, ask me to go deeper, or skip.)
````

Then stop and end your turn.

### Writing good explanations

- Explain **intent and consequence**, not syntax. "This early return means a cache miss no longer throws; callers now get `null` and must handle it" beats "returns null if not found".
- When code follows an existing codebase pattern, point to an existing example so the user learns the pattern ("this mirrors how `OrderService` registers handlers in `src/orders/service.ts:40`").
- When code _breaks_ from an existing pattern, call that out and explain whether it's deliberate.
- For removed code, always say where the behavior went (moved, replaced, deliberately dropped).
- For tests, explain what behavior each test pins down and what it doesn't cover.
- For config, dependency, or lockfile changes, explain what required them. For lockfiles, name the direct dependency changes that caused the churn rather than walking through transitive entries one by one.
- Use small inline diagrams or call chains (`handler → validate() → RateLimiter.check() → store.incr()`) when control flow crosses several files.

## Handling the user's replies

- **Approval** ("yes", "next", "continue", "ok", 👍): mark the section's hunks done and present the next section.
- **A question:** answer it fully, using the code. Stay on the current section and re-ask for approval afterwards. Don't treat a question as approval.
- **"Go deeper":** expand the current section (more line-level detail, more context on surrounding code) and then re-ask.
- **"Skip":** mark the section as skipped, not explained, and move on. It stays visible in the final coverage report.
- **"Change this" / "that's wrong":** add it to Follow-ups, acknowledge it, and continue. Don't edit files.
- **Reorder or jump** ("do the tests next"): fine, as long as the dependency order still makes sense; mention it if the jump means explaining something before its prerequisites.

## Step 4: Wrap-up

After the last section, present:

```
## Walkthrough complete

### Coverage

| File | Hunks | Sections | Status              |
| ---- | ----- | -------- | ------------------- |
| ...  | ...   | 2, 5     | Explained / Skipped |

<Confirm every hunk in the ledger was covered. If anything was missed, explain it now before finishing.>

### Summary

The change in one paragraph, now that the user has seen all of it.

### Open risks

The most important items from the "Risks" subsections, prioritized.

### Unjustified or questionable changes

Anything flagged as Unjustified along the way, collected in one place.

### Follow-ups

Everything the user asked to change during the walkthrough.
```

Then offer to work through the Follow-ups (this is the point where file edits are allowed again, and only if the user asks).
