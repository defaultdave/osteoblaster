---
name: council
description: Convenes the review council for adversarial multi-perspective analysis of a decision, plan, or idea.
argument-hint: [question-or-decision-to-review]
---

# Review Council

Evaluate: $ARGUMENTS

## Step 1: Classify Review Type

Based on the question, select the appropriate review type:

| Type | When | Agents |
|------|------|--------|
| Full Review | Major decisions, high stakes | All agents + baseline + synthesizer |
| Evaluation | Assessing a specific claim or idea | critical-thinker, know-it-all, snidely |
| Brainstorm | Exploring options or possibilities | creative-peer, critical-thinker |
| Gut Check | Quick sanity check | critical-thinker only |

Confirm the review type with the user before proceeding.

## Step 2: Round 1 — Parallel Review

Dispatch all selected agents **in parallel** using the Agent tool. Each agent receives the question directly.

For the `baseline` agent: send the raw question only — no framing, no context about other agents, no persona instructions.

## Step 3: Round 2 — Targeted Rebuttals (Optional)

Trigger rebuttals only if Round 1 surfaces:
- Direct contradictions between agents
- Blind spots no one probed
- User requests deeper examination

Max 2-4 rebuttals. Narrow scope. Quote the specific claim being challenged. Use fresh agent instances — say "another analyst," not the agent's name (avoids authority bias).

## Step 4: Synthesis

Delegate to the `synthesizer` agent with ALL outputs from previous rounds (including baseline and any rebuttals).

## Step 5: Present Findings

Show the synthesis, then ask the user for their decision.
