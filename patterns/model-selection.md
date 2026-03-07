# Model Selection Pattern

When to use haiku vs sonnet vs opus for agent tasks.

## Decision Matrix

| Model | Cost | Speed | Use When |
|-------|------|-------|----------|
| **haiku** | Low | Fast | Triage, classification, code review, planning, formatting, simple transforms |
| **sonnet** | Medium | Medium | Implementation, complex reasoning, test writing, debugging, refactoring |
| **opus** | High | Slower | Architecture decisions, nuanced analysis, ambiguous problems, final synthesis |

## Rules of Thumb

1. **Start with haiku.** If the task is about reading, classifying, or following a clear rubric, haiku handles it well.
2. **Upgrade to sonnet for creation.** Writing new code, solving bugs, designing tests — these need stronger reasoning.
3. **Reserve opus for judgment calls.** When the task requires weighing tradeoffs, handling ambiguity, or making architectural decisions.

## Agent Type Mapping

| Agent Type | Typical Model | Why |
|-----------|---------------|-----|
| Triager / PM | haiku | Reading, classifying, planning — no code generation |
| Code reviewer | haiku | Following a rubric, evaluating existing code |
| Implementer | sonnet | Writing new code, solving problems |
| QA / Tester | sonnet | Reasoning about edge cases, writing tests |
| Architect | sonnet/opus | Design decisions, tradeoff analysis |
| Persona (critic, advocate) | haiku | Perspective-driven, not computation-heavy |

## Cost Impact

On a typical dev pipeline (triage -> implement -> review -> QA):
- haiku for triage + review, sonnet for implement + QA
- ~20-30% cost savings vs all-sonnet, no quality loss on haiku tasks
