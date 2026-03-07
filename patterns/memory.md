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
