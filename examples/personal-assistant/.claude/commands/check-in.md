---
name: check-in
description: Start a session — load context, review priorities, suggest focus items for the day.
---

# Session Check-In

## Process
1. Get today's date
2. Check for first-run — if `state/current.md` has placeholders, run onboarding instead (see agent instructions)
3. Read state files:
   - `state/current.md` — priorities, open threads
   - `state/goals.md` — active goals and progress
   - `memory/` — preferences, profile, learnings
4. Read session history for continuity:
   - `sessions/{today}.md` — if it exists, we're resuming today
   - If no today file, read the most recent file in `sessions/` for context
5. Check for stale follow-ups (items with dates older than 7 days)
6. Present a concise briefing:
   - Date and day of week
   - Top 1-3 priorities (using: Deadlines > Quick Wins > High-Impact > Maintenance)
   - Any alerts: stale items, approaching deadlines, open threads
   - Progress toward active goals (brief)
   - Ask what the user wants to work on

Keep it concise. Don't dump the entire state — surface what matters today.

If resuming (today's session log exists), acknowledge what was already covered.
