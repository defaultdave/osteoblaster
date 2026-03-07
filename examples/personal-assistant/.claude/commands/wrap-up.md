---
name: wrap-up
description: End session — save progress to session log, update state, note pending items.
---

# Session Wrap-Up

## Process
1. Get today's date
2. Review the conversation and extract:
   - Topics discussed
   - Decisions made
   - Items completed
   - Open threads and next actions
3. Append to `sessions/{today}.md` (create if needed):

```markdown
## Session: {time}

### Topics
- {topic}

### Decisions
- {decision}

### Completed
- {item}

### Open Threads
- {thread}

### Next Actions
- {action}
```

4. Update `state/current.md`:
   - Add new priorities or open threads
   - Remove completed items
   - Update any changed statuses
5. Confirm with a brief summary:
   - What was logged
   - Key items for next session
