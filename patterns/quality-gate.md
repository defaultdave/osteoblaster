# Quality Gate Pattern

Verification steps between pipeline stages that catch issues early.

## Concept

A quality gate is a set of commands that must pass before the pipeline moves to the next stage. If any command fails, the pipeline routes back to the previous agent with the failure output.

## Common Gates

| Gate | Command Examples | When to Use |
|------|-----------------|-------------|
| Build | `npm run build`, `cargo build`, `go build ./...` | After any code change |
| Lint | `eslint .`, `ruff check`, `golangci-lint run` | After implementation |
| Type check | `tsc --noEmit`, `mypy .`, `pyright` | After implementation |
| Unit tests | `npm test`, `pytest`, `go test ./...` | After implementation, after review fixes |
| E2E tests | `playwright test`, `cypress run` | After all other gates pass |

## Gate Placement in Pipeline

```
implement -> [build + lint + typecheck] -> review -> [tests] -> verify
```

Heavier gates (E2E, integration tests) run later. Fast gates (build, lint) run first.

## Implementation in Orchestrator

```markdown
**Quality Gate:** Run the following commands:
1. `npm run build`
2. `npm run lint`
3. `npm test`

If any command fails, send the failure output back to the {agent} agent for fixing. Do not proceed to the next stage.
```

## Principles

- **Fail fast**: Run the cheapest checks first
- **Be specific**: Include the exact commands for this project
- **Don't over-gate**: Only verify what matters. A lint warning shouldn't block a critical bug fix.
- **Include the output**: When routing back, include the full error output so the agent can fix it
