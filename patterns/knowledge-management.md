# Knowledge Management Pattern

Agent roles for capturing, organizing, and retrieving information across sessions.

## Concept

A knowledge management agent helps users build and maintain a structured knowledge base — notes, references, ideas, projects — so information is findable when needed. The agent handles triage and organization; the user focuses on capture and retrieval.

## Core Workflow

```
capture -> triage -> organize -> retrieve
```

- **Capture**: User drops raw material (notes, links, ideas, meeting summaries) into an inbox
- **Triage**: Agent processes inbox items — summarizes, tags, identifies connections
- **Organize**: Agent routes items to the right location based on actionability
- **Retrieve**: Agent surfaces relevant material when the user asks or when context triggers it

## Organization by Actionability

Route captured material based on what the user will do with it:

| Category | What belongs here | Lifecycle |
|----------|-------------------|-----------|
| **Active projects** | Material tied to something in progress | Lives here while the project is active, then archived |
| **Areas of responsibility** | Ongoing domains (health, career, finances, hobbies) | Persistent, updated regularly |
| **Reference** | Useful information with no immediate action | Stored for retrieval, rarely updated |
| **Archive** | Completed or inactive material | Moved here when no longer active, still searchable |

The key insight: organize by *when and how you'll use it*, not by *what it's about*. A recipe goes under "Health" (area) if you cook weekly, under "Reference" if you save it for someday.

## Progressive Summarization

When an agent processes captured material, it should distill in layers:

1. **Layer 1** — Save the full source
2. **Layer 2** — Bold the key passages
3. **Layer 3** — Highlight the highlights (the core insight)
4. **Layer 4** — Executive summary in the user's own words

Don't force all layers at capture time. Layer 1 happens immediately. Deeper layers happen when the material is revisited or relevant to active work.

## Agent Roles

For a knowledge management system, agents typically serve these functions:

| Role | What it does | Agent type |
|------|-------------|------------|
| **Inbox triager** | Processes raw captures, summarizes, suggests where to route | Functional |
| **Librarian** | Retrieves relevant material based on current context or questions | Functional |
| **Connector** | Surfaces unexpected links between notes, projects, and ideas | Persona (creative) |
| **Reviewer** | Periodically scans for stale items, orphaned notes, organization drift | Functional |

Not all are needed. A single-agent system (like a personal assistant) can handle triage + retrieval inline. The connector and reviewer roles add value as the knowledge base grows.

## Integration with Memory Pattern

Knowledge management and the [memory pattern](memory.md) serve different purposes:

| | Memory | Knowledge base |
|-|--------|----------------|
| **Audience** | The agent | The user |
| **Content** | How to behave (preferences, learnings) | What the user knows (notes, references, ideas) |
| **Updated by** | Agent (from corrections and patterns) | User (with agent assistance) |
| **Structure** | MEMORY.md or memory/ dir | Project-specific, organized by actionability |

Memory helps the agent work better. The knowledge base helps the user think better. Both persist across sessions, but they serve different masters.

## Capture Triggers

An assistant agent should offer to capture when it notices:

- A decision was made with reasoning worth preserving
- The user mentions something they want to remember
- A useful resource or reference comes up in conversation
- A project produces reusable insights or lessons

Offer once. Don't nag. The user decides what's worth keeping.
