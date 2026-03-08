---
name: benchmark
description: Runs a multi-phase benchmark to measure dev-team pipeline quality. Optionally provide a GitHub issues URL or use the built-in todo app benchmark.
disable-model-invocation: true
argument-hint: "[github-issues-url] or leave blank for built-in benchmark"
---

# Dev Team Benchmark

Measures your dev-team pipeline by running a series of phased tasks and scoring the results.

Task: $ARGUMENTS

## Setup

### If a GitHub issues URL was provided:
1. Fetch open issues from the repo using `gh issue list`
2. Sort by issue number (ascending) — this is the execution order
3. Branch from main: `benchmark/run-YYYY-MM-DD`
4. Run each issue through the pipeline sequentially (see Execution)
5. After the run, the branch contains all work — main stays clean for the next run

### If no project was provided:
1. Ask the user: *"No benchmark project provided. I can use the built-in Todo CLI benchmark — a 4-phase file-based todo app with no dependencies. Use it, or provide a GitHub issues URL?"*
2. If they confirm the built-in: create a fresh directory `benchmark-todo-[timestamp]/`
3. Initialize with `package.json` (name: "benchmark-todo", type: "module") and empty `todos.json` (`[]`)
4. Use the phase specs below

## Built-in Benchmark: Todo CLI

A minimal file-based todo app built in 4 sequential phases. Each phase builds on the last. All storage is a local `todos.json` file — no database, no server.

### Phase 1: Add & List Todos
**Requirements:**
- `addTodo(title)` — creates a todo with `{ id, title, completed: false, createdAt }`
- `listTodos()` — returns all todos from `todos.json`
- IDs are auto-incrementing integers
- Storage: read/write `todos.json` (create if missing)
- Export functions from `todo.js`

**Acceptance criteria:** Can add 3 todos, list them, see all 3 with correct fields.

### Phase 2: Complete & Delete
**Requirements:**
- `completeTodo(id)` — sets `completed: true` for the matching todo
- `deleteTodo(id)` — removes the todo from the list
- Both throw/return an error if ID doesn't exist
- Add to existing exports in `todo.js`

**Acceptance criteria:** Can complete a todo (verify it's marked), delete a todo (verify it's gone), error on invalid ID.

### Phase 3: Filtering & Search
**Requirements:**
- `filterTodos(status)` — returns todos matching status: `"all"`, `"completed"`, `"pending"`
- `searchTodos(query)` — case-insensitive substring match on title
- Add to existing exports in `todo.js`

**Acceptance criteria:** Filter returns correct subsets, search finds partial matches, empty results return `[]`.

### Phase 4: CLI Interface
**Requirements:**
- `cli.js` — command-line entry point using only `process.argv` (no dependencies)
- Commands: `add <title>`, `list`, `complete <id>`, `delete <id>`, `filter <status>`, `search <query>`
- Human-readable output (not raw JSON)
- Shows usage/help on no arguments or unknown command

**Acceptance criteria:** All commands work from terminal, output is readable, help text exists.

## Execution

Run phases **sequentially, one at a time**. This is critical — the benchmark measures incremental pipeline performance, not batch capability.

For each phase:

### 1. Run the team pipeline
Invoke the `/team` command with the phase spec as the task. Include:
- The full phase requirements and acceptance criteria
- Instruction that this builds on the existing codebase (phases 2+ reference phase 1's code)

### 2. Score the result
After `/team` completes, spawn the `benchmark` agent with:
- The phase spec (what was requested)
- The team's output report (changes, review verdict, QA result)
- The current state of the codebase

### 3. Record the scorecard
Save the benchmark agent's scorecard before proceeding to the next phase.

### 4. Continue or stop
- If phase scored 6/12 or below: ask the user if they want to continue or abort
- Otherwise: proceed to the next phase

## Reset & Rerun

The benchmark is designed to be repeatable. After a run:

### Built-in benchmark:
- Delete the `benchmark-todo-*` directory
- Run `/benchmark` again — fresh start every time

### External repo benchmark:
- Main never changes — all work lives on the benchmark branch
- To rerun: create a new branch from main (`benchmark/run-YYYY-MM-DD-v2`)
- Reopen any issues that were closed during the previous run (the PR was never merged, so the work doesn't exist on main)
- Old benchmark branches stay as history for comparison

## Final Report

After all phases complete, produce a summary:

```
# Benchmark Results

| Phase | Correctness | Tests | Pipeline | Quality | Total |
|-------|-------------|-------|----------|---------|-------|
| 1     | X/3         | X/3   | X/3      | X/3     | X/12  |
| 2     | X/3         | X/3   | X/3      | X/3     | X/12  |
| 3     | X/3         | X/3   | X/3      | X/3     | X/12  |
| 4     | X/3         | X/3   | X/3      | X/3     | X/12  |

**Overall: X/48**

## Strengths
- ...

## Weaknesses
- ...

## Recommendations
- ...
```

Save this report to `memory/benchmarks/` (or the project's memory directory) with the timestamp for future comparison.
