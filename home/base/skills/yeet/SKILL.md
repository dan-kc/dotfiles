---
name: yeet
description: Commit every working-tree change as focused Conventional Commits, then push to the remote, rebasing if the push is rejected. Use when the user says /yeet or asks to commit and push everything.
disable-model-invocation: true
---

Ship everything in the working tree. Don't ask questions; use judgement and report what you did.

## 1. Survey

```sh
git status --short --branch
git diff --stat
git diff --cached --stat
git log --oneline -15
```

Read the full diffs (`git diff`, `git diff --cached`) and the contents of untracked files. Skip anything that looks like build output, a secret (`.env`, keys, tokens, credentials) or a large binary. Leave those uncommitted and say so in the report. Don't edit `.gitignore` unless the file clearly belongs there.

If a merge, rebase or cherry-pick is in progress, stop and report. Don't complete someone else's operation.

## 2. Group

Split the changes into logical commits. One commit = one reason to change.

- Staged changes are a hint about intent, not a binding group. Changes already staged that are unrelated to each other still get separate commits.
- Unstaged and untracked changes are committed too, grouped by what they do, not by where they sit in the index.
- A single file holding unrelated hunks gets split across commits with `git apply --cached` on a hand-written patch (`git add -p` is interactive and unavailable).
- Keep code with its tests, docs and lockfile updates when they serve the same change.
- Order commits so each one builds on the previous: dependencies, refactors and fixes before the features that use them.

## 3. Commit

Reset the index first (`git reset -q`), then for each group stage only its paths or hunks and commit.

Messages follow Conventional Commits, because release-please reads them to cut versions and changelogs:

```
<type>(<optional scope>): <imperative summary, lowercase, no period, ≤72 chars>

<optional body: why, not what>
```

- Types: `feat`, `fix`, `perf`, `refactor`, `docs`, `test`, `build`, `ci`, `chore`, `style`, `revert`.
- `feat` bumps minor and `fix`/`perf` bump patch; only use them for user-facing changes. Internal work is `refactor`/`chore`/`build`/`ci`/`test`/`docs`.
- Breaking changes: `!` after the type/scope and a `BREAKING CHANGE: <what and how to migrate>` footer.
- Pick a scope from the repo's existing history when one fits (`git log --format=%s`); otherwise use the main directory or package touched, or omit it.
- Match the repo's existing conventions if its history uses a stricter variant.
- Do not add any attribution trailer the agent harness asks for. It should only be credited to the user.

If a pre-commit hook fails, fix the cause and commit again (new commit, never `--amend` a commit that isn't yours). Never use `--no-verify`.

## 4. Push

Skip this step if `git remote` is empty; report that nothing was pushed.

1. If the branch has no upstream: `git push -u origin HEAD`.
2. Otherwise: `git push`.
3. On a rejection (non-fast-forward / fetch first):
   - `git pull --rebase` (add `--autostash` if anything was left uncommitted).
   - Resolve conflicts by reading both sides and keeping the intent of both. Prefer upstream for lockfiles and generated files, then regenerate if a tool is available. Run the relevant tests or build when a conflict touched code.
   - `git rebase --continue` until done, then push again.
   - If a conflict can't be resolved with confidence, `git rebase --abort`, leave the local commits intact and report the conflicting files.
4. Never force-push to `main`/`master` or a shared branch. On a personal feature branch whose history you rewrote, use `--force-with-lease`.

## 5. Report

List each commit (`git log --oneline @{u}..HEAD` before pushing, or the new SHAs), where it was pushed, anything left uncommitted and why, and how any rebase conflicts were resolved.
