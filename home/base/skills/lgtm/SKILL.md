---
name: lgtm
description: Prepare and open a persistent browser review grouped by purpose, then retrieve user comments.
---

Use the installed `lgtm` command, or `python3 /path/to/lgtm.py` from a source checkout.

1. For new reviews, let capture generate a unique session ID. For restart/resume requests, reuse the ID from the conversation and run `open --session ID`. If unknown, use `list --workspace PATH` to find the saved review by label. Never recapture or regenerate a review to restart its server.
2. Derive the comparison from the user's prompt before invoking lgtm. Generate a Git-format unified patch using `git diff --no-ext-diff --no-textconv --no-color` with the appropriate arguments: `A B` for two commit endpoints, `--cached HEAD` for staged changes, no revision for unstaged changes, `HEAD` for staged and unstaged tracked changes together, or `BASE...HEAD` for branch changes since the merge base. These scopes are distinct; choose the one the user requested. Account for requested untracked files separately without changing the user's index. Avoid combined merge diffs; choose explicit parent/endpoints.
3. Save that output to a temporary patch file and check Git's exit status before capture. Run `capture --patch /path/to/review.patch --label "Description of chosen scope"`. Stdin is also supported with `--patch -`; use pipefail in shells that support it so producer errors are visible. The tool consumes the supplied patch without running Git. Do not pass --base or --repo alongside --patch.
4. Read the snapshot path printed by capture; its parent directory name is the session ID (NAME below). Retain that ID in the conversation. Write a JSON guide with title and groups. Each group has a unique id, title, explanation, and blocks listing snapshot block IDs. Group by purpose; one file can occur in several groups. Cover every block. Explain intent and what the reviewer should check, without inventing changes.
5. Run `guide --session NAME guide.json`, then `open --session NAME`. Give the user the URL. Opening returns immediately, leaving the conversation available.
6. When the user requests it, run `feedback --session NAME` and address their comments. Do not interpret incomplete review state as approval. Browser heartbeats keep the server alive; it stops after ten minutes without them. `open` restarts it with saved progress. `stop --session NAME` explicitly stops it without deleting state. The server runs independently after `open` returns; continue the conversation and retrieve feedback when the user is ready.

Sessions are immutable snapshots. Never update them to reflect later working-tree edits. Comments, checked files, collapsed files and navigation are saved independently. A review checkbox belongs to a file within a particular group.
