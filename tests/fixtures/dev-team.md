# Dev Team — Scaffold Test Spec

Test fixture for verifying osteoblaster's dev-team scaffolding output.

## Ossify Inputs

These are the inputs that reproduce the dev-team example via `/ossify`:

| Step | Choice |
|------|--------|
| System type | 1 — Dev team |
| Team size | 3 — Full pipeline (4+ agents) |
| Agents | senior (functional, sonnet), review (functional, haiku), qa (functional, sonnet), tech-pm (functional, haiku), benchmark (functional, sonnet) |
| Pipeline shape | 1 — Linear chain (with parallel review+QA after quality gate) |
| Quality gates | `npm run build && eslint . && tsc --noEmit && npm test` |
| Memory | 1 — Preferences file (MEMORY.md) |

## Live Instance

The canonical live instance is `../dev-team-v2`. The example at `examples/dev-team/` should stay in sync with it.

## Expected Structure

```
.claude/
├── agents/
│   ├── senior.md
│   ├── review.md
│   ├── qa.md
│   ├── tech-pm.md
│   └── benchmark.md
├── commands/
│   ├── team.md
│   └── benchmark.md
├── hooks/
│   └── post-edit-lint.sh
├── memory/
│   └── MEMORY.md
└── settings.json
```

## Agent Assertions

| Agent | name | model | type | key content |
|-------|------|-------|------|-------------|
| senior | senior | sonnet | functional | "## Testing" section; "Tests are part of the deliverable" |
| review | review | haiku | functional | "## Verdicts" with APPROVE / APPROVE_WITH_NITS / REQUEST_CHANGES |
| qa | qa | sonnet | functional | "## Evidence" section; "## Test Sufficiency" section |
| tech-pm | tech-pm | haiku | functional | "No code. Planning and refinement only." |
| benchmark | benchmark | sonnet | functional | "## Hard Failure Rules"; "Pipeline Adherence = 0" |

## Command Assertions

| Command | key content |
|---------|-------------|
| team.md | Spawns senior, review, qa; references quality gates; parallel review+QA; max 3 retries |
| benchmark.md | 4-phase todo CLI; scoring 0-3 per dimension; pipeline adherence hard gate |

## CLAUDE.md Assertions

The project's CLAUDE.md must contain:
- `## Pipeline` section with stage table
- `### Quality Gates` with the gate commands
- `### Workflow Rules` with batching/skipping/feedback rules
- `### GitHub Trail` with audit trail requirements
- `### Tooling` table (Playwright, Next.js DevTools, Figma, Lighthouse, Database MCP)

## Infrastructure Assertions

- `settings.json` has PostToolUse hook for Write|Edit that runs `post-edit-lint.sh`
- `post-edit-lint.sh` is executable, handles JS/TS files, finds ESLint config
