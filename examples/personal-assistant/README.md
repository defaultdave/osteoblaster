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

- **Onboarding** — first-run detection auto-triggers setup: name, role, goals, personality
- **Thought partner** — pushes back on weak ideas, explores angles, not a yes-man
- **Todo management** — checklist-based, quick wins vs projects, follow-up tracking with staleness
- **Goal tracking** — key results with progress notes across any life domain
- **Session continuity** — state files + session logs persist context across conversations
- **Continuous memory** — writes decisions, findings, and status changes immediately, not just at session end
- **Proactive, not pushy** — one suggestion at a time, doesn't repeat reminders

## Commands

| Command | Purpose |
|---------|---------|
| `/assistant` | Main entry point — talk to your assistant for anything (renamed to match chosen name via `/ossify`) |
| `/check-in` | Session start — load context, review priorities, suggest focus |
| `/wrap-up` | End session — save to session log, update state, note pending items |
| `/update` | Mid-session checkpoint — lightweight save without ending |
| `/report` | Weekly summary — accomplishments, goal progress, next priorities |
| `/goals` | View and update goal progress |
| `/teach` | Teach the assistant a new skill |

## Files

```
.claude/
├── agents/
│   └── assistant.md
├── commands/
│   ├── assistant.md    # Main entry point (renamed via /ossify)
│   ├── check-in.md
│   ├── wrap-up.md
│   ├── update.md
│   ├── report.md
│   ├── goals.md
│   └── teach.md
└── skills/          # Learned capabilities (grows over time)

state/
├── current.md       # Active priorities, open threads
└── goals.md         # Goals with tracking table

sessions/            # Daily session logs (created automatically)
reports/             # Weekly reports (created by /report)
memory/              # Persistent context (preferences, learnings, profile)
```

## Session Flow

**First time:** Assistant detects placeholder content in state files and runs onboarding — gathers name, role, goals, and communication style.

**Starting (`/check-in`):** Loads state, reads session history, surfaces priorities and stale items.

**During a session:** Just talk naturally. The assistant writes decisions, findings, and status changes to memory as they happen — no manual saving needed.

**Mid-session (`/update`):** Lightweight checkpoint. Appends progress to the session log without ending. Use frequently for long sessions.

**Ending (`/wrap-up`):** Summarizes the session, updates state files, logs everything for continuity.

**Weekly (`/report`):** Compiles session logs into a formatted summary with goal progress.
