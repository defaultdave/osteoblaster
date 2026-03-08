# Hooks Pattern

Shell scripts that run automatically before or after Claude Code tool calls, providing deterministic guardrails outside the prompt.

## Concept

Hooks are configured in `.claude/settings.json` under the `hooks` key. Each hook binds to an event, optionally matches specific tools, and runs a shell command. Claude Code pipes a JSON object to stdin with context about the event.

## Hook Events

| Event | Fires | Use For |
|-------|-------|---------|
| `PreToolUse` | Before a tool runs | Blocking writes, validating commands |
| `PostToolUse` | After a tool runs | Linting, formatting, logging |
| `Notification` | When Claude needs user attention | Desktop alerts |
| `SubagentStart` | When a subagent spawns | Logging, metrics |
| `SubagentStop` | When a subagent exits | Duration tracking, metrics |

## Exit Code Behavior

| Context | Exit 0 | Exit 1 | Exit 2 |
|---------|--------|--------|--------|
| `PreToolUse` | Allow | Allow (output shown to agent) | **Deny** (block the tool call, reason shown to agent) |
| `PostToolUse` | Silent | Output surfaced to agent | — |
| `Notification` | Silent | Output shown as warning | — |
| `SubagentStart/Stop` | Silent | Output shown as warning | — |

## Pattern 1: Post-Edit Lint

Runs ESLint on any file Claude edits or writes. Catches issues immediately instead of discovering them at the end of a pipeline.

**Event:** `PostToolUse` — matcher `Edit|Write`

```bash
#!/bin/bash
# .claude/hooks/post-edit-lint.sh
set -euo pipefail

file=$(jq -r '.tool_input.file_path // .tool_input.file_path' < /dev/stdin)

# Only lint JS/TS files
case "$file" in
  *.js|*.ts|*.jsx|*.tsx) ;;
  *) exit 0 ;;
esac

npx eslint --no-warn-ignored "$file" 2>&1
```

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "command": ".claude/hooks/post-edit-lint.sh"
      }
    ]
  }
}
```

Exit 1 from the linter surfaces errors to the agent, which will attempt to fix them. Exit 0 means the file is clean.

## Pattern 2: File Guard

Blocks writes to sensitive files before they happen. Exit code 2 denies the tool call entirely.

**Event:** `PreToolUse` — matcher `Edit|Write`

```bash
#!/bin/bash
# .claude/hooks/file-guard.sh
set -euo pipefail

file=$(jq -r '.tool_input.file_path // empty' < /dev/stdin)

