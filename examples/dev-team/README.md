# Dev Team Example

A full development pipeline with 4 agents: senior engineer, code reviewer, QA tester, and tech PM.

## When to Use

- Projects with active development needing structured code review and QA
- Teams that want a implement -> review -> QA pipeline with quality gates
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
tech-pm (triage) -> senior (implement) -> review (code review) -> qa (verify)
```

Quality gates run between each stage (build + lint + test).

## Files

```
.claude/
├── agents/
│   ├── senior.md
│   ├── review.md
│   ├── qa.md
│   └── tech-pm.md
└── commands/
    └── team.md        # Pipeline orchestrator
```
