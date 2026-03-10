---
name: team
description: Orchestrates the dev team pipeline for an issue or task. Routes work through tech-pm, senior, review, and qa agents.
disable-model-invocation: true
argument-hint: [issue-or-task-description]
---
# Dev Team Orchestrator

Run the pipeline defined in CLAUDE.md for this task.

## First-Run Setup

On the **first `/team` invocation** in a project, check the project's CLAUDE.md for a `## Tooling` section. If it doesn't exist, detect the project type and ask the user:

> This project appears to be a {Next.js / React / Node} app. The following optional tools can enhance the pipeline:
>
> 1. **Playwright MCP** — QA can interact with the running app (click, fill forms, navigate)
> 2. **Next.js DevTools MCP** — Senior gets real-time build/runtime errors *(Next.js only)*
> 3. **Figma MCP** — Agents can read design specs for implementation *(if using Figma)*
> 4. **Lighthouse** — QA reports performance/a11y scores *(web apps)*
> 5. **Database MCP** — QA verifies data persistence *(if using Prisma/Drizzle/Postgres)*
>
> Which would you like to set up? (comma-separated numbers, or `skip` to skip all)

After the user responds, record the decision in the project's CLAUDE.md under `## Tooling`:

```markdown
## Tooling

| Tool | Status | Notes |
|------|--------|-------|
| Playwright MCP | ✅ enabled | QA uses for browser testing |
| Next.js DevTools MCP | ✅ enabled | Senior uses for error detection |
| Figma MCP | ⏭ skipped | No Figma workflow |
| Lighthouse | ⏭ skipped | — |
| Database MCP | ✅ enabled | Prisma + PostgreSQL |
```

This table is checked by QA and senior agents to know what tools are available. If a tool is marked `enabled`, set it up (install dependencies, configure `.claude/settings.json` MCP entries). If `skipped`, agents don't attempt to use it.

Skip this setup check if the `## Tooling` section already exists in CLAUDE.md.

## Execution

**CRITICAL: The pipeline is non-stop.** Once started, run ALL stages continuously. Never pause to ask "should I continue?" — the answer is yes. Valid stop points: (a) after APPROVE + PASS (never merge to main), (b) after 3 failed cycles, (c) ambiguous requirements before implementation, (d) task already complete.

**CRITICAL: Never merge PRs to main.** Sub-PRs into feature branches may be merged. PRs to main require user approval.

**CRITICAL: Never close issues manually.** Issues close via `Closes #N` in PR body when merged.

### Stage Status Blocks

Each stage must produce a status block:

```
<step_complete id="N">
  stage: [stage name]
  summary: [what was done]
  output: [artifact, verdict, or result]
</step_complete>
```

### 1. Assess

Read the task. Before doing ANYTHING else:

**a) Inspect repo state.** Check what already exists:
```bash
git log --oneline -5
git status
find src -type f -name "*.ts" -o -name "*.tsx" | head -50
```

If the task's deliverables already exist as working code, STOP and report. Do not run the pipeline on pre-existing work.

**b) Evaluate scope.** If the task is large (many sub-tasks, 50+ files):
- Spawn `tech-pm` to decompose into 2-4 smaller issues with scope manifests
- Create a feature branch from the base
- Run the pipeline for each sub-issue sequentially

**c) Build the scope manifest.** For every implementation task, define:
```
SCOPE MANIFEST:
IN SCOPE: [exact list of tasks/deliverables]
OUT OF SCOPE: [phases, features, files that must NOT be touched]
REFERENCE CODE: [path] — use for patterns only, do not copy/rebuild out-of-scope components
```

### 2. Implement

Spawn `senior` agent. The prompt MUST include:
- The task description
- The **scope manifest** (IN SCOPE / OUT OF SCOPE / REFERENCE CODE rules)
- Instruction to echo scope acknowledgment before coding
- Quality gate commands to run after implementation

If quality gates fail, send errors back to senior. Max 3 retries.

### 3. Verify

After senior completes, the orchestrator independently verifies:

**a) Quality gates:**
```bash
npm run build && eslint . && tsc --noEmit && npm test
```

**b) Scope verification:** Check what files were created/modified. Do they match the scope manifest? Flag any out-of-scope files.

**c) Runtime smoke test** (for web apps):
```bash
fuser -k 3000/tcp 2>/dev/null; sleep 2
npm run dev &
sleep 5
curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/[expected-route]
fuser -k 3000/tcp 2>/dev/null
```

If any verification fails, route back to senior with specifics before creating a PR.

### 4. Push & PR

After verification passes:
- Commit with descriptive message referencing the issue
- Push branch, create PR with `Closes #N` in body
- Check implementation acceptance criteria on the issue

### 5. Review + QA (mandatory, parallel)

Spawn `review` and `qa` agents **simultaneously**. Provide each with:

**Review agent prompt must include:**
- Original task description
- **Scope manifest** (so reviewer can audit scope compliance)
- Summary of changes and files modified
- PR number and repo

**QA agent prompt must include:**
- Original requirements / acceptance criteria
- PR number and repo
- Instruction to kill stale servers before testing
- Which routes/pages to verify

After both complete:
- Both APPROVE + PASS → Complete
- Either REQUEST_CHANGES or FAIL → route feedback to senior, re-run failing stage(s). Max 3 cycles.

### 6. Complete

After APPROVE + PASS:
- Check remaining acceptance criteria (review, QA checkboxes)
- Post completion comment with full report + agent metadata footer
- **Update session log** (see Session Logging in CLAUDE.md)
- Sub-PR into feature branch → merge and continue
- PR into main → report and stop (user merges)

## Agent Metadata

Track metrics from every agent invocation. The Agent tool returns `total_tokens`, `tool_uses`, and `duration_ms` — capture these for every agent spawned during the pipeline.

Include an agent metadata footer on the PR completion comment (and optionally on the PR description). This proves which agents ran, on which models, and at what cost:

```markdown
---
<sub>🤖 **senior** (sonnet) | ⏱ Xs | 🔤 N tokens | 🔧 N tool uses</sub>
<sub>🤖 **review** (haiku) | ⏱ Xs | 🔤 N tokens | 🔧 N tool uses</sub>
<sub>🤖 **qa** (sonnet) | ⏱ Xs | 🔤 N tokens | 🔧 N tool uses</sub>

Generated by `/team`
```

If tech-pm was invoked, include it. If multiple senior cycles ran (due to review feedback), show each cycle. This footer is a pipeline adherence signal — it proves named agents were called, not a generic Claude instance.
