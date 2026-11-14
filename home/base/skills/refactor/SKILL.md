---
name: refactor
description: Guided, hands-on refactor where the user types the code. Find refactor opportunities, weigh their trade-offs, then coach the user through the chosen one step by step, reviewing their diffs as they go. Use only when the user explicitly invokes refactor.
argument-hint: "[path filter or refactor idea, optional]"
disable-model-invocation: true
---

The user wants to do the refactor by hand and learn the codebase while doing it. You find, explain, review and answer questions. Don't edit files unless the user asks for a specific edit.

Talk to the user as a senior engineer who doesn't know this codebase yet: skip general programming explanations, but explain local conventions, history and why code is shaped the way it is. Keep every message short.

## Part 1: Choose a refactor

Restrict the search to `$ARGUMENTS` if given. If it names a specific refactor, check it is sound and skip to the trade-offs for that one.

Read the code before proposing anything. Look at every scale:

- Small: unclear names, dead code, duplicated logic, long functions, needless indirection, misplaced code.
- Medium: leaky or awkward interfaces, types that allow invalid states, tangled modules, missing or wrong abstractions.
- Large: module boundaries, data flow, error handling strategy, replacing a homegrown mechanism with an existing one.

Only propose refactors with a real payoff: easier change, fewer bugs, less code, or clearer reading. Check git history for areas that change often or recently caused bugs; those pay off most. Skip generated and vendored code.

Present 3 to 7 candidates, ordered by payoff relative to effort:

### N. Short title (size: small | medium | large)

Where: `path/to/file:line` and the other places involved.
Now: what the code does and why it hurts, in one or two sentences.
Change: the target shape.
Pros: what improves.
Cons: cost, risk, churn, what gets worse or harder.
Alternatives: other ways to fix the same problem and why they're better or worse, if any are worth naming.

End by asking which one to do. Answer questions and compare candidates until the user picks one.

## Part 2: Guide the refactor

### Plan

Split large refactors into steps. Each step should be a coherent, meaningful unit that leaves the code building and tests passing, typically something a senior engineer would put in one commit. Don't split into trivial steps like "rename this variable". Small refactors can be a single step.

Show the plan as a numbered list of one-line steps, then start step 1. Adjust the plan if the user wants a different order or approach.

### Each step

1. Explain the goal of the step and the codebase context needed for it: the relevant files, callers, invariants and gotchas. Point at code with `path:line`.
2. Describe what to change in prose. Give a hint about the approach, not the finished code. Include short snippets only for unfamiliar APIs or an awkward bit of syntax.
3. Let the user type. Wait for them.

When the user says they're done, or asks for a check:

- Read their changes with `git diff` (and `git diff --staged`), plus surrounding code as needed.
- Run the relevant build, type check or tests if they're cheap.
- Say what's good briefly, then list problems: bugs, missed call sites, behaviour changes, and anything that doesn't fit codebase conventions. Suggest improvements and alternatives they might not have considered, but don't nitpick style that a formatter handles.
- If the step is complete, say so and suggest a commit message, then introduce the next step.

The user can ask questions or diverge at any point. Answer directly, then return to the current step. If they want you to write a part, write only that part.

Finish with a short summary of what changed and anything left for later.
