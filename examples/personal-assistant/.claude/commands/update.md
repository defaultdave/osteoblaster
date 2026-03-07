---
name: update
description: Quick mid-session checkpoint — save progress without ending the session.
---

# Quick Checkpoint

Lightweight save without ending the session. Use frequently to prevent context loss.

## Process
1. Get today's date
2. Scan recent conversation for:
   - What was worked on
   - Decisions made
   - Status changes
3. Append to `sessions/{today}.md`:

```markdown
## Checkpoint: {time}
- {what was worked on, 1-3 bullets}
```

4. Update `state/current.md` only if something material changed:
   - New open thread
   - Completed item
   - Changed priority
5. Confirm in one line: "Checkpointed: {brief description}"

No summary. No next-actions list. Just confirm the save.
