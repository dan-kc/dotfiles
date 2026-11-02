---
name: shared-ios-simulator
description: Use when launching, inspecting, or recovering the shared iOS simulator on this Mac.
---

Reuse iPhone 18 Pro `4469D43E-D1C0-4E0B-9CAC-8684C5522DAF`; never create or clone a device for interactive work. Keep project build/test commands and bundle IDs in the project skill.

- With T3 device tools: `device_list` → `device_open` with host/device IDs → returned `agent-device` command → `open <bundle-id>` before interaction. Use that command for launches, taps, text, screenshots and recordings; inspect with `device_screenshot`. Verify a navigation tap and screenshot.
- Follow the active runtime’s ownership/retry rules. Never stop another session, delete locks, kill automation processes, or erase app data to bypass ownership. Release only your own session when supported.
- A running simulator needs no cleanup. Only when the runtime permits recovery and the user explicitly approves stopping **all** T3 device sessions on this Mac, run `simulator-cleanup --confirmed`. Existing approval suffices. App data stays; other threads lose control. Reopen through device tools and verify interaction. Stop if recovery fails or the runtime forbids it.
