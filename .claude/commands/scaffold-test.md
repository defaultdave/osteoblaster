---
name: scaffold-test
description: Sanity-checks osteoblaster's dev-team scaffolding output against the live instance and structural expectations. Run after changing patterns, ossify, or examples.
---

# Scaffold Test — Dev Team

Verify that osteoblaster's dev-team example matches the live instance and meets structural expectations.

## Inputs

- **Example**: `examples/dev-team/` (this repo)
- **Live instance**: `../dev-team-v2/` (canonical output)
- **Test spec**: `tests/fixtures/dev-team.md`

## Process

Read the test spec at `tests/fixtures/dev-team.md` first — it defines all expected files, frontmatter values, and content markers.

### Check 1: Sync Diff

Compare `examples/dev-team/.claude/` against `../dev-team-v2/.claude/` recursively. Exclude `memory/` (runtime state).

Report:
- **IN SYNC** if no differences
- **DRIFTED** with a file-by-file diff summary if differences exist

Also compare `examples/dev-team/CLAUDE.md` against `../dev-team-v2/CLAUDE.md`.

### Check 2: File Structure

Verify all expected files from the spec exist in `examples/dev-team/`:

```
.claude/agents/senior.md
.claude/agents/review.md
.claude/agents/qa.md
.claude/agents/tech-pm.md
.claude/agents/benchmark.md
.claude/commands/team.md
.claude/commands/benchmark.md
.claude/hooks/post-edit-lint.sh
.claude/settings.json
CLAUDE.md
```

Report any missing or unexpected files.

### Check 3: Agent Frontmatter

For each agent file, parse YAML frontmatter and verify:
- `name` matches expected value
- `model` matches expected tier (sonnet/haiku)
- `description` is present and non-empty

Report mismatches as a table.

### Check 4: Content Markers

Verify key content exists in the right files (from the spec's assertion tables):

**Agents:**
- `senior.md` contains "## Testing" and "Tests are part of the deliverable"
- `review.md` contains "## Verdicts" and all three verdict types
- `qa.md` contains "## Evidence" and "## Test Sufficiency"
- `tech-pm.md` contains "No code"
- `benchmark.md` contains "## Hard Failure Rules" and "Pipeline Adherence = 0"

**Commands:**
- `team.md` references spawning senior, review, qa agents
- `team.md` references quality gates
- `benchmark.md` references scoring dimensions

**CLAUDE.md:**
- Contains `## Pipeline` with stage table
- Contains `### Quality Gates`
- Contains `### Workflow Rules`
- Contains `### GitHub Trail`
- Contains `### Tooling`

**Infrastructure:**
- `settings.json` has `PostToolUse` hook matching `Write|Edit`
- `post-edit-lint.sh` references eslint

### Check 5: Prompt Size

Verify no agent or command file exceeds 500 lines (design principle).

## Output

Print a structured report:

```
## Scaffold Test Results — Dev Team

### Sync: {IN SYNC | DRIFTED}
{diff details if drifted}

### Structure: {PASS | FAIL}
{missing/extra files if failed}

### Frontmatter: {PASS | FAIL}
| Agent | name | model | status |
|-------|------|-------|--------|
{table}

### Content Markers: {PASS | FAIL}
{list of missing markers if failed}

### Prompt Size: {PASS | FAIL}
{any files over 500 lines}

### Overall: {ALL CLEAR | X issue(s) found}
```

If everything passes, print "ALL CLEAR — scaffolding is consistent and structurally sound."

If issues are found, list them clearly so the user knows exactly what to fix.
