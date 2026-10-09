# Osmani agent skills

Source: https://github.com/addyosmani/agent-skills
Revision: 1401c8b8030e023baeebb31781a6653fe8e93026 (main, fetched 2026-10-08).

The skills and references are locally adapted for this repository's pi setup.
`LICENSE` remains unchanged. Home Manager installs this directory under
`~/.pi/agent/skills/osmani`; pi discovers 24 enabled skills recursively. The
upstream browser-testing skill is intentionally omitted. Preserve
this layout when updating so relative reference paths continue to work.

Read [ADAPTATION.md](ADAPTATION.md) for the changes, review coverage, and flow
recommendations. Reconcile future upstream updates with these local adaptations;
do not overwrite them with an unmodified copy of upstream.

The four upstream specialist profiles are adapted in `home/agents/pi/agents/`
and installed by the pi Home Manager module alongside the existing profiles.
They preserve specialist rubrics/report formats; the web performance profile
uses source inspection and supplied measurement artifacts rather than live tools.
