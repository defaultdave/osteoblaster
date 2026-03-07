# Memory Pattern

Lightweight persistent context for agent systems.

## Concept

Memory gives agents consistent behavior across sessions. It stores project conventions, team preferences, and learnings that would otherwise be lost between conversations.

## Tier 1: Single File (MEMORY.md)

For most projects. One file in the project root.

```
project/
└── MEMORY.md
```

Contents:
- Project conventions and style preferences
- Key architectural decisions
- Common patterns used in this codebase
- Things that have been tried and didn't work

Keep it under 200 lines. If it grows past that, move to Tier 2.

## Tier 2: Memory Directory

For complex projects with multiple concerns.

```
project/
└── memory/
    ├── preferences.md    # Team norms, conventions, style
    └── learnings.md      # What worked, what didn't, gotchas
```

Maximum 2 files. If you need more, the information probably belongs in CLAUDE.md or the codebase itself.

## Continuous Memory (Autosave)

Don't rely solely on session-end commands to persist context. Important information should be written the moment it's produced — like autosave, not manual save.

### When to Write Immediately

Instruct agents to write to memory as soon as any of these occur:

- **A decision is made** — the rationale and outcome, before moving on
- **Research produces a finding** — results worth keeping, captured at discovery
- **A task completes or changes status** — marked done in the moment, not later
- **The user shares a preference or correction** — saved before it scrolls away
- **A blocker is hit or resolved** — what failed, what worked, why

### How to Instruct Agents

Add a memory discipline section to agent prompts:

```markdown
## Memory Discipline
When any of these occur, write to memory/ immediately — do not wait for session end:
- A decision is made or a question is resolved
- Research produces a finding worth keeping
- A task is completed or its status changes
- The user shares a preference or correction
- A blocker is encountered or resolved
```

### Session Commands Still Matter

With continuous writes, session-start and session-end commands shift purpose:

- **Check-in** — reads and synthesizes what's already persisted, surfaces priorities
- **Wrap-up** — organizes and compresses what was captured, cleans up noise, writes a summary

They become synthesis and hygiene steps, not the only persistence mechanism.

### What to Write Continuously vs. at Session End

| Continuous (write immediately) | Session end (wrap-up) |
|---|---|
| Decisions and their rationale | Session summary |
| Findings and research results | Scratchpad cleanup |
| Task status changes | Priority re-ranking |
| User preferences / corrections | Stale item review |
| Blockers hit or resolved | Weekly log entry |

## What to Store

- Stable patterns confirmed across multiple sessions
- User preferences for workflow and communication
- Architectural decisions and their rationale
- Solutions to recurring problems

## What NOT to Store

- Session-specific state (current task, in-progress work)
- Information that duplicates CLAUDE.md
- Speculative conclusions from a single interaction
- Anything that changes faster than it's read
