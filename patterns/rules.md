# Rules Pattern

Path-scoped contextual guidance via `.claude/rules/`.

## Concept

Rules are markdown files in `.claude/rules/` that activate only when Claude is working on files matching their path globs. They inject domain-specific guidance at the right moment without cluttering the global context.

## How Path Matching Works

Each rule file has YAML frontmatter with a `paths` array of glob patterns:

```yaml
---
paths: ["src/api/**", "src/routes/**"]
---
```

When Claude touches a file matching any listed pattern, the rule's content is loaded into context. Multiple rules can activate simultaneously if a file matches several patterns.

Glob syntax follows standard conventions: `*` matches within a directory, `**` matches across directories, `{}` for alternatives.

## Rules vs CLAUDE.md

| | CLAUDE.md | Rules |
|---|-----------|-------|
| **Scope** | Always loaded | Loaded when path matches |
| **Content** | Universal project standards | Domain-specific guidance |
| **Size** | Keep lean — every token costs | Can be more detailed per domain |

Put architectural decisions, pipeline definitions, and workflow rules in CLAUDE.md. Put coding conventions for specific file types or directories in rules.

## When to Use Rules

- Code in different directories follows different conventions (API vs CLI vs tests)
- You want to enforce patterns only where they apply
- CLAUDE.md is getting long and most content is domain-specific
- New contributors (human or agent) should get contextual guidance automatically

## Example Rules

### Testing (`**/*.test.ts`, `tests/**`)
- Arrange-act-assert structure
- Test names describe behavior, not implementation
- Prefer real implementations over mocks
- Each test independent — no shared mutable state

### API (`src/api/**`, `src/routes/**`)
- Validate external input at the boundary
- Consistent error shape: `{ error: string }`
- Thin route handlers — delegate to domain functions
- No framework dependencies in business logic

### Config (`*.config.*`, `tsconfig.*`)
- Don't modify without explicit user request
- Extend existing config rather than replacing
- Document non-obvious settings inline
- Verify changes work across environments

## Principles

- **Keep rules concise** — under 50 lines each. Claude is smart; state the rule, not the rationale.
- **No overlap with CLAUDE.md** — if it applies everywhere, it belongs in CLAUDE.md.
- **Specific paths** — broad globs like `**/*` defeat the purpose. Scope tightly.
- **Actionable** — every line should change Claude's behavior. Skip platitudes.
