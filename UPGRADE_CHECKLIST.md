# Osteoblaster — Upgrade Checklist

Track improvements to scaffolding patterns and example configurations. Each entry records what changed and whether it's been verified.

## How to Use

- Add entries when patterns, examples, or ossify are updated
- Mark verified after a benchmark or real-world project confirms the feature works
- When running `/ossify` on a new project, review unverified items

## 2026-03-08 — Pipeline Improvements from Benchmark Run

### Parallel Review + QA (verified in dev-team-v2)
- [x] `examples/dev-team/.claude/commands/team.md` — review + QA spawn simultaneously
- [x] `examples/dev-team/README.md` — pipeline diagram shows parallel branches
- [x] `patterns/pipeline.md` — "Linear with Parallel Tail" pattern added
- [x] `ossify.md` — CLAUDE.md template updated with parallel diagram
- **Verified:** dev-team-v2 benchmark Phase 1 (12/12). Not yet verified via `/ossify` on a new project.

### GitHub Trail (verified in dev-team-v2)
- [x] `examples/dev-team/.claude/commands/team.md` — Push & PR step, issue close
- [x] `examples/dev-team/.claude/agents/review.md` — posts verdict as PR comment
- [x] `examples/dev-team/.claude/agents/qa.md` — posts result as PR comment
- [x] `examples/dev-team/.claude/commands/benchmark.md` — GitHub trail verification step
- [x] `examples/dev-team/.claude/agents/benchmark.md` — GitHub trail in scoring criteria
- [x] `examples/dev-team/README.md` — GitHub Trail section
- [x] `patterns/pipeline.md` — GitHub Trail section with examples
- **Verified:** PR #5 on dev-team-v2-benchmark has review + QA comments, issue #1 closed with checkboxes

### Evidence & Screenshots (partially verified)
- [x] `patterns/evidence.md` — new pattern file (text + visual evidence)
- [x] `examples/dev-team/.claude/agents/qa.md` — evidence capture instructions
- [x] `examples/dev-team/README.md` — Evidence & Visual Verification section
- [x] `CLAUDE.md` — repo structure includes evidence.md
- **Verified:** Screenshot manually posted on PR #5. Not yet verified autonomously via QA agent.

### Agent Metadata Footer (unverified)
- [x] `examples/dev-team/.claude/commands/team.md` — Agent Metadata section
- [ ] **Actually appears on a PR** — not yet tested
- **Needs verification:** Next `/team` run should confirm footer appears

### Tooling Setup (unverified)
- [x] `examples/dev-team/.claude/commands/team.md` — First-Run Setup section
- [x] `examples/dev-team/.claude/agents/qa.md` — tooling-aware process steps
- [x] `examples/dev-team/README.md` — Tooling section with MCP table
- [x] `ossify.md` — references evidence pattern
- [ ] **Triggered on first run** — not yet tested
- [ ] **MCP servers installed correctly** — not yet tested
- **Needs verification:** Run `/team` on a fresh Next.js project, enable Playwright MCP, confirm QA uses it

### Benchmark Visual Component (unverified)
- [x] `examples/dev-team/.claude/commands/benchmark.md` — Phase 1 includes web server, Phases 2-3 extend web view
- [x] `dev-team-v2/.claude/commands/benchmark.md` — same updates
- [ ] **Benchmark run with web view** — not yet tested
- **Needs verification:** Next benchmark run should produce QA screenshots of the running todo app

### Pipeline Hard Failure (verified in dev-team-v2)
- [x] `examples/dev-team/.claude/agents/benchmark.md` — Pipeline Adherence = 0 is automatic failure
- [x] `examples/dev-team/.claude/commands/benchmark.md` — hard failure stops benchmark
- **Verified:** First benchmark attempt failed on pipeline adherence, fixed, re-ran successfully
