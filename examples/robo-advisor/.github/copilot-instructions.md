# Robo-Advisor

Next.js robo-advisor application for automated portfolio management and investment recommendations.

## Pipeline

Every task flows through these stages. Stages 2-5 are mandatory.

```
                                                    ┌→ 4. Review ─┐
[1. Assess] → 2. Implement → 3. Verify → Push & PR ┤              ├→ Done
                                                    └→ 5. QA ─────┘
```

| Stage | Agent | Produces |
|-------|-------|----------|
| 1. Assess | orchestrator + tech-pm | Scope manifest, sub-tasks if needed |
| 2. Implement | senior | Working code + tests |
| 3. Verify | orchestrator | Quality gates + runtime smoke test |
| 4. Review | review | Verdict: APPROVE / APPROVE_WITH_NITS / REQUEST_CHANGES |
| 5. QA | qa | Result: PASS / FAIL with details |

A task is only considered complete (ready to merge) after the review verdict is **APPROVE** and the QA result is **PASS**, both posted as PR comments.

## Tech Stack

- **Framework:** Next.js (App Router)
- **Language:** TypeScript (strict mode)
- **Styling:** Tailwind CSS
- **State:** React Context / Zustand for client state
- **Data fetching:** Server Components + Route Handlers
- **Testing:** Jest + React Testing Library
- **Linting:** ESLint + Prettier

## Quality Gates

Run between implementation and review:

```bash
npm run build && npm run lint && tsc --noEmit && npm test
```

## Domain Rules

1. **Financial calculations must be deterministic and tested.** Every function that computes portfolio allocations, returns, fees, or risk scores must have unit tests with known inputs/outputs. No floating-point surprises — use fixed-precision where money is involved.
2. **No hardcoded financial advice.** Recommendations must come from configurable models/parameters, not magic numbers in source code.
3. **Data validation at boundaries.** Validate all user inputs (risk tolerance, investment amounts, time horizons) before they enter calculation pipelines. Use Zod schemas for runtime validation.
4. **Sensitive data handling.** Never log or expose PII, account numbers, or financial details in error messages, console output, or client-side state. Use environment variables for API keys and secrets.
5. **Accessibility matters.** Financial dashboards must meet WCAG 2.1 AA. Charts need text alternatives. Forms need proper labels and error messages.

## Workflow Rules

1. **Scope is law.** Every implementation includes a scope manifest (IN SCOPE / OUT OF SCOPE). Senior echoes it back. Review audits it. Building beyond scope is a REQUEST_CHANGES.
2. **Assess before implementing.** Inspect the repo state before starting: check what files exist, what code is already written, whether the task is already done. Never start implementation blind.
3. **Pipeline is non-stop.** Once implementation starts, run all stages continuously. Valid stop points: (a) before merging to main, (b) after 3 failed cycles, (c) ambiguous requirements before implementation.
4. **Verify before review.** After implementation, run quality gates AND a runtime smoke test. Don't hand broken code to review/QA.
5. **Feedback loops.** If review returns REQUEST_CHANGES or QA returns FAIL, route feedback back to senior. Max 3 cycles before escalating to the user.
6. **The output proves the pipeline ran.** Every completion must report: scope manifest, changes made, quality gate status, review verdict, QA result, and PR URL.
7. **Prefer small PRs.** Break large tasks into 2-4 issues per phase.

## GitHub Trail

Every pipeline run must leave a visible audit trail:

- PR created and linked to the issue (body contains `Closes #N`)
- Review and QA verdicts posted as PR comments
- Acceptance criteria checkboxes checked on the issue by the responsible agent
- **Never merge PRs without explicit user permission.** After review APPROVE + QA PASS, report results and wait for the user to authorize the merge.
- **Never close issues manually.** Issues close via `Closes #N` in PR body when merged.

## Commands

- **Build:** `npm run build`
- **Lint:** `npm run lint`
- **Type check:** `tsc --noEmit`
- **Test:** `npm test`
- **Dev server:** `npm run dev` (port 3000)
- **All quality gates:** `npm run build && npm run lint && tsc --noEmit && npm test`

These commands must all pass before creating a PR. If any fail, fix the issues before proceeding.

## Compaction

When context is compacted, preserve:

- Current issue number and acceptance criteria
- Current pipeline stage and what's been completed
- Quality gate results (pass/fail for each)
- File paths of changes made
- Any blocking issues or errors being debugged
- PR number if created
