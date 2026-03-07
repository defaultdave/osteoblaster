# Osteoblaster

Domain-agnostic scaffolding tool for building Claude Code agent systems.

Collects the bones of proven patterns — agents, pipelines, quality gates, memory — and assembles them into living `.claude/` configurations for any project.

Named for the **osteoblast**: the cell that builds new bone from old. In Haversian remodeling, osteoclasts break down worn bone, then osteoblasts lay down concentric layers (lamellae) around a central canal to form an **osteon** — the strongest structural unit in compact bone.

That's what this tool does. It takes the bones of what worked, discards what didn't, and builds something load-bearing.

## Quick Start

1. Clone this repo (or add it as an `--add-dir`):
   ```bash
   git clone <repo-url>
   ```

2. From any project, run:
   ```
   /init /path/to/your/project
   ```

3. Follow the interactive prompts to design your agent system.

4. Start using your generated `.claude/` agents and commands.

## What `/init` Does

The core product is an interactive scaffolding command that generates a `.claude/` directory:

1. **System type** — Dev team, review panel, personal assistant, or custom
2. **Agent design** — Functional (task-oriented) or persona (perspective-oriented), with model tiers
3. **Pipeline shape** — Linear, parallel, hub-and-spoke, or independent
4. **Quality gates** — Build, lint, test commands between stages
5. **Memory** — Optional persistent context (preferences, learnings)
6. **Generate** — Writes native Claude Code Skills files into your project

## Examples

| Example | Description |
|---------|-------------|
| [dev-team](examples/dev-team/) | Full pipeline: tech-pm, senior engineer, code reviewer, QA |
| [solo-with-review](examples/solo-with-review/) | Simplest useful config: one agent with self-review |
| [review-council](examples/review-council/) | Adversarial multi-perspective review with persona agents |
| [personal-assistant](examples/personal-assistant/) | Task/goal management — non-dev use case with learned skills |

## Patterns

Reusable prompt patterns referenced during `/init`:

| Pattern | What It Covers |
|---------|---------------|
| [pipeline](patterns/pipeline.md) | Chaining agents with handoff contracts |
| [quality-gate](patterns/quality-gate.md) | Verification between pipeline stages |
| [memory](patterns/memory.md) | Lightweight persistent context |
| [model-selection](patterns/model-selection.md) | When to use haiku vs sonnet vs opus |
| [persona-design](patterns/persona-design.md) | Crafting perspective-driven agents |
| [feedback-loop](patterns/feedback-loop.md) | Run, validate, fix, repeat |
| [knowledge-management](patterns/knowledge-management.md) | Capture, triage, organize, retrieve |

## Agent Types

Osteoblaster supports two kinds of agents:

| Type | Defined By | Freedom | Prompt Style | Examples |
|------|-----------|---------|--------------|----------|
| **Functional** | What they DO | Low-to-medium | Steps, criteria, output format | Code reviewer, QA tester, triager |
| **Persona** | How they THINK | High | Perspective, tone, values | Devil's advocate, end-user advocate, simplicity advocate |

Both use the same file format (YAML frontmatter + markdown). The difference is content, not structure.

## Principles

1. **Native only** — Uses Claude Code's `.claude/` system. Zero custom runtime, zero dependencies.
2. **Concise prompts** — Trust Claude's intelligence. Only add what Claude doesn't know.
3. **Examples, not templates** — Examples show what good looks like. `/init` generates fresh configs aligned to current best practices.
4. **Domain-agnostic** — Dev teams are one use case among many.

## License

MIT
