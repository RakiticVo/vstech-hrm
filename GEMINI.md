> Read this file first in every session with Google Antigravity / Gemini CLI.

@AGENTS.md

---

## Specific Notes for Antigravity / Gemini

The content above is linked directly from [AGENTS.md](AGENTS.md) — the canonical agent context file shared across all AI coding agents. General rules must be updated in `AGENTS.md` and `docs/coding-rules.md`.

### Workspace Skills (`.agents/skills/`)

| Skill | When to Use |
| :--- | :--- |
| `start-session` | Run first when starting a new session or switching major task scopes — reads `AGENTS.md`, `docs/*.md`, and checks git/code state |
| `new-feature` | Scaffold a new feature module conforming strictly to Clean Architecture (data/domain/presentation + BLoC stub) |
| `design-review` | Review a new screen or component against `docs/design-system.md` (colors, typography, spacing, states) |
| `arch-review` | Review Clean Architecture boundaries, SOLID principles, zero-hardcoding, and $\le 300$ lines limit |
| `git-commit` | Format commit messages, update `CHANGELOG.md`, and name branches per `docs/git-workflow.md` |