case "$file" in
  *.env|*.env.*) echo "BLOCKED: .env files are manually managed"; exit 2 ;;
  *lock.json|*lock.yaml|*.lock) echo "BLOCKED: lock files are generated, not edited"; exit 2 ;;
  .git/*) echo "BLOCKED: direct .git/ writes are not allowed"; exit 2 ;;
  *) exit 0 ;;
esac
```

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "command": ".claude/hooks/file-guard.sh"
      }
    ]
  }
}
```

The agent sees the denial reason and adjusts its approach — for example, telling the user to update the `.env` file manually.

## Pattern 3: Auto-Format

Runs a formatter after every edit so Claude never commits inconsistently styled code. Always exits 0 — formatting should never block the agent.

**Event:** `PostToolUse` — matcher `Edit|Write`

```bash
#!/bin/bash
# .claude/hooks/auto-format.sh
set -uo pipefail

file=$(jq -r '.tool_input.file_path // empty' < /dev/stdin)

[ -z "$file" ] && exit 0

# Run Prettier if it's a supported file type
case "$file" in
  *.js|*.ts|*.jsx|*.tsx|*.json|*.css|*.md)
    npx prettier --write "$file" 2>/dev/null
    ;;
esac

# Always succeed — formatting is cosmetic, not blocking
exit 0
```

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "command": ".claude/hooks/auto-format.sh"
      }
    ]
  }
}
```

Order matters: if you use both lint and format hooks, put the formatter first so the linter checks already-formatted code.

## Pattern 4: Command Firewall

Inspects Bash commands before execution and blocks destructive operations. A denylist catches known-dangerous patterns; an allowlist is stricter but requires maintenance.

**Event:** `PreToolUse` — matcher `Bash`

```bash
#!/bin/bash
# .claude/hooks/command-firewall.sh
set -euo pipefail

command=$(jq -r '.tool_input.command // empty' < /dev/stdin)

# Denylist approach: block known-dangerous patterns
deny_patterns=(
  'rm -rf /'
  'rm -rf \*'
  'git push --force'
  'git push.*-f '
  'DROP TABLE'
  'DROP DATABASE'
  'mkfs\.'
  ':(){:|:&};:'
)

for pattern in "${deny_patterns[@]}"; do
  if echo "$command" | grep -qiE "$pattern"; then
    echo "BLOCKED: command matches dangerous pattern: $pattern"
    exit 2
  fi
done

exit 0
```

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "command": ".claude/hooks/command-firewall.sh"
      }
    ]
  }
}
```

The denylist approach is simpler and covers most cases. An allowlist (only permit `npm`, `git`, `node`, etc.) is safer for high-risk environments but requires listing every tool the agent might need.

## Pattern 5: Desktop Notification

Alerts the user when Claude needs input, so they can work on something else while a long pipeline runs.

**Event:** `Notification`

```bash
#!/bin/bash
# .claude/hooks/desktop-notify.sh
set -uo pipefail

message=$(jq -r '.message // "Claude needs your attention"' < /dev/stdin)

# macOS
if command -v osascript &>/dev/null; then
  osascript -e "display notification \"$message\" with title \"Claude Code\""
  exit 0
fi

# Linux (X11/Wayland)
if command -v notify-send &>/dev/null; then
  notify-send "Claude Code" "$message"
  exit 0
fi

# Fallback: terminal bell
printf '\a'
exit 0
```

```json
{
  "hooks": {
    "Notification": [
      {
        "command": ".claude/hooks/desktop-notify.sh"
      }
    ]
  }
}
```

No matcher needed — the `Notification` event fires whenever Claude surfaces a notification.

## Pattern 6: Subagent Lifecycle Logging

Logs when subagents start and stop, capturing type and duration for pipeline performance metrics.

**Event:** `SubagentStart` / `SubagentStop`

```bash
#!/bin/bash
# .claude/hooks/subagent-log.sh
set -uo pipefail

LOG_FILE=".claude/subagent-metrics.log"
event=$(jq -r '.type // "unknown"' < /dev/stdin)
agent=$(jq -r '.agent_type // .tool_name // "unknown"' < /dev/stdin)
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "$timestamp | $event | agent=$agent" >> "$LOG_FILE"
exit 0
```

```json
{
  "hooks": {
    "SubagentStart": [
      {
        "command": ".claude/hooks/subagent-log.sh"
      }
    ],
    "SubagentStop": [
      {
        "command": ".claude/hooks/subagent-log.sh"
      }
    ]
  }
}
```

Parse the log file to measure agent durations, identify bottlenecks, and tune pipeline parallelism. Pair with the pipeline pattern to track end-to-end stage timing.

## Combining Hooks

A real project typically uses several hooks together. They compose in `settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      { "matcher": "Edit|Write", "command": ".claude/hooks/file-guard.sh" },
      { "matcher": "Bash", "command": ".claude/hooks/command-firewall.sh" }
    ],
    "PostToolUse": [
      { "matcher": "Edit|Write", "command": ".claude/hooks/auto-format.sh" },
      { "matcher": "Edit|Write", "command": ".claude/hooks/post-edit-lint.sh" }
    ],
    "Notification": [
      { "command": ".claude/hooks/desktop-notify.sh" }
    ]
  }
}
```

Multiple hooks on the same event run in order. For `PreToolUse`, the first exit-2 wins and blocks the call.

## Principles

- **Hooks are deterministic guardrails, not prompt instructions.** A prompt saying "don't edit .env" can be ignored. A hook with exit code 2 cannot.
- **`PreToolUse` exit code 2 = deny with reason.** The agent sees your message and adjusts. Use this for hard blocks.
- **`PostToolUse` exit 1 = surface output to agent.** The agent sees linter errors, test failures, etc. and can act on them.
- **Keep hooks fast (<2s).** Hooks run synchronously. A slow hook blocks every matching tool call and degrades the agent experience.
- **Use `jq` to parse hook input.** Claude Code pipes JSON to stdin. `jq -r '.tool_input.file_path'` is the standard way to extract fields.
- **Store hooks in `.claude/hooks/`.** Keep them in the repo, version-controlled, alongside the settings that reference them.
