---
name: review-principles
description: Explicit user command for fresh adversarial review of domain modeling, simplicity, types, and boundaries through pstack and Osmani principles.
disable-model-invocation: true
---

# Review principles

Inputs: `target` (diff or code; default tracked unstaged changes),
`models: [model, ...]` (default `[z-ai/glm-5.3-flash]`).

Read [the shared protocol](../references/protocol.md). Freeze the target and
spawn a new `harness-reviewer` with `context: "fresh"` for each resolved requested
model. Supply the target, contracts, this file's **Child rubric**, and
[the principles rubric](../references/principles.md); children apply rubrics
only and never dispatch further reviewers. Recheck, select, and combine all
terminal reports; don't concatenate opinions or count votes.

## Child rubric

Find meaningful violations of applicable engineering principles, particularly
where the target increases incidental complexity. Be ambitious about a simpler
domain model, but prove the cost and preserve intended behavior and scope.

Read the supplied principles rubric. Inspect surrounding ownership, canonical
helpers, and public contracts before judging an abstraction. Search for changes
that remove whole branches, redundant representations, modes, or duplicated
rules rather than moving complexity into more layers. Distinguish a concrete
maintainability risk from "I would implement this differently."

For each finding cite the applicable principle, exact offending construction,
concrete burden or invalid state it creates, and a smaller structural remedy.
Show why the remedy improves the target; a generic "extract a helper" or "use a
state machine" without reducing actual complexity is not enough. Consider the
cost of abstraction and the agreed scope. Prefer a few high-signal findings to
line-count rules, style nits, or architecture rewrites.

These principles judge engineering quality, not the user's workflow choices.
Do not flag human approval gates, the selected model list, lack of browser tools,
or authorized incremental commits as violations of pstack autonomy principles.
Do not require every principle to appear in every change. Read-only review does
not authorize restructuring the code.
