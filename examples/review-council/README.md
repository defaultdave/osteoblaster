# Review Council

Adversarial multi-perspective review using persona agents. Multiple viewpoints evaluate a decision in parallel, then a synthesizer finds consensus, conflicts, and blind spots.

## When to Use

- Major decisions that benefit from diverse perspectives
- Evaluating claims, plans, or proposals before committing
- Catching groupthink and sycophantic drift
- Any situation where "what am I missing?" matters

## Agents

| Agent | Model | Role |
|-------|-------|------|
| critical-thinker | sonnet | Tests reasoning quality, finds weak assumptions, flags unsupported claims |
| creative-peer | opus | Generative thinker — expands possibilities, makes unexpected connections |
| know-it-all | sonnet | Stress-tester — edge cases, failure modes, second-order effects |
| snidely | haiku | Inverse signal — enthusiastically endorses bad ideas. The more excited, the worse the plan |
| baseline | sonnet | Control group — raw prompt, no persona. Detects drift in other agents |
| synthesizer | opus | Goes last. Finds consensus, conflicts, blind spots. Never adds own opinion on the topic |

## Pipeline

```
                    critical-thinker ──┐
                    creative-peer ─────┤
[question] ──>      know-it-all ───────┼──> [optional rebuttals] ──> synthesizer
                    snidely ───────────┤
                    baseline ──────────┘
```

Round 1 runs in parallel. Optional Round 2 targets contradictions with narrow rebuttals. Synthesizer always goes last.

## Review Types

| Type | When | Agents |
|------|------|--------|
| Full Review | Major decisions | All 6 |
| Evaluation | Assessing a claim or idea | critical-thinker, know-it-all, snidely |
| Brainstorm | Exploring options | creative-peer, critical-thinker |
| Gut Check | Quick sanity check | critical-thinker only |

## Files

```
.claude/
├── agents/
│   ├── critical-thinker.md
│   ├── creative-peer.md
│   ├── know-it-all.md
│   ├── snidely.md
│   ├── baseline.md
│   └── synthesizer.md
└── commands/
    └── council.md        # Orchestrator — selects review type, dispatches agents
```
