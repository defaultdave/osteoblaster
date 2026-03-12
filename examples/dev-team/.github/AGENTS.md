# Dev Team

This repository uses a multi-agent development pipeline. All code changes flow through a structured process with mandatory review and QA stages.

## Pipeline

```
[1. Assess] → 2. Implement → 3. Verify → Push & PR → 4. Review + 5. QA → Done
```

- **Assess**: Inspect repo state, define scope manifest (IN SCOPE / OUT OF SCOPE)
- **Implement**: `@senior` writes code and tests, self-verifies with quality gates
- **Verify**: Run quality gates independently before creating PR
- **Review**: `@review` audits diff for bugs, security, scope compliance
- **QA**: `@qa` runs full test suite, runtime verification, posts evidence

The pipeline run is complete once both a review verdict and a QA result exist as PR comments. A task is ready to merge only when the review is APPROVE and QA is PASS.

## Agents

| Agent | Purpose | Model |
|-------|---------|-------|
| `@senior` | Implementation — writes production code and tests | sonnet |
| `@review` | Code review — audits for bugs, security, scope compliance | haiku |
| `@qa` | QA — runs tests, runtime verification, posts evidence | sonnet |
| `@tech-pm` | Planning — triages, decomposes, estimates (no code) | haiku |

## Rules

1. **Scope is law.** Never build beyond the scope manifest. Scope violations trigger REQUEST_CHANGES.
2. **Pipeline is non-stop.** Run all stages continuously once started.
3. **Verify before review.** Quality gates must pass before creating a PR.
4. **Max 3 feedback cycles** before escalating to the user.
5. **Never merge to main** without explicit user permission.
6. **Never close issues manually.** Use `Closes #N` in PR body.

## Quality Gates

```bash
npm run build && eslint . && tsc --noEmit && npm test
```

All four must pass before a PR is created.
