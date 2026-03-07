---
name: team
description: Orchestrates the dev team pipeline for an issue or task. Runs triage -> implement -> review -> QA with quality gates between stages.
disable-model-invocation: true
argument-hint: [issue-or-task-description]
---

# Dev Team Pipeline

Run the full development pipeline for: $ARGUMENTS

## Pipeline

Execute each stage sequentially. Stop the pipeline if a quality gate fails.

### Stage 1: Triage (tech-pm)

Delegate to the `tech-pm` agent:
- Refine the requirements
- Break into concrete steps if needed
- Output: clear implementation plan

### Stage 2: Implement (senior)

Delegate to the `senior` agent:
- Implement the plan from Stage 1
- Self-verify before handing off

**Quality Gate:** Run build + lint + tests. If any fail, send back to senior with the failure output.

### Stage 3: Review (review)

Delegate to the `review` agent:
- Review the diff from Stage 2
- If REQUEST_CHANGES: send back to senior with the required changes, then re-review
- If APPROVE or APPROVE_WITH_NITS: proceed

### Stage 4: Verify (qa)

Delegate to the `qa` agent:
- Run full test suite
- Verify requirements are met
- If FAIL: send back to senior with the failure report, then re-run stages 2-4

## Output

Summarize what was done:
- Task description
- Changes made (files modified)
- Review verdict
- QA result
- Any issues encountered and how they were resolved
