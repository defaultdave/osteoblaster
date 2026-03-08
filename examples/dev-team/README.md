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
[1. Triage] → 2. Implement → Quality Gate → 3. Review → 4. QA → Done
```

Stage 1 is conditional (skip if requirements are clear). Stages 2-4 are mandatory.

## Architecture: Rules in CLAUDE.md, Procedure in team.md

The pipeline enforcement lives in **two places** by design:

- **CLAUDE.md** (always loaded) — defines the pipeline stages, marks which are mandatory, and requires the output to include a review verdict and QA result. This makes it impossible for the orchestrator to declare "done" without running review and QA.
- **team.md** (loaded on `/team`) — the execution procedure. How to run each stage, what to pass to each agent, retry logic.

This split exists because orchestrators (Claude instances running `/team`) will optimize for speed and skip stages if nothing structurally prevents it. CLAUDE.md is the structural prevention — it's loaded into every conversation, not just `/team` invocations.

### CLAUDE.md Template

When scaffolding a dev team, the project's CLAUDE.md should include:

```markdown
### Pipeline

Every task flows through these stages. Stages 2-4 are mandatory.

[1. Triage] → 2. Implement → Quality Gate → 3. Review → 4. QA → Done

- Stage 1 (optional): tech-pm triages ambiguous or large tasks
- Stage 2 (required): senior implements. May parallelize.
- Quality gate (required): build, lint, test, typecheck must pass before review
- Stage 3 (required): review agent reads the diff and produces a verdict
- Stage 4 (required): qa agent runs tests and verifies requirements

A task is not complete until both a review verdict and a QA result exist.

### Workflow Rules

1. Batching is allowed, skipping is not. For large multi-part tasks, batch
   implementation then run one review + QA pass. But review and QA must run.
2. Feedback loops: REQUEST_CHANGES or FAIL routes back to senior. Max 3 cycles.
3. The output proves the pipeline ran: changes, gate status, review verdict, QA result.
```

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
