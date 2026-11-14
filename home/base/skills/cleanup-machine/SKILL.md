---
name: cleanup-machine
description: Free disk and memory on this Mac (an agent dev box) by pruning merged worktrees, build output, caches and stale processes, then report what's left. Use only when the user explicitly invokes cleanup-machine.
disable-model-invocation: true
---

Free disk and memory without losing work. Don't ask; act on what's clearly safe, report the rest. Record `df -h /System/Volumes/Data` and `sysctl vm.swapusage` before and after.

Before deleting anything, check nothing has it open (`lsof +D <dir>`) and that no running T3 thread uses it (`t3_thread_list` with active statuses; a worktree with recent mtime or a process with its cwd there counts as in use).

## Disk

1. **Worktrees** (`~/.t3/worktrees`, `~/.codex/worktrees`, `.claude/worktrees`). Usually the biggest win: each carries its own `target/`, `node_modules`, `.build`. For each: `git fetch`, then check dirty files, commits ahead of `origin/<default>`, and `gh pr list --head <branch> --state all`.
   - Remove when clean and either nothing is ahead or the PR merged with `headRefOid` matching the local branch (squash merges leave commits "ahead"). No remote: `git log <default>..<branch>` is empty.
   - Remove with `git -C <main> worktree remove <path>`, `git branch -D <branch>`, `git worktree prune`.
   - Keep and report: dirty, unmerged, or in use.
2. **Agent trash**: `~/.local/share/Trash` and `~/.Trash`. Empty.
3. **Build output in `~/projects`**: `target`, `node_modules`, `build`, `.build`, `DerivedData`. Delete for projects not in use; keep the ones actively worked on and report their sizes.
4. **Nix**: `nix-collect-garbage --delete-older-than 14d`.
5. **Package caches**: `~/.npm/_cacache`, `~/Library/Caches/{Homebrew,pip,node-gyp,CocoaPods}`, `pnpm store prune`. Leave `~/.cargo`, `~/.rustup` and `org.swift.swiftpm` unless huge.
6. **Xcode**: `xcrun simctl delete unavailable`; `~/Library/Developer/Xcode/DerivedData`. Report but keep `iOS DeviceSupport` (needed for on-device debugging) and `Archives`.
7. **Uninstalled-app leftovers**: big dirs in `~/Library/{Caches,Application Support,Containers}` whose app isn't in `/Applications`, `~/Applications` or `mdfind kMDItemCFBundleIdentifier`. Delete caches; report app data (may hold user data) unless the user said otherwise.

Find anything else big with `du -sh ~/* ~/.[!.]* ~/Library/* | sort -h | tail`.

## Memory

8 GB machine, so swap pressure matters. List top users with `top -l 1 -o mem -n 25 -stats pid,command,mem` and check `uptime`.

- Safe to do: `killall Finder` if bloated.
- Recommend, don't do while a thread is running: reboot after long uptime or heavy swap; `xcrun simctl shutdown all`; quitting Xcode (`DTServiceHub` leaks); stale dev servers or databases (`postgres`, `node`) with no recent connections.
- Suggest excluding `~/projects`, `~/.t3` and `/nix` from Spotlight if `mds`/Spotlight are heavy.

## Report

Free space before → after. What was removed, grouped. Worktrees kept and why (branch, dirty files, PR state). Remaining big items and recommendations, largest win first.
