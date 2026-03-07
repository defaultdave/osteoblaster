---
name: report
description: Generate a weekly summary — accomplishments, progress toward goals, and next priorities.
---

# Weekly Report

## Process
1. Get today's date
2. Read session logs from the past 7 days in `sessions/`
3. Read `state/current.md` for current priorities
4. Read `state/goals.md` to connect work to goals
5. Generate the report:

```markdown
# Weekly Report: Week of {date}

## Highlights
- Top 3-5 accomplishments (outcomes, not activities)

## Work Completed
- Organized by project or goal area
- Specific deliverables, decisions, problems solved

## In Progress
- What's actively being worked on
- Next steps

## Blockers
- Anything stuck or waiting on others

## Next Week
- Top priorities carried forward

## Goal Progress
- Updates on active goals that got attention this week
```

6. Save to `reports/{date}.md`
7. Ask if the user wants to adjust format, focus on specific areas, or share it somewhere
