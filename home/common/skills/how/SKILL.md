---
name: how
description: 'Use for "how does X work", code walkthroughs before changing something, and placement / ownership / layering questions ("where should this live", "which package owns this", "is this the right layer"). Explains subsystem architecture, runtime flow, onboarding mental models. Use why for motivation.'
disable-model-invocation: true
---

# How

Explore the codebase to answer "how does X work?" questions. Produce architectural explanations at the level of a senior engineer onboarding onto a subsystem, enough to build a working mental model, not so much that it reads like annotated source code.

Delegation uses Pi's `subagent` tool. Omit `model` so a child runs on the parent model. When the question rewards model diversity, call `subagent({ action: "models" })` and use exact `provider/id` values from the returned live registry. Never assume model names or invent slugs. If a chosen model cannot launch, report the failure and pick another listed model.

## Step 1. Assess Complexity

If the scope is ambiguous, state your interpretation and explore. The user can redirect.

- **Simple** (a single module, a small utility, a narrow question such as "how does function X work"): no explorers. One explainer explores and explains in a single pass. Go to Step 2b.
- **Complex** (a subsystem spanning multiple files or services, a cross-cutting feature, a full architectural overview): spawn parallel explorers first, then hand off to the explainer. Go to Step 2a.

When in doubt, take the simple path.

## Step 2a. Explore (complex questions only)

Decompose the question into 2 to 4 exploration angles, each a distinct slice of the subsystem. Spawn all explorers in one Pi workflow: a single `js workflow` block fanning them out with `runs.all`, then `subagent({ workflow: true })` in the same reply.

- agent: `scout` (read-only recon, returns compressed findings)
- `model`: unset to inherit the parent model, or one distinct `provider/id` from the live registry per explorer when diversity helps
- task: the prompt in `references/explorer-prompt.md` with the explorer's angle filled in

Return each result so the findings land in your context. Then go to Step 3.

## Step 2b. Direct Explain (simple questions)

Spawn one explainer child with a single `subagent({ agent: "worker", task })` call, `model` unset so it runs on the parent model. Build its task from `references/explainer-prompt.md` without the explorer-findings section. Go to Step 4.

## Step 3. Synthesize (complex questions only)

Once all explorers have returned, spawn one synthesizing explainer with a single `subagent({ agent: "worker", task })` call, `model` unset so it runs on the parent model. Build its task from `references/explainer-prompt.md` with every explorer's findings filled in.

## Step 4. Present

Present the explainer's output to the user. Light edits for clarity or context from the conversation are fine. Do not substantially rewrite it.

## Output Format

The explanation uses the sections defined in `references/explainer-prompt.md`, dropping any that do not apply: Overview, Key Concepts, How It Works, Where Things Live, Gotchas.
