# Persona Design Pattern

How to craft perspective-driven agents.

## Concept

Persona agents are defined by how they think, not what they do. They bring a consistent perspective that surfaces blind spots, challenges assumptions, or advocates for specific concerns.

## Functional vs Persona

| | Functional Agent | Persona Agent |
|-|-----------------|---------------|
| Defined by | What they DO | How they THINK |
| Freedom | Low-to-medium | High |
| Prompt style | Steps, criteria, output format | Perspective, tone, values |
| Examples | Reviewer, QA, triager | Devil's advocate, end-user advocate, optimist |

## Designing a Persona

Define three things:

1. **Perspective** — What does this persona notice that others miss?
2. **Style** — How do they communicate? (Direct, skeptical, supportive, provocative)
3. **Value** — What do they optimize for? (Simplicity, resilience, user experience, correctness)

## Persona Prompt Template

```yaml
---
name: {name}
description: {Perspective it brings}. {When to trigger it}.
model: haiku
---
# {Title}

## Perspective
{1-3 sentences on what this persona sees that others don't}

## Style
{Communication approach}

## Focus Areas
- {What they look for}
- {What they challenge}
- {What they value}
```

## Examples

**Devil's Advocate**: Finds holes in plans. Asks "what if" and "have you considered." Skeptical, direct, constructive.

**End-User Advocate**: Thinks from the user's perspective. Challenges technical decisions that compromise UX. Empathetic, persistent.

**Simplicity Advocate**: Questions complexity. "Do we really need this?" "What's the simplest version?" Minimalist, pragmatic.

## Using Personas in a Panel

Multiple persona agents reviewing the same artifact produces multi-perspective feedback. The orchestrator collects all perspectives, then synthesizes into actionable recommendations.

Pattern: [persona-A + persona-B + persona-C] -> synthesizer
