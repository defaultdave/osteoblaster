# Feedback Loop Pattern

Run, validate, fix, repeat — until quality gates pass.

## Concept

A feedback loop sends failed work back to the originating agent with specific failure context. The agent fixes the issue and re-submits for validation.

## Structure

```
agent produces work
  -> quality gate runs
    -> PASS: proceed to next stage
    -> FAIL: send failure output back to agent
      -> agent fixes
      -> quality gate runs again
      -> (max N retries, then escalate to user)
```

## Implementation

In an orchestrator command:

```markdown
### Stage: Implement

Delegate to `senior` agent with the task requirements.

**Quality Gate:** Run `npm run build && npm run lint && npm test`.

If any command fails:
1. Send the full error output back to `senior`
2. Ask senior to fix the specific failure
3. Re-run the quality gate
4. Maximum 3 attempts. If still failing, report to the user with all error context.
```

## Key Principles

- **Include the full error**: Don't summarize — give the agent the raw output
- **Be specific about what failed**: "lint failed on line 42" not "checks failed"
- **Cap retries**: 2-3 attempts max. Infinite loops waste tokens and time.
- **Escalate clearly**: When retries are exhausted, give the user enough context to intervene
