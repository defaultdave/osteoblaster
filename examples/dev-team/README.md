# Dev Team Example

A full development pipeline with 4 agents: senior engineer, code reviewer, QA tester, and tech PM.

## When to Use

- Projects with active development needing structured code review and QA
- Teams that want an implement -> review -> QA pipeline with quality gates
- Any codebase where you want consistent PR quality

## Agents

| Agent | Model | Role |
|-------|-------|------|
| senior | sonnet | Implementation — writes production code, self-verifies |
| review | haiku | Code review — 3-verdict system (APPROVE / NITS / REQUEST_CHANGES) |
| qa | sonnet | Test execution — runs test suite, reports structured results |
| tech-pm | haiku | Triage and planning — refines tickets, no code |

## Pipeline

```
                                       ┌→ 3. Review ─┐
[1. Triage] → 2. Implement → Quality Gate → Push/PR ─┤              ├→ Done
                                       └→ 4. QA ────┘
```

Stage 1 is conditional (skip if requirements are clear). Stages 2-4 are mandatory. Review and QA run in parallel — they have no dependency on each other.

## Architecture: Rules in CLAUDE.md, Procedure in team.md

The pipeline enforcement lives in **two places** by design:

- **CLAUDE.md** (always loaded) — defines the pipeline stages, marks which are mandatory, and requires the output to include a review verdict and QA result. This makes it impossible for the orchestrator to declare "done" without running review and QA.
- **team.md** (loaded on `/team`) — the execution procedure. How to run each stage, what to pass to each agent, retry logic.

This split exists because orchestrators (Claude instances running `/team`) will optimize for speed and skip stages if nothing structurally prevents it. CLAUDE.md is the structural prevention — it's loaded into every conversation, not just `/team` invocations.

### GitHub Trail

The pipeline leaves a visible audit trail on GitHub:
- **Senior** commits code, pushes, creates a PR linked to the issue (`Closes #N`), and checks off implementation acceptance criteria on the issue
- **Review** posts its verdict as a PR comment (`gh pr comment`) and checks off the code review criterion
- **QA** posts its result as a PR comment (`gh pr comment`) and checks off the QA criterion
- Each agent owns its own checkboxes — no agent checks off another agent's work
- Issues are closed automatically when the PR is merged (via `Closes #N` in the PR body)

This makes pipeline execution verifiable by anyone looking at the repo — not just the orchestrator's internal logs.

### CLAUDE.md Template

When scaffolding a dev team, the project's CLAUDE.md should include:

```markdown
### Pipeline

Every task flows through these stages. Stages 2-4 are mandatory.

                                       ┌→ 3. Review ─┐
[1. Triage] → 2. Implement → Quality Gate → Push/PR ─┤              ├→ Done
                                       └→ 4. QA ────┘

- Stage 1 (optional): tech-pm triages ambiguous or large tasks
- Stage 2 (required): senior implements. May parallelize.
- Quality gate (required): build, lint, test, typecheck must pass before review
- Push/PR (required): commit, push, create PR linked to issue
- Stage 3 (required): review agent reads the diff, posts verdict as PR comment
- Stage 4 (required): qa agent runs tests, posts result as PR comment
- Review and QA run in parallel — no dependency between them

A task is not complete until both a review verdict and a QA result exist.

### Workflow Rules

1. Batching is allowed, skipping is not. For large multi-part tasks, batch
   implementation then run one review + QA pass. But review and QA must run.
2. Feedback loops: REQUEST_CHANGES or FAIL routes back to senior. Max 3 cycles.
   On retry, only re-run the failing stage(s), not both.
3. The output proves the pipeline ran: changes, gate status, review verdict, QA result, PR URL.
```

## Evidence & Visual Verification

Agents post proof of work on every PR comment:

- **Text evidence** — test output, build logs, CLI results in collapsible code blocks
- **Visual evidence** — Playwright screenshots uploaded to a draft GitHub release (`_screenshots`) and embedded inline in PR comments
- **Agent metadata footer** — model name, token count, duration, tool uses for every agent invoked

For web/UI projects, QA captures screenshots of the running application as proof that the server starts and pages render correctly. See `patterns/evidence.md` for the full pattern.

## Tooling (per-project MCP setup)

On first `/team` run in a project, the orchestrator detects the project type and asks the user which optional tools to enable:

| Tool | For | What it does |
|------|-----|-------------|
| Playwright MCP | Web apps | QA interacts with running app (click, fill, navigate, screenshot) |
| Next.js DevTools MCP | Next.js | Senior gets real-time build/runtime error detection |
| Figma MCP | Design-driven | Agents read design specs for implementation and review |
| Lighthouse | Web apps | QA reports performance and accessibility scores |
| Database MCP | DB-backed apps | QA verifies data persistence, migrations |

The decision is recorded in the project's CLAUDE.md under `## Tooling`. Agents read this table and adapt — they use enabled tools and skip disabled ones. MCP servers are npm packages installed per-project, not globally.

**Devcontainer requirement:** Chromium must be pre-installed for Playwright. Add `RUN npx playwright install chromium` to the Dockerfile (system deps: `libgbm1`, `libnss3`, `libatk1.0-0`, etc.).

## Optional: Benchmark Agent

The benchmark agent measures pipeline quality by running a series of phased tasks and scoring the results. Add it when you want to validate your dev-team setup or compare configurations.

| Agent | Model | Role |
|-------|-------|------|
| benchmark | sonnet | Scores completed phases on correctness, tests, pipeline adherence, quality |

### How it works

1. `/benchmark` runs phased tasks through `/team` one at a time
2. After each phase, the `benchmark` agent scores the result (0-3 on four dimensions, max 12/phase)
3. Final report shows strengths, weaknesses, and overall score

### Two modes

- **Built-in benchmark** — A 4-phase file-based todo app (no database, no deps). Quick to run, tests incremental pipeline performance.
- **External repo** — Point at a GitHub repo with issues. Main stays frozen, work goes on a benchmark branch, reset by branching again.

### Files (optional — add only if benchmarking)

```
.claude/
├── agents/
│   └── benchmark.md     # Benchmark evaluator/scorer
└── commands/
    └── benchmark.md     # Benchmark orchestrator
```

## Files

```
.claude/
├── agents/
│   ├── senior.md
│   ├── review.md
│   ├── qa.md
│   ├── tech-pm.md
│   └── benchmark.md     # Optional — pipeline benchmarking
└── commands/
    ├── team.md           # Pipeline orchestrator
    └── benchmark.md      # Optional — benchmark runner
```
