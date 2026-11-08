---
name: shared-ios-simulator
description: Use only when the user explicitly requests viewing or controlling this Mac's simulator from their iPhone, through T3 Connect, or in T3's Device panel, including recovery of that requested connection. Also use whenever T3 device tools report the shared simulator busy (`DEVICE_IN_USE`) or a session expired (`SESSION_IDLE_EXPIRED`). Do not invoke otherwise for routine local simulator testing.
---

This skill applies only on Daniel's Mac (Darwin). It is installed across projects by the macOS Home Manager module; do not apply this device identity or recovery procedure on Linux or another host.

## When to open a preview

Remote preview is opt-in for the current work; building, fixing or testing an app does not request one. An explicit request remains valid while completing that work and recovering its connection.

Local simulator testing needs no preview request. Follow runtime device-tool requirements without adding remote-viewing setup or invitations.

For “launch/show the simulator,” use `device_list` only if IDs are unknown, then `device_open`. Once the preview opens, perform only runtime-required checks, leave it open and confirm briefly. Do not launch an app, inspect accessibility, tap navigation or take extra screenshots unless requested or needed to diagnose a reported preview failure. A working preview satisfies the request even if app automation is locked.

This Mac has one simulator: iPhone 18 Pro `4469D43E-D1C0-4E0B-9CAC-8684C5522DAF`. Never create, clone or boot another device, for interactive work or tests; a second booted simulator costs ~1.3 GB on an 8 GB machine that is already swapping. Automated tests run on it through `sim-claim -- <command>`, which queues in the same line as agents, gives the command `SIM_CLAIM_UDID`, and releases on exit. Keep project build/test commands and bundle IDs in the project skill.

- For requested app work, take the simulator with `sim-claim --open <agent-device command> <bundle-id>` (see below), never a bare `open`, before interaction. Then use the returned `agent-device` command directly. Use it for launches, taps, text, screenshots and recordings; inspect with `device_screenshot`. Verify interaction only when it is part of the task.
- Follow the active runtime’s ownership/retry rules. Never stop another session, delete locks, kill automation processes, or erase app data to bypass ownership. Release only your own session when supported.
- A running simulator needs no cleanup. Only when the runtime permits recovery and the user explicitly approves stopping **all** T3 device sessions on this Mac, run `simulator-cleanup --confirmed`. Existing approval suffices. App data stays; other threads lose control. Reopen through device tools and verify interaction. Stop if recovery fails or the runtime forbids it.

## Taking the simulator: queue, don't stop

Other worktrees' agents and test scripts share this simulator, first come, first served. `device_open` and previews never wait; only opening an app takes the simulator.

1. Do any remaining work that doesn't need the device first.
2. Run `sim-claim --open <agent-device command> <bundle-id> [open args]`, giving the shell call a 600000 ms timeout. It joins the shared queue, waits for its turn, then runs the bound `open` and exits 0 holding the simulator.
3. Exit 75 means still queued after 9 minutes. Re-run the identical command straight away to keep your place; a gap over 3 minutes sends you to the back. Repeat for up to 60 minutes. Tell the user once that you're queued; don't ask whether to continue.
4. Only after 60 minutes, ask the owner to release (next section). If that also fails, report the owning session and stop.

Once you hold it, reinstall your own build before interacting: `<agent-device command> install <bundle-id> <path-to-.app>` from this worktree's build output (path in the project skill). Another worktree of the same app may have installed its build while you waited. App data is shared between worktrees of the same app, so don't assume state you left earlier.

A `sim-claim-<dir>-<pid>` owner is a test run, not a thread; it releases when the tests end. Only wait for it, never message or stop it. To run your own simulator tests, use the project's test command, which goes through `sim-claim`; never point xcodebuild at the simulator directly.

Claims idle for 20 minutes expire automatically (`AGENT_DEVICE_SESSION_IDLE_TIMEOUT_MS`). If your own session answers `SESSION_NOT_FOUND` with `SESSION_IDLE_EXPIRED`, call `device_open` again, re-run `sim-claim --open …` with the new command, and continue; you rejoin at the back of the queue.

Release as soon as the device step finishes, even mid-task: `device_close` with `shutdown:false`. Reopen later if needed. Holding the claim through long builds or reasoning blocks every other agent.

## Device held by another T3 thread

Use this recovery only after the wait above runs out. Prefer asking the owner to release its session over global cleanup. Follow runtime messaging and retry rules.

1. Record the `DEVICE_IN_USE` session ID, host ID, device UUID and any workspace path in the error. A `t3-…` device session ID is **not** a thread UUID. Do not pass it to `t3_thread_send` or run another thread's bound launcher.
2. Find the owning thread using T3 tools. Use `t3_project_list` to match the workspace, then `t3_thread_list` with `includeSubagents: true`, paging through candidates and including settled threads. `t3_thread_search` alone is insufficient: it skips subagents and may miss settled work. Start with the indicated project; widen the search only if needed.
3. Match the session deterministically. T3's `AgentDeviceTarget.ts` derives it as `"t3-" + SHA256(JSON.stringify([threadId, hostId, deviceId])).slice(0, 24)`. For example, compute candidates with Python's `hashlib.sha256(json.dumps([thread_id, host_id, device_id], separators=(",", ":")).encode()).hexdigest()[:24]`, prefixed with `t3-`. Use the actual host ID and exact device UUID, not a display name. If none matches, inspect the current T3 implementation rather than guessing an owner.
4. Read the matching thread with `t3_thread_read`, then send one narrowly scoped request with `t3_thread_send` (`mode: "auto"`):

   > Please close your own device session SESSION for HOST / DEVICE using T3 device_close with shutdown:false, or your own bound agent-device close. Preserve app data and leave the simulator booted. Do not reopen it or resume unrelated project work. Report whether release succeeded and notify originating thread THREAD when done.

   Substitute the verified identifiers. A settled/completed thread can still own a device. Sending wakes it; the request must be limited to releasing its own session. Do not send to unrelated threads, interrupt a running owner, or treat message delivery as confirmation of release. Link the contacted thread using the tool's returned link verbatim.
5. After confirmed release, call `device_open` and resume only the requested work. For a preview request, stop once it opens and runtime-required checks finish. If ownership is still blocked, report it; do not seize the session, delete claim files, or bypass cleanup approval.

Release this thread's session with `device_close` and `shutdown:false` when its device work ends, unless the user wants it left open for inspection. Settling a thread or dismissing the mobile preview does not release it.
