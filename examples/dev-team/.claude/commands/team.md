---
name: team
description: Orchestrates the dev team pipeline for an issue or task. Routes work dynamically between tech-pm, senior, review, and qa agents.
disable-model-invocation: true
argument-hint: [issue-or-task-description]
---

# Dev Team Orchestrator

Run the pipeline defined in CLAUDE.md for this task. Every stage is documented there — refer to it throughout.

Task: $ARGUMENTS

## Execution

### 1. Assess
Read the task. If requirements are clear → skip to Stage 2. If ambiguous or large → route to `tech-pm` for a plan first.

### 2. Implement
Spawn `senior` agent(s). For independent work, parallelize across multiple agents.

When implementation is complete, run the quality gates listed in CLAUDE.md. If any gate fails, send the full error output back to `senior`. Max 3 retries before escalating.

### 3. Review (do not skip)
Spawn `review` agent. Provide:
- The original task description
- Summary of changes and files modified
- Instruction to read the diff and produce a verdict (APPROVE / APPROVE_WITH_NITS / REQUEST_CHANGES)

If REQUEST_CHANGES: route feedback to `senior` → re-run gates → re-review. Max 3 cycles.

### 4. QA (do not skip)
Spawn `qa` agent. Provide:
- The original task requirements
- The review verdict
- Instruction to run tests and verify requirements are met

If FAIL: route failure report to `senior` → fix → gates → re-review → re-QA. Max 3 total cycles.

### 5. Complete
Write learnings to memory. Report:

- **Task:** what was requested
- **Changes:** files modified/created
- **Quality gates:** pass/fail
- **Review verdict:** (from review agent)
- **QA result:** (from qa agent)
- **Issues:** problems encountered and resolutions
