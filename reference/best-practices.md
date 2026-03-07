# Claude Code Skills Best Practices

Snapshot of official guidelines. Source: https://code.claude.com/docs/en/skills

Last updated: 2026-03-07

## File Format

Skills use a directory with `SKILL.md` as the entrypoint:

```
my-skill/
├── SKILL.md           # Main instructions (required)
├── template.md        # Optional supporting file
├── examples/          # Optional examples
└── scripts/           # Optional scripts
```

Legacy `.claude/commands/*.md` files still work and support the same frontmatter. Skills are recommended for new work since they support supporting files.

## YAML Frontmatter

All fields optional. Only `description` is recommended.

```yaml
---
name: my-skill                      # lowercase, hyphens, max 64 chars
description: What it does and when   # Claude uses this for auto-invocation
disable-model-invocation: true       # Manual-only (default: false)
user-invocable: false                # Hide from / menu (default: true)
allowed-tools: Read, Grep, Glob     # Tool restrictions
model: haiku                        # Model override
context: fork                       # Run in subagent
agent: Explore                      # Subagent type (with context: fork)
argument-hint: [issue-number]       # Autocomplete hint
---
```

## Description Guidelines

- Be specific about what the skill does
- Include trigger conditions ("Use when...", "Triggers on...")
- Claude uses the description to decide when to auto-load the skill
- If omitted, first paragraph of markdown content is used

## Content Guidelines

- **Keep SKILL.md under 500 lines.** Move detailed reference to supporting files.
- **Trust Claude's intelligence.** Only add context Claude doesn't already have.
- **No accumulated "never do X" lists.** These grow unbounded and degrade quality.
- **One level of references.** SKILL.md can reference supporting files, but those files shouldn't reference others.

## Invocation Control

| Setting | You invoke | Claude invokes | Description loaded |
|---------|-----------|---------------|-------------------|
| Default | Yes | Yes | Always in context |
| `disable-model-invocation: true` | Yes | No | Not in context |
| `user-invocable: false` | No | Yes | Always in context |

## String Substitutions

| Variable | Description |
|----------|-------------|
| `$ARGUMENTS` | All args passed to the skill |
| `$ARGUMENTS[N]` / `$N` | Specific arg by index (0-based) |
| `${CLAUDE_SESSION_ID}` | Current session ID |
| `${CLAUDE_SKILL_DIR}` | Directory containing SKILL.md |

## Dynamic Context

`!`command`` syntax runs shell commands before the skill content is sent to Claude:

```yaml
## Context
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -5`
```

## Skill Locations (Priority Order)

1. **Enterprise** — managed settings (highest priority)
2. **Personal** — `~/.claude/skills/<name>/SKILL.md`
3. **Project** — `.claude/skills/<name>/SKILL.md`
4. **Plugin** — `<plugin>/skills/<name>/SKILL.md` (namespaced)

Same-name skills: higher priority wins.

## Agents (Subagents)

Agents live in `.claude/agents/` and define specialized execution contexts:

- Use `context: fork` in a skill to run it in a subagent
- Built-in agents: `Explore`, `Plan`, `general-purpose`
- Custom agents: `.claude/agents/{name}.md`

## Key Anti-Patterns

- Prompts over 500 lines (move detail to supporting files)
- Nested agent chains (A calls B calls C — keep it one level)
- "Never do X" accumulation (trust the model)
- Session-specific state in skills (skills are stateless)
- Using "claude" in skill names (reserved word)
