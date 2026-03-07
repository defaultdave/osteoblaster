# Osteoblaster

Domain-agnostic scaffolding tool for building Claude Code agent systems.

Collects the bones of proven patterns — agents, pipelines, quality gates, memory — and assembles them into living `.claude/` configurations for any project.

Named for the **osteoblast**: the cell that builds new bone from old. In Haversian remodeling, osteoclasts break down worn bone, then osteoblasts lay down concentric layers (lamellae) around a central canal to form an **osteon** — the strongest structural unit in compact bone.

That's what this tool does. It takes the bones of what worked, discards what didn't, and builds something load-bearing.

## Status

Early development.

## Design

See [architecture doc](https://github.com/defaultdave/Daves-Dev-Depot/issues/5) for the full design suite.

## How It Works

The core product is `/init` — an interactive scaffolding command that generates a `.claude/` directory for any project:

1. Choose an agent system type (dev team, review panel, assistant, custom)
2. Define agents (functional or persona, model tier)
3. Configure pipeline shape and quality gates
4. Generate native Claude Code Skills files

Zero dependencies. Zero custom runtime. Just markdown.

## License

MIT
