---
name: ossify
description: Interactive scaffolding command that generates a .claude/ directory for any project. Use when setting up a new agent system.
disable-model-invocation: true
argument-hint: [target-directory]
---

# Osteoblaster Ossify

Generate a complete `.claude/` agent system for a project. You are an expert at designing Claude Code agent architectures.

## Target Directory

The target project is: $ARGUMENTS

If no target was provided, ask the user which project to scaffold.

## Process

Walk the user through each step interactively. Present clear numbered options. After each choice, confirm and move on.

### Step 1: System Type

What kind of agent system?

1. **Dev team** — Implementation, review, QA pipeline
2. **Review panel** — Multi-perspective adversarial review (council-style)
3. **Personal assistant** — Task management, goals, reporting
4. **Custom** — Build from scratch

If they pick 1-3, pre-load sensible defaults from the matching example in this repo's `examples/` directory. Read the example to understand its structure, then adapt it to the target project. If custom, start fresh.

### Step 1b: Personalization (Personal Assistant only)

If the user chose **Personal assistant**, ask before continuing:

1. **Name** — What should the assistant be called? (e.g., "Cleo", "Friday", "Jarvis", or just "assistant")
2. **Personality** — What tone and style fits?
   - A: **Warm & supportive** — encouraging, celebrates wins, gentle nudges
   - B: **Crisp & efficient** — minimal chatter, straight to the point
   - C: **Witty & casual** — conversational, light humor, informal
   - D: **Professional & structured** — formal, organized, by-the-book
   - E: **Custom** — describe your own

Use the name and personality throughout the generated agent file — in the title, tone section, and any user-facing output.

### Step 2: Team Size

How many agents?

1. **Solo** — One agent, optionally with self-review
2. **Small team** (2-3 agents)
3. **Full pipeline** (4+ agents)

### Step 3: Agent Design

For each agent, determine:

- **Name**: lowercase-with-hyphens, descriptive
- **Type**: Functional (task-oriented) or Persona (perspective-oriented)
- **Model tier**: `haiku` (fast/cheap — good for triage, review, planning) or `sonnet` (capable — good for implementation, complex reasoning)
- **Responsibility**: One clear sentence

Use this format for functional agents:
```yaml
---
name: {name}
description: {What it does}. {When to trigger it}.
model: {haiku or sonnet}
---
# {Title}

## Process
1. {Step}
2. {Step}
3. {Step}

## Output
{What the agent produces}
```

Use this format for persona agents:
```yaml
---
name: {name}
description: {Perspective it brings}. {When to trigger it}.
model: {haiku or sonnet}
---
# {Title}

## Perspective
{How this agent thinks, what it values, what it challenges}

## Style
{Communication approach — direct, skeptical, supportive, etc.}
```

### Step 4: Pipeline Shape

How do agents coordinate?

1. **Linear chain** — A -> B -> C (each agent hands off to the next)
2. **Parallel then merge** — A + B run simultaneously, C synthesizes
3. **Hub and spoke** — Orchestrator delegates to specialists
4. **Independent** — No pipeline, agents invoked separately

If they choose a pipeline, generate an orchestrator command that chains the agents.

### Step 5: Quality Gates

What verification runs between pipeline stages?

- Build commands (e.g., `npm run build`, `cargo build`)
- Test commands (e.g., `npm test`, `pytest`)
- Lint commands (e.g., `eslint .`, `ruff check`)
- Type check (e.g., `tsc --noEmit`, `mypy .`)
- None

Embed these as verification steps in the orchestrator command.

### Step 6: Memory

Does the project need persistent memory?

1. **Preferences file** — Team norms, conventions, patterns (single MEMORY.md)
2. **Structured memory** — Preferences + per-topic files in `memory/` directory
3. **None**

If yes, generate the initial memory structure with sensible defaults.

### Step 7: Generate

Now generate all files into the target project's `.claude/` directory:

1. Read the target project to understand its tech stack, existing structure, and conventions
2. Generate agent files as `.claude/agents/{name}.md`
3. Generate orchestrator command as `.claude/commands/{name}.md` (if pipeline chosen)
4. Generate memory files (if chosen)
5. Generate a project CLAUDE.md if one doesn't exist, or suggest additions to an existing one

## Validation Checklist

Before writing any file, verify:

- [ ] Agent prompts are concise (under 500 lines per file)
- [ ] YAML frontmatter has `name` and `description`
- [ ] Descriptions are specific and include trigger conditions
- [ ] No nested agent references (one level deep max)
- [ ] No "never do X" accumulation — trust Claude's intelligence
- [ ] Model tier matches the agent's workload (haiku for fast/simple, sonnet for complex)

## Output

After generating, print a summary:

```
## Generated Files

agents/
  {name}.md — {one-line description}
  ...

commands/
  {name}.md — {one-line description}

memory/
  {files if applicable}

## Quick Start
{How to use the generated system}
```

## Reference

For patterns and examples, read from this repo:
- `examples/` — reference implementations
- `patterns/` — reusable prompt patterns
- `reference/best-practices.md` — official guidelines snapshot
