# Dev Team v2

## Pipeline

Every task flows through these stages. Stages 2-4 are mandatory.

```
                                       ┌→ 3. Review ─┐
[1. Triage] → 2. Implement → Quality Gate ─┤              ├→ Done
                                       └→ 4. QA ────┘
```

| Stage | Agent | Required | Produces |
|-------|-------|----------|----------|
| 1. Triage | tech-pm | Optional | Refined requirements, sub-tasks |
| 2. Implement | senior | Yes | Working code + tests |
| Quality Gate | (automated) | Yes | Build, lint, typecheck, test results |
| 3. Review | review | Yes | Verdict: APPROVE / NITS / REQUEST_CHANGES |
| 4. QA | qa | Yes | Result: PASS / FAIL with details |

A task is not complete until both a review verdict and a QA result exist.

### Quality Gates

Run between implementation and review:

```bash
npm run build && eslint . && tsc --noEmit && npm test
```

### Workflow Rules

1. **Batching is allowed, skipping is not.** For large multi-part tasks, the orchestrator may batch implementation, then run one review + QA pass over the combined changes. But review and QA must run at least once before the task is declared done.
2. **Feedback loops.** If review returns REQUEST_CHANGES or QA returns FAIL, route specific feedback back to senior. On retry, only re-run the failing stage(s). Max 3 cycles before escalating to the user.
3. **The output proves the pipeline ran.** Every completion must report: task summary, changes made, quality gate status, review verdict, QA result, and PR URL.

### GitHub Trail

Every pipeline run must leave a visible audit trail:
- PR created and linked to the issue (body contains `Closes #N`)
- Review and QA verdicts posted as PR comments
- Acceptance criteria checkboxes checked on the issue by the responsible agent (senior checks implementation criteria, review checks code review, QA checks QA)
- Agent metadata footer on the completion comment (model, tokens, duration, tool uses)
- PR merged after review APPROVE + QA PASS — issue auto-closes via `Closes #N`
- Never manually close issues before the PR is merged

### Tooling

On first `/team` run in a project, the orchestrator checks for a `## Tooling` section in the project's CLAUDE.md. If missing, it prompts the user to enable/skip optional MCP tools based on the project type:

| Tool | For | What it does |
|------|-----|-------------|
| Playwright MCP | Web apps | QA interacts with running app (click, fill, navigate, screenshot) |
| Next.js DevTools MCP | Next.js | Senior gets real-time build/runtime error detection |
| Figma MCP | Design-driven | Agents read design specs for implementation and review |
| Lighthouse | Web apps | QA reports performance and accessibility scores |
| Database MCP | DB-backed apps | QA verifies data persistence, migrations |

The decision is recorded in the project's CLAUDE.md. QA and senior agents read this table to know what tools are available. Agents adapt their process based on what's enabled — they don't attempt to use skipped tools.

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
