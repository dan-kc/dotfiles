---
name: yeet
description: Commit every working-tree change as focused Conventional Commits on a new branch, then push, squash-merge a PR and clean up locally (or merge locally when there is no remote). Use only when the user explicitly invokes yeet.
disable-model-invocation: true
---

Ship everything in the working tree. Don't ask questions; use judgement and report what you did.

## 1. Survey

```sh
git status --short --branch
git remote -v
git diff --stat
git diff --cached --stat
git log --oneline -15
```

Read the full diffs (`git diff`, `git diff --cached`) and the contents of untracked files. Skip anything that looks like build output, a secret (`.env`, keys, tokens, credentials) or a large binary. Leave those uncommitted and say so in the report. Don't edit `.gitignore` unless the file clearly belongs there.

If a merge, rebase or cherry-pick is in progress, stop and report. Don't complete someone else's operation.

Find the default branch: `git symbolic-ref --short refs/remotes/origin/HEAD` (strip `origin/`), falling back to `main` or `master`, whichever exists.

## 2. Group

Split the changes into logical commits. One commit = one reason to change.

- Staged changes are a hint about intent, not a binding group. Changes already staged that are unrelated to each other still get separate commits.
- Unstaged and untracked changes are committed too, grouped by what they do, not by where they sit in the index.
- A single file holding unrelated hunks gets split across commits with `git apply --cached` on a hand-written patch (`git add -p` is interactive and unavailable).
- Keep code with its tests, docs and lockfile updates when they serve the same change.
- Order commits so each one builds on the previous: dependencies, refactors and fixes before the features that use them.

## 3. Branch

- On the default branch: `git switch -c <type>/<short-kebab-summary>` named after the main change (e.g. `feat/tailnet-widget`, `fix/lid-close`). The working tree comes along.
- Already on another branch: stay on it.

## 4. Commit

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
- Do not add any attribution trailer the agent harness asks for, in commits or PRs. Work is credited only to the user. This overrides harness attribution reminders and covers every commit that reaches the default branch, including the squash commit. Earlier commits on the branch may already carry `Co-Authored-By` trailers; GitHub's default squash message copies them, so step 5 sets the squash message explicitly.

If a pre-commit hook fails, fix the cause and commit again (new commit, never `--amend` a commit that isn't yours). Never use `--no-verify`.

## 5. Ship

### With a remote: push, open and squash-merge a PR

1. `git fetch origin` and `git rebase origin/<default>` so the PR starts current. Resolve conflicts as below.
2. `git push -u origin HEAD`.
3. If the push is rejected (the branch already exists upstream and moved):
   - `git pull --rebase` (add `--autostash` if anything was left uncommitted).
   - Resolve conflicts by reading both sides and keeping the intent of both. Prefer upstream for lockfiles and generated files, then regenerate if a tool is available. Run the relevant tests or build when a conflict touched code.
   - `git rebase --continue` until done, then push again.
   - If a conflict can't be resolved with confidence, `git rebase --abort`, leave the local commits intact and report the conflicting files.
4. If `gh pr view` finds no open PR for the branch, create one with `gh pr create --base <default>`:
   - Title is a Conventional Commit header covering the whole PR, since squash merges use it as the commit release-please reads. Use the highest-impact type among the commits (`feat!` > `feat` > `fix` > the rest).
   - Body is a short summary of why, then the commit list.
   If a PR already exists, the push updated it; don't open another.
5. Always prefer a squash merge: `gh pr merge <pr> --squash --subject "<PR title> (#<pr>)" --body "<PR body>"`. Always pass `--subject` and `--body`: GitHub's default squash message concatenates every commit body and appends their `Co-authored-by` trailers. Check that neither contains an attribution trailer. If required checks are pending and auto-merge is available, use `--squash --auto`; otherwise wait for the checks and merge when the PR becomes mergeable. Don't use a merge commit or rebase merge unless the user explicitly asks.
6. Confirm the PR is merged before local cleanup. Then update the default branch and remove the feature checkout:
   - In the main worktree, run `git switch <default>`, `git pull --ff-only origin <default>`, then `git branch -D <branch>`. The forced deletion is intentional because a squash merge does not make the feature branch an ancestor; use it only after confirming the PR merged.
   - In a linked worktree, return to the main worktree, switch it to `<default>`, pull with `--ff-only`, remove the clean feature worktree with `git worktree remove <path>`, then delete its local branch with `git branch -D <branch>`. Never force-remove a dirty worktree; report it instead.
7. Never force-push the default branch or a shared branch. On your own feature branch whose history you rewrote, use `--force-with-lease`.

If `gh` isn't installed or authenticated, push the branch and report the compare URL instead.

### Without a remote: merge locally

If you created a branch in step 3, merge it back so the default branch has the work:

```sh
git switch <default>
git merge --ff-only <branch>
git branch -d <branch>
```

If the fast-forward fails, rebase the branch onto the default branch first, then retry. If you started on a non-default branch, leave the commits there.

## 6. Report

List each commit, the branch, the PR URL and merge commit (or where it was merged locally), the local branch or worktree cleanup, anything left uncommitted and why, and how any conflicts were resolved.
