# Robo-Advisor Example

GitHub Copilot agent configuration for a Next.js robo-advisor application with automated portfolio management and investment recommendations.

## When to Use

- Next.js financial applications needing structured development pipelines
- Projects with financial calculations requiring rigorous review and testing
- Teams that want domain-specific review criteria (financial logic, precision, regulatory awareness)

## Agents

| Agent | Model | Role |
|-------|-------|------|
| senior | sonnet | Implementation — writes production code with financial precision rules |
| review | haiku | Code review — audits for bugs, security, financial logic, scope compliance |
| qa | sonnet | Test execution — runs test suite, validates financial calculations |
| tech-pm | haiku | Triage and planning — refines tickets, no code |

## Pipeline

```
                                       ┌→ 3. Review ─┐
[1. Triage] → 2. Implement → Quality Gate → Push/PR ─┤              ├→ Done
                                       └→ 4. QA ────┘
```

## Domain-Specific Features

This example extends the standard dev-team pipeline with:

- **Financial precision rules** — Fixed-precision arithmetic for money, no raw floating-point for currency
- **Zod validation at boundaries** — All user inputs (risk tolerance, amounts, time horizons) validated with schemas
- **No hardcoded advice** — Investment recommendations come from configurable models, not magic numbers
- **Security focus** — No PII exposure in errors, sanitized client responses, rate-limited sensitive endpoints
- **Accessibility requirements** — WCAG 2.1 AA for financial dashboards, text alternatives for charts
- **Component instructions** — Server Components by default, proper data formatting for financial displays

## Files

```
.github/
├── copilot-instructions.md              # Repo-wide pipeline and domain rules
├── AGENTS.md                            # Pipeline overview for all agents
├── agents/
│   ├── senior.agent.md                  # Implementation agent
│   ├── review.agent.md                  # Code review agent
│   ├── qa.agent.md                      # QA/testing agent
│   └── tech-pm.agent.md                 # Planning agent (no code)
└── instructions/
    ├── testing.instructions.md          # Path-scoped: test files
    ├── api.instructions.md              # Path-scoped: API route handlers
    ├── components.instructions.md       # Path-scoped: React components
    └── config.instructions.md           # Path-scoped: config files
```

## Usage

Copy the `.github/` directory into your Next.js robo-advisor project. Adjust quality gate commands and path globs in instruction files to match your project structure.
