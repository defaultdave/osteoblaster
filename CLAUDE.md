# Osteoblaster

Domain-agnostic scaffolding tool for building Claude Code agent systems.

## What This Is

Osteoblaster generates native `.claude/` directories for any project. The core product is `/ossify` — an interactive scaffolding command that produces agents, commands, and patterns aligned to official Claude Code best practices.

Zero dependencies. Zero custom runtime. Just markdown.

## Repo Structure

```
osteoblaster/
├── CLAUDE.md
├── README.md
├── .claude/
│   └── commands/
│       └── ossify.md           # Core product: interactive scaffolding
├── examples/                   # Reference implementations
│   ├── dev-team/               # Full dev pipeline (4 agents)
│   ├── solo-with-review/       # Simplest useful config
│   ├── review-council/         # Adversarial multi-perspective review
│   └── personal-assistant/     # Task/goal management with onboarding & session persistence
├── patterns/                   # Reusable prompt patterns
│   ├── pipeline.md
│   ├── quality-gate.md
│   ├── evidence.md
│   ├── memory.md
│   ├── feedback-loop.md
│   ├── model-selection.md
│   ├── persona-design.md
│   └── knowledge-management.md
└── reference/
    └── best-practices.md       # Snapshot of official guidelines
```

## Key Concepts

- **Functional agents**: Defined by what they DO. Low-to-medium freedom. (reviewer, QA, triager)
- **Persona agents**: Defined by how they THINK. High freedom. (devil's advocate, optimist, domain expert)
- Both use the same file format (YAML frontmatter + concise markdown). The difference is prompt content, not structure.

## Design Principles

1. **Native only** — `.claude/` system exclusively. No shell libraries, no Python, no YAML configs.
2. **Concise prompts** — Trust Claude's intelligence. Only add what Claude doesn't already know.
3. **Progressive disclosure** — SKILL.md is the overview. Details in supporting files, one level deep.
4. **Examples, not templates** — Examples show what good looks like. `/ossify` generates fresh configs.
5. **Domain-agnostic** — Dev teams are one use case. Works for any structured agent workflow.

## Code Standards

- All skill/agent files use YAML frontmatter with `name` and `description`
- Descriptions are specific, include trigger conditions
- SKILL.md files stay under 500 lines
- No accumulated "never do X" lists in prompts
