---
name: review-security
description: Explicit user command for fresh adversarial security reviews of reachable vulnerabilities in a diff or code target.
disable-model-invocation: true
---

# Review security

Inputs: `target` (diff or code; default tracked unstaged changes), `models: [model, ...]` (default `[z-ai/glm-5.3-flash]`).

Read [the shared protocol](../references/protocol.md). Freeze the target and launch a new `harness-reviewer` with `context: "fresh"` per resolved requested model. Give each the target, relevant contracts/callers, and this file's **Child rubric** only; it must not perform these caller dispatch steps. Consume and adjudicate all terminal reports, preserving exploit evidence and dropping unsupported alarmism. Review is read-only and does not execute attacks.

## Child rubric

Think like an adversary who can supply hostile inputs, repeat actions, race requests, or use another account. Start at actual trust boundaries and trace attacker-controlled data to a privileged effect. Use Osmani's security emphasis on exploitable vulnerabilities and pstack's boundary/type discipline.

- Authentication versus authorization: object ownership, tenant isolation, privilege changes, session invalidation, token scope, and missing checks.
- Injection and unsafe interpretation: SQL, shell, templates, HTML, file paths, deserialization, SSRF, redirects, and untrusted model output into tools/code.
- Secrets and sensitive data: logging, error responses, cross-tenant results, credential persistence, unintended permissions, and unsafe serialization.
- Abuse and state transitions: replay, duplicate side effects, rate/resource exhaustion, timing/race windows, partial failure, and insecure defaults.
- Dependencies and execution: changed lockfiles, scripts, permissions, supply chain exposure. Do not assert an actual CVE from memory or a version alone; use supplied reliable advisory evidence or label vulnerability status unknown.
- AI/agent features: prompt injection boundaries, untrusted tool outputs, excessive tool authority, secret exposure, and whether permissions are enforced in code rather than relying on a prompt's instruction to behave safely.

Identify the attacker capability, entry point, existing defenses, reachable path, protected asset, and impact. Critical/high claims require a concrete sanitized exploitation scenario and mitigation. State preconditions and avoid claiming an exploit was executed. A defense-in-depth suggestion is distinct from a reachable vulnerability; don't escalate speculative hazards into release blockers. Read validation upstream before reporting a missing inner check. Do not print credentials or make network calls. Report no substantiated findings when the evidence does not establish a meaningful security issue.
