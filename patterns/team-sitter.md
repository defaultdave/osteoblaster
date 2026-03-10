# Team Sitter Pattern

Autonomous pipeline babysitter that checks repo state, merges approved PRs, triggers the team for next work, and stops when done.

## Concept

A team-sitter command monitors a project's GitHub state and drives the pipeline forward without manual intervention. It pairs with `/loop` for continuous operation — check state, act, report, repeat.

The sitter never implements or reviews code itself. It only observes repo state and dispatches the team orchestrator command.

## When to Use

- Project has a pipeline orchestrator (e.g., `/team`) and a GitHub issue backlog
- User wants hands-off execution: "work through these issues while I'm away"
- Multiple issues need sequential pipeline runs

## Structure

The sitter operates in a gather → decide → act loop:

```
Step 0: Ensure ops issue exists (communication channel)
Step 1: Gather state (PRs, issues, branches)
Step 2: Decision tree (what action to take)
Step 3: Act (merge, trigger team, or stop)
Step 4: Report to ops issue
→ LOOP_CONTINUE or LOOP_STOP
```

## Ops Issue — Communication Channel

The sitter creates a pinned GitHub issue labeled `ops` as its communication channel. All updates, decisions, and questions go here. This gives the user a single place to monitor progress and respond to questions.

**Why an issue instead of CLI output?** The sitter runs via `/loop`, which means the user may not be watching. GitHub issues are persistent, timestamped, and accessible from anywhere.

When stuck, the sitter posts a structured question to the ops issue and continues looping — checking for a reply each cycle before taking new action.

## Decision Tree

The sitter works through these cases top-to-bottom, taking the FIRST match:

| Case | Condition | Action |
|------|-----------|--------|
| A | Open PR with APPROVE + PASS | Merge the PR |
| A | Open PR missing verdicts | Trigger team to complete remaining stages |
| A | Open PR with REQUEST_CHANGES or FAIL | Trigger team to fix feedback |
| B | No PR but in-progress branch exists | Trigger team to continue pipeline |
| C | No PR, no in-progress work, issues remain | Trigger team for next open issue |
| C | No PR, no in-progress work, no issues | LOOP_STOP — pipeline complete |
| D | Ambiguous state | Use judgment to unblock (see below) |

### Case D: Ambiguous State

When none of the clean cases match, the sitter uses judgment:

- Conflicting verdicts → read comments, act on the most recent
- CI failing on approved PR → investigate, trigger team to fix
- Branch behind main with conflicts → rebase or recreate
- Multiple open PRs → prioritize lowest-numbered (earliest)
- Stale approved PR → merge it

**Rules for Case D:**
1. Always log reasoning to the ops issue
2. Prefer forward progress over perfection
3. Never force-push, delete unmerged branches, or close issues manually
4. If truly stuck, post a question to the ops issue and wait for reply

## Stop Conditions

Output `LOOP_STOP` when:
1. No open issues remain — pipeline is complete
2. Same issue has failed 3+ cycles
3. Unexpected error requiring human intervention

## Command Template

This is the template for generating a team-sitter command. Replace `{TEAM_COMMAND}` with the project's orchestrator command name (e.g., `team`, `pipeline`, `dev`).

```markdown
---
name: {name}-sitter
description: Autonomous pipeline babysitter. Checks repo state, merges approved PRs, triggers /{TEAM_COMMAND} for next work, stops when done.
argument-hint: [repo-path]
---
# {Name} Sitter

You are the autonomous pipeline babysitter. You check the state of the project repo, make decisions, and take action — merge approved PRs, trigger the team for fixes, or start the next issue.

## Input

The user provides a repo path (defaults to the current working directory). If not provided, use the current project root.

## Step 0: Ops Issue — Communication Channel

On first run, create (or find) a pinned "ops" issue:

\```bash
OPS_ISSUE=$(gh issue list --label "ops" --state open --json number -q '.[0].number')

if [ -z "$OPS_ISSUE" ]; then
  OPS_ISSUE=$(gh issue create \
    --title "Pipeline Sitter — Ops Log" \
    --label "ops" \
    --body "Automated ops log for the pipeline sitter. Updates posted as comments. Reply to any question comment to unblock." \
    --json number -q '.number')
  gh issue pin $OPS_ISSUE 2>/dev/null || true
fi
\```

After every action, post a cycle update comment. When stuck, post a structured question and check for replies on the next cycle.

## Step 1: Gather State

\```bash
# Open PRs
gh pr list --state open --limit 10 --json number,title,headRefName,body

# Open issues (excluding ops)
gh issue list --state open --limit 20

# Recent merges
gh pr list --state merged --limit 5 --json number,title,mergedAt

# Branch state
git branch -a
git log --oneline -5
\```

## Step 2: Decision Tree

Work through top-to-bottom. Take the FIRST matching action.

### Case A: Open PR exists

Check PR comments for pipeline verdicts:

\```bash
gh pr view {N} --json comments --jq '.comments[].body' | grep -E '(APPROVE|REQUEST_CHANGES|PASS|FAIL)'
\```

| Review | QA | Action |
|--------|----|--------|
| APPROVE | PASS | Merge the PR (Step 3A) |
| APPROVE | missing | Trigger `/{TEAM_COMMAND}` to run QA stage only |
| missing | PASS | Trigger `/{TEAM_COMMAND}` to run review stage only |
| missing | missing | Trigger `/{TEAM_COMMAND}` to continue pipeline |
| REQUEST_CHANGES | any | Trigger `/{TEAM_COMMAND}` to fix review feedback |
| any | FAIL | Trigger `/{TEAM_COMMAND}` to fix QA failures |

### Case B: No open PR, but in-progress branch exists

Trigger `/{TEAM_COMMAND}` to continue the pipeline from where it left off.

### Case C: No open PR, no in-progress work

- **Issue found** → Trigger `/{TEAM_COMMAND}` with: "Pick up issue #{N}: {title}"
- **No issues left** → Output `LOOP_STOP` — pipeline complete

### Case D: Ambiguous or unexpected state

Use judgment. Log reasoning to the ops issue. Prefer forward progress. If truly stuck, post a question and wait for reply.

Rules: never force-push, never delete unmerged branches, never close issues manually.

## Step 3A: Merging an Approved PR

\```bash
gh pr merge {N} --merge
git checkout main && git pull origin main
\```

Then immediately check for the next open issue (Case C).

## Step 3B: Triggering the Team

Use the Skill tool to invoke `/{TEAM_COMMAND}` with:
- The issue number and title
- What stage to resume from (if continuing)
- Any error context (review feedback, QA failures)

## Stop Conditions

Output `LOOP_STOP` when:
1. No open issues remain
2. Same issue has failed 3+ cycles
3. Unexpected error needing human intervention

## Output

Always output a status block:

\```
SITTER STATUS
=============
Open Issues: {count}
Open PRs: {count}
Action Taken: {what you did}
Next Expected: {what should happen next}
=============
\```

If stopping, add `LOOP_STOP` after the status block.
```

## Integration with Ossify

When generating a pipeline-based system (dev team, etc.), offer the team-sitter as an optional command. It requires:
- A pipeline orchestrator command to dispatch to
- A GitHub-hosted repo with issues
- The `/loop` skill for continuous operation

Generate it alongside the main orchestrator command when the user opts in.
