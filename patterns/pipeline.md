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

## Example Orchestrator Structure

```markdown
## Pipeline

### Stage 1: {Agent Name}
Delegate to `{agent}`:
- {what to do}
- {what to produce}

**Quality Gate:** {command to run}. If fail, send back with output.

### Stage 2: {Agent Name}
Delegate to `{agent}`:
- {what to do with Stage 1 output}

...repeat...

## Output
Summary of what happened across all stages.
```
