---
name: teach
description: Teach the assistant a new skill. Creates a skill file with trigger conditions and process steps.
argument-hint: [skill-name-or-description]
---

# Teach a New Skill

The user wants to teach you a new capability: $ARGUMENTS

## Process
1. Ask the user to describe:
   - **What it does** — the capability in one sentence
   - **When to use it** — trigger conditions (what situation activates this skill)
   - **How it works** — step-by-step process
2. Write a skill file to `.claude/skills/` with this format:

```markdown
---
name: [skill-name]
description: [what it does]. Triggers on [specific conditions].
---
# [Skill Name]

## When to Trigger
[Conditions that activate this skill]

## Process
[Step-by-step instructions]
```

3. Confirm the skill was saved and summarize when it will activate
