# Team Sitter Pattern

Autonomous pipeline babysitter that checks repo state, merges approved PRs, triggers the team for next work, and stops when done.

## Concept

A team-sitter command monitors a project's GitHub state and drives the pipeline forward without manual intervention. It pairs with `/loop` for continuous operation — check state, act, report, repeat.

The sitter never implements or reviews code itself. It only observes repo state and dispatches the team orchestrator command.

## When to Use

- Project has a pipeline orchestrator (e.g., `/team`) and a GitHub issue backlog
- User wants hands-off execution: "work through these issues while I'm away"
- Multiple issues need sequential or parallel pipeline runs

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

## Merge Authorization

By default, the sitter does NOT merge PRs to main — it waits for user approval. Authorization escalates based on user signals:

1. **No signal** — Post "Ready to merge PR #{N}" on the ops issue, wait for reply
2. **User merges one PR manually** — Single-PR approval only
3. **User comments with explicit authorization** (e.g., "auto-merge approved", "keep it up", "merge away") — **Blanket merge authorization** for the rest of the session

This prevents the sitter from blocking on merge approval for multiple cycles when the user has clearly indicated trust. The sitter logs when blanket authorization is detected.

**Learned from practice:** In a 14-hour overnight run, the sitter wasted ~60 minutes (3 cycles) waiting for merge approval on a PR that was clearly ready, despite the user having already merged one PR and commented "keep it up."

## Parallel Pipelines

When multiple open issues have no dependency on each other, spawn concurrent team instances instead of processing sequentially.

**Independence check:** Two issues are independent if they don't reference each other, touch different areas of the codebase, and neither is a prerequisite for the other.

**How to parallelize:**
- Create separate feature branches for each issue
- Spawn multiple team invocations using parallel Agent tool calls
- Track each pipeline independently — one failing doesn't block the other
- Merge completed PRs as they finish

**Limits:** Max 2 concurrent pipelines to avoid merge conflicts. If unsure about independence, run sequentially.

**Learned from practice:** In a run with 8 issues, several pairs (cart+checkout, polish+testing) could have overlapped. Sequential processing added hours of unnecessary wall-clock time.

## Stale PR Cleanup

If a PR is clearly stale or a duplicate (e.g., created by a different tool, superseded by another PR for the same issue, or abandoned with no activity for 3+ cycles), close it with a comment explaining why. This is the one exception to "never close things manually."

**Learned from practice:** A copilot-generated duplicate PR cluttered the state assessment on every cycle, adding noise to decision-making without any value.

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
3. Never force-push or delete unmerged branches. Never close issues manually.
4. Stale/duplicate PRs may be closed with a comment (see Stale PR Cleanup above)
5. If truly stuck, post a question to the ops issue and wait for reply

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

## Merge Authorization

By default, do NOT merge PRs to main — wait for user approval. Authorization escalates:

1. **No signal** — Post "Ready to merge PR #{N}" on the ops issue, wait for reply
2. **User merges one PR manually** — Single-PR approval only
3. **User comments with explicit authorization** (e.g., "auto-merge approved", "keep it up") — **Blanket authorization** for the session. Log it on the ops issue.

Check ops issue comments for authorization signals every cycle.

## Parallel Pipelines

When multiple open issues are independent (different features, no prerequisites), spawn up to 2 concurrent `/{TEAM_COMMAND}` instances on separate feature branches. If unsure about independence, run sequentially.

## Stale PR Cleanup

Close clearly stale/duplicate PRs (created by other tools, superseded, or abandoned 3+ cycles) with a comment. Log to ops issue.

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

- **No issues left** → Output `LOOP_STOP` — pipeline complete
- **One issue** → Trigger `/{TEAM_COMMAND}` with: "Pick up issue #{N}: {title}"
- **Multiple independent issues** → Spawn up to 2 concurrent `/{TEAM_COMMAND}` instances (see Parallel Pipelines). If dependent, process the prerequisite first.

### Case D: Ambiguous or unexpected state

Use judgment. Log reasoning to the ops issue. Prefer forward progress. If truly stuck, post a question and wait for reply.

Rules: never force-push or delete unmerged branches. Never close issues manually. Stale/duplicate PRs may be closed (see Stale PR Cleanup).

## Step 3A: Merging an Approved PR

Check merge authorization (see above). If authorized, merge immediately. If not, post to ops issue and wait.

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

## Recommended Usage

\```
/loop 5m /{TEAM_COMMAND}-sitter {repo-path}
\```

Use a 5-minute interval. Longer intervals (10-20m) waste time between completed pipelines. Shorter intervals (1-2m) burn cycles checking unchanged state.
```

## Integration with Ossify

When generating a pipeline-based system (dev team, etc.), offer the team-sitter as an optional command. It requires:
- A pipeline orchestrator command to dispatch to
- A GitHub-hosted repo with issues
- The `/loop` skill for continuous operation

Generate it alongside the main orchestrator command when the user opts in.
