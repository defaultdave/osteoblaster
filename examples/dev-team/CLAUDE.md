# Dev Team v2

## Pipeline

Every task flows through these stages. Stages 2-4 are mandatory.

```
                                                        ┌→ 4. Review ─┐
[1. Assess] → 2. Implement → 3. Verify → Push & PR ─┤               ├→ Done
                                                        └→ 5. QA ────┘
```

| Stage | Agent | Required | Produces |
|-------|-------|----------|----------|
| 1. Assess | orchestrator + tech-pm | Yes | Scope manifest, sub-tasks if needed |
| 2. Implement | senior | Yes | Working code + tests |
| 3. Verify | orchestrator | Yes | Quality gates + runtime smoke test |
| 4. Review | review | Yes | Verdict: APPROVE / NITS / REQUEST_CHANGES |
| 5. QA | qa | Yes | Result: PASS / FAIL with details |

A task is not complete until both a review verdict and a QA result exist as PR comments.

### Quality Gates

Run between implementation and review:

```bash
npm run build && eslint . && tsc --noEmit && npm test
```

### Workflow Rules

1. **Scope is law.** Every agent prompt includes a scope manifest: what to build, what NOT to build. Senior must echo it back. Review must verify it. Building beyond scope is a REQUEST_CHANGES.
2. **Assess before implementing.** The orchestrator MUST inspect the repo state before spawning senior: check what files exist, what code is already written, whether the task is already done. Never start implementation blind.
3. **Pipeline is non-stop.** Once implementation starts, run all stages continuously. Valid stop points: (a) before merging to main, (b) after 3 failed cycles, (c) ambiguous requirements before implementation.
4. **Verify before review.** After implementation, the orchestrator runs quality gates AND a runtime smoke test. Don't hand broken code to review/QA.
5. **Feedback loops.** If review returns REQUEST_CHANGES or QA returns FAIL, route specific feedback back to senior. On retry, only re-run the failing stage(s). Max 3 cycles before escalating to the user.
6. **The output proves the pipeline ran.** Every completion must report: scope manifest, changes made, quality gate status, runtime verification, review verdict, QA result, and PR URL.
7. **Prefer small PRs.** Break large tasks into 2-4 issues per phase. Each gets its own pipeline run.

### GitHub Trail

Every pipeline run must leave a visible audit trail:
- PR created and linked to the issue (body contains `Closes #N`)
- Review and QA verdicts posted as PR comments
- Acceptance criteria checkboxes checked on the issue by the responsible agent (senior checks implementation criteria, review checks code review, QA checks QA)
- Agent metadata footer on the completion comment (model, tokens, duration, tool uses)
- **Never merge PRs without explicit user permission.** No agent may merge a PR autonomously. After review APPROVE + QA PASS, report results and wait for the user to authorize the merge.
- **Never close issues manually.** Issues close via `Closes #N` in PR body when merged. Do not use `gh issue close`.

### Tooling

On first `/team` run in a project, the orchestrator checks for a `## Tooling` section in the project's CLAUDE.md. If missing, it prompts the user to enable/skip optional MCP tools based on the project type:

| Tool | For | What it does |
|------|-----|-------------|
| Playwright MCP | Web apps | QA uses Playwright MCP tools (`mcp__playwright__browser_navigate`, `mcp__playwright__browser_take_screenshot`) to interact with running app. If MCP fails (sandbox/container issues), falls back to direct Playwright with `chromiumSandbox: false`. |
| Next.js DevTools MCP | Next.js | Senior gets real-time build/runtime error detection |
| Figma MCP | Design-driven | Agents read design specs for implementation and review |
| Lighthouse | Web apps | QA reports performance and accessibility scores |
| Database MCP | DB-backed apps | QA verifies data persistence, migrations |

The decision is recorded in the project's CLAUDE.md. QA and senior agents read this table to know what tools are available. Agents adapt their process based on what's enabled — they don't attempt to use skipped tools.

## Session Logging

Maintain verbose session logs in a `logs/` directory (NOT inside `.claude/memory/` — memory files auto-load into every agent's context and cost tokens). The orchestrator reads the log on-demand when needed.

**What to log:** Every user prompt, orchestrator decisions, every agent invocation (type, duration, tokens, tool uses, verdict), mistakes and corrections, current status and next action.

**Archival:** After 3 sessions, move older sessions to separate files. Keep only the last 2-3 sessions in the active log.

## Compaction

When context is compacted, preserve:
- Current issue number and acceptance criteria
- Current pipeline stage (implement/review/QA) and what's been completed
- Quality gate results (pass/fail for each gate)
- File paths of changes made
- Any blocking issues or errors being debugged
- PR number if created

Discard:
- Full file contents (can be re-read)
- Verbose test output (keep pass/fail counts only)
- Build logs (keep success/failure only)
- Intermediate exploration that led to dead ends
