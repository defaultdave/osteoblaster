---
name: benchmark
description: Runs a multi-phase benchmark to measure dev-team pipeline quality. Optionally provide a GitHub issues URL or use the built-in todo app benchmark.
disable-model-invocation: true
argument-hint: "[github-issues-url] or leave blank for built-in benchmark"
---
# Dev Team Benchmark

Measures pipeline quality by running phased tasks through `/team` and scoring results.

## Setup

- **GitHub URL provided:** Clone the repo locally, fetch open issues sorted by number, create branch (`benchmark/run-YYYY-MM-DD`), scaffold project if needed, run each issue through the pipeline sequentially.
- **No URL (built-in):** Create `benchmark-todo-[timestamp]/` directory with `package.json` (name: "todo-cli", type: "module", scripts for build/test/lint) and empty `todos.json`. Initialize with `npm init -y` and install dev dependencies: `typescript`, `vitest`, `eslint`, `@typescript-eslint/parser`, `@typescript-eslint/eslint-plugin`.

## Built-in Benchmark: Todo CLI

4 sequential phases (each builds on the last):

1. **Phase 1: Add, List & Web View** — `addTodo(title)` returns new todo, `listTodos()` returns all. Auto-increment IDs, JSON file storage in `todos.json`. Plus a minimal web server (`src/server.ts`) on port 3000 that serves an HTML page displaying all todos. This gives us a visual smoke test from Phase 1 — QA must screenshot the running page.
2. **Phase 2: Complete & Delete** — `completeTodo(id)`, `deleteTodo(id)`. Error handling for missing IDs (throw descriptive error). Web view updated to show completed state (strikethrough or checkbox).
3. **Phase 3: Filtering & Search** — `filterTodos(status)` accepts "all"/"completed"/"pending". `searchTodos(query)` does case-insensitive substring match on title. Web view adds filter/search controls.
4. **Phase 4: CLI Interface** — `cli.ts` with commands: add, list, complete, delete, filter, search. Human-readable output. Help text on no args or `--help`.

## Execution

For each phase/issue:
1. **Run the full `/team` pipeline** — do NOT bypass by spawning agents directly. The orchestrator MUST follow the `/team` flow: senior → quality gates → push/PR → review → QA. Spawning only `senior` skips review and QA, which is a pipeline adherence failure.
2. **GitHub trail is mandatory:**
   - Senior commits and pushes code, creates a PR linked to the issue
   - Review agent posts verdict as a PR comment (via `gh pr comment`)
   - QA agent posts result as a PR comment (via `gh pr comment`)
   - Acceptance criteria checkboxes on the issue are checked as met (via `gh issue edit`)
   - Issue is closed when phase completes successfully
3. Spawn `benchmark` agent to score the result (including GitHub trail)
4. Record scorecard
5. **Pipeline Adherence = 0 is an automatic failure** — stop the benchmark, diagnose why the pipeline was skipped, and fix before retrying. Do not continue to the next phase.
6. If phase score ≤ 6/12, ask user whether to continue or abort

## Final Report

Summary table: Correctness / Tests / Pipeline / Quality scores per phase (0-3 each, max 12/phase, 48 total). Strengths, weaknesses, recommendations. Save report to `.claude/memory/benchmarks/`.

## Reset & Rerun

- Built-in: delete `benchmark-todo-*` directory, run `/benchmark` again
- External: create new branch from main, reopen closed issues
