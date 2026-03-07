# Personal Assistant

A single persona agent with learned skills for personal task and goal management. Demonstrates a non-dev use case — the workspace is markdown files organized by life domain, not source code.

## When to Use

- Personal organization: todos, goals, follow-ups, daily planning
- Any domain where the agent manages knowledge across sessions, not code
- When you want a persistent assistant with extensible capabilities
- Proving that `.claude/` agent configs work beyond software development

## Agent

| Agent | Model | Role |
|-------|-------|------|
| assistant | opus | Personal assistant — manages tasks, tracks goals, learns new skills over time |

## Key Behaviors

- **Todo management** — checklist-based, quick wins vs projects, follow-up tracking
- **Goal tracking** — key results with progress notes across any life domain
- **Session continuity** — scratchpad persists context across conversations
- **Schedule awareness** — detects time gaps, adjusts priorities by mode
- **Proactive, not pushy** — one suggestion at a time, doesn't repeat reminders

## Skills System

The assistant learns new capabilities via a `/teach` command. Skills are stored as markdown files with trigger conditions and process steps. This is the memory pattern applied to capabilities, not just knowledge.

## Commands

| Command | Purpose |
|---------|---------|
| `/check-in` | Session start — load context, review priorities, suggest focus |
| `/wrap-up` | End session — save progress, update scratchpad, log to weekly record |
| `/goals` | View and update goal progress |
| `/teach` | Teach the assistant a new skill |

## Files

```
.claude/
├── agents/
│   └── assistant.md
├── commands/
│   ├── check-in.md
│   ├── wrap-up.md
│   ├── goals.md
│   └── teach.md
└── skills/          # Learned capabilities (grows over time)
```
