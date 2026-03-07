# Solo with Review

The simplest useful agent config: one developer agent that implements and self-reviews.

## When to Use

- Solo projects or small side projects
- When you want a lightweight quality check without a full pipeline
- Starting point — upgrade to a full team later if needed

## Agent

| Agent | Model | Role |
|-------|-------|------|
| developer | sonnet | Implements, then reviews own work before finishing |

## Files

```
.claude/
└── agents/
    └── developer.md
```

No orchestrator command needed — just invoke the developer agent directly.
