# Pipeline Pattern

How to chain agents with handoff contracts.

## Concept

A pipeline is a sequence of agents where each one's output feeds the next. The orchestrator command manages the flow and stops if a stage fails.

## Linear Pipeline

The simplest pattern: A -> B -> C.

```
triage -> implement -> review -> verify
```

Each agent receives:
- The original task/issue
- The output from the previous stage

The orchestrator checks quality gates between stages.

## Linear with Parallel Tail

When verification stages are independent of each other, run them in parallel:

```
                          ┌→ review ─┐
implement → quality gate ─┤          ├→ done
                          └→ QA ─────┘
```

Review reads the diff and checks code quality. QA runs tests and verifies requirements. Neither needs the other's output. Running them in parallel cuts the back half of the pipeline roughly in half with zero coordination risk.

On failure, only re-run the failing stage — not both.

## Parallel Then Merge

Run independent work simultaneously, then synthesize:

```
[analyst-A + analyst-B + analyst-C] -> synthesizer
```

Use the Agent tool to spawn parallel agents, then pass all results to the synthesizer.

## Handoff Contract

Each agent should produce structured output the next agent can parse:

1. **Status**: PASS / FAIL / NEEDS_REVISION
2. **Artifact**: The work product (code, review, report)
3. **Notes**: Context for the next stage

If an agent returns NEEDS_REVISION, the orchestrator routes back to the appropriate earlier stage.

## Retry Logic

- Set a max retry count (typically 2-3)
- If an agent fails the same stage repeatedly, stop and report to the user
- Don't loop forever — surface the problem

## Enforcement: Rules in CLAUDE.md, Procedure in Command

Orchestrators will skip stages to optimize for speed unless structurally prevented. The command file alone is not sufficient — it's only loaded when invoked.

**Put pipeline rules in the project's CLAUDE.md** (always loaded):
- Which stages are mandatory
- What completion looks like (required output fields)
- The rule: "a task is not complete until X and Y exist"

**Put execution procedure in the command file** (loaded on invocation):
- How to run each stage
- What context to pass to each agent
- Retry logic and escalation

The command file should reference CLAUDE.md: "Run the pipeline defined in CLAUDE.md."

This split was proven necessary in practice: a dev team orchestrator skipped review and QA on all phases despite the command file listing them as routing rules.

## GitHub Trail

The pipeline should leave a visible audit trail:
- PRs created and linked to issues
- Review and QA verdicts posted as PR comments (`gh pr comment`)
- Acceptance criteria checkboxes checked on issues (`gh issue edit`)
- **Never merge PRs without explicit user permission.** Agents report results and wait for authorization.
- Issues auto-close via `Closes #N` in the PR body when the PR is merged

This makes pipeline execution verifiable by anyone looking at the repo.

## Example: CLAUDE.md Pipeline Section

```markdown
### Pipeline

Every task flows through these stages. Stages 2-4 are mandatory.

                                       ┌→ 3. Review ─┐
[1. Triage] → 2. Implement → Quality Gate → Push/PR ─┤              ├→ Done
                                       └→ 4. QA ────┘

A task is not complete until both a review verdict and a QA result exist.

### Workflow Rules

1. Batching is allowed, skipping is not.
2. Feedback loops: max 3 cycles. On retry, only re-run the failing stage(s).
3. The output proves the pipeline ran: changes, gate status, review verdict, QA result, PR URL.
```

## Example: Command File Execution

```markdown
# Orchestrator

Run the pipeline defined in CLAUDE.md for this task.

Task: $ARGUMENTS

## Execution

### 1. Assess
If requirements are clear → skip to Implement. If ambiguous → route to triage agent.

### 2. Implement
Spawn agent(s). Run quality gates. If fail, send output back. Max 3 retries.

### 3. Push & PR
Commit, push, create PR linked to issue. Check acceptance criteria checkboxes.

### 4. Review + QA (parallel, do not skip)
Spawn review and QA agents simultaneously. Both post verdicts as PR comments.
If either fails, route feedback to implement and re-run only the failing stage.

### 5. Complete
Check remaining checkboxes, close issue. Report: task, changes, gate status, review verdict, QA result, PR URL.
```

## Compaction

Long-running pipelines often trigger context compaction. Instruct your project's CLAUDE.md to preserve pipeline-critical state:

- **Always preserve:** current issue number, pipeline stage, quality gate results (pass/fail), file paths changed, PR number, blocking errors
- **Always discard:** full file contents (re-readable), verbose test/build output (keep pass/fail only), dead-end exploration

Without compaction guidance, the orchestrator loses track of which stages have run and re-runs the entire pipeline or skips completed verification.
