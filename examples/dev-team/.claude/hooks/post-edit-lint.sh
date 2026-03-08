#!/bin/bash
# Run ESLint on a file immediately after it is written or edited.
#
# This hook fires on every PostToolUse event for Write and Edit tools.
# It surfaces lint errors to the agent while context is still fresh
# ("shift-left" quality enforcement).
#
# Behaviour:
#   - Reads the hook input JSON from stdin
#   - Extracts the affected file path
#   - Skips non-JS/TS files silently
#   - Skips if no ESLint config is found in the project tree
#   - Runs ESLint on the single file only (fast, <2 s)
#   - Prints errors to stdout so they are injected into the agent context
#
# Exit codes:
#   0 - No lint errors (or file skipped)
#   1 - Lint errors found (Claude Code surfaces output to agent)

set -euo pipefail

# ---------------------------------------------------------------------------
# 1. Read hook input
# ---------------------------------------------------------------------------
INPUT=$(cat)

# Extract the file path from the hook payload.
# PostToolUse for Write supplies tool_input.file_path.
# PostToolUse for Edit (Edit/MultiEdit) supplies tool_input.path.
FILE_PATH=$(echo "$INPUT" | jq -r '
  .tool_input.file_path //
  .tool_input.path //
  ""
')

if [ -z "$FILE_PATH" ]; then
  # Cannot determine file — nothing to lint
  exit 0
fi

# Resolve to absolute path when relative
if [[ "$FILE_PATH" != /* ]]; then
  CWD=$(echo "$INPUT" | jq -r '.cwd // "."')
  FILE_PATH="${CWD%/}/$FILE_PATH"
fi

# ---------------------------------------------------------------------------
# 2. Skip non-JS/TS files
# ---------------------------------------------------------------------------
case "$FILE_PATH" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs)
    : # fall through to lint
    ;;
  *)
    exit 0
    ;;
esac

# ---------------------------------------------------------------------------
# 3. Locate the project root (directory containing an ESLint config)
# ---------------------------------------------------------------------------
find_eslint_config() {
  local dir="$1"
  local prev=""
  while [ "$dir" != "$prev" ]; do
    for cfg in \
      "$dir/.eslintrc.js" \
      "$dir/.eslintrc.cjs" \
      "$dir/.eslintrc.yaml" \
      "$dir/.eslintrc.yml" \
      "$dir/.eslintrc.json" \
      "$dir/.eslintrc" \
      "$dir/eslint.config.js" \
      "$dir/eslint.config.mjs" \
      "$dir/eslint.config.cjs"
    do
      if [ -f "$cfg" ]; then
        echo "$dir"
        return 0
      fi
    done
    # Also accept eslintConfig key in package.json
    if [ -f "$dir/package.json" ] && \
       command -v jq &>/dev/null && \
       jq -e '.eslintConfig' "$dir/package.json" &>/dev/null 2>&1; then
      echo "$dir"
      return 0
    fi
    prev="$dir"
    dir="$(dirname "$dir")"
  done
  return 1
}

PROJECT_ROOT=$(find_eslint_config "$(dirname "$FILE_PATH")") || {
  # No ESLint config found in any ancestor directory — skip silently
  exit 0
}

# ---------------------------------------------------------------------------
# 4. Locate the eslint binary
# ---------------------------------------------------------------------------
ESLINT_BIN=""
# Prefer local installation inside the project
for candidate in \
  "$PROJECT_ROOT/node_modules/.bin/eslint" \
  "$PROJECT_ROOT/node_modules/eslint/bin/eslint.js"
do
  if [ -x "$candidate" ]; then
    ESLINT_BIN="$candidate"
    break
  fi
done

# Fall back to PATH
if [ -z "$ESLINT_BIN" ] && command -v eslint &>/dev/null; then
  ESLINT_BIN="eslint"
fi

if [ -z "$ESLINT_BIN" ]; then
  # ESLint not installed — skip silently
  exit 0
fi

# ---------------------------------------------------------------------------
# 5. Run ESLint on the single changed file
# ---------------------------------------------------------------------------
# Use --no-eslintrc / --no-ignore only when needed; rely on project config.
# max-warnings=0 means any warning also triggers a non-zero exit.
LINT_OUTPUT=$("$ESLINT_BIN" \
  --format stylish \
  --no-error-on-unmatched-pattern \
  "$FILE_PATH" 2>&1) || LINT_EXIT=$?

LINT_EXIT=${LINT_EXIT:-0}

if [ "$LINT_EXIT" -eq 0 ]; then
  # Clean — no output needed
  exit 0
fi

# ---------------------------------------------------------------------------
# 6. Surface errors to the agent
# ---------------------------------------------------------------------------
echo ""
echo "ESLint errors in ${FILE_PATH}:"
echo ""
echo "$LINT_OUTPUT"
echo ""
echo "Please fix the lint errors above before continuing."

exit 1
