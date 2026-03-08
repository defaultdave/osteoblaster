# Evidence Pattern

How agents provide proof of work in GitHub PRs — both text output and visual screenshots.

## Concept

Pipeline agents should post evidence of their work directly on PRs. This serves three purposes:
1. **Proof of execution** — proves the agent actually ran the server, tests, etc.
2. **Visual validation** — saves the user from pulling every PR locally
3. **Review context** — reviewers can evaluate changes without leaving GitHub

## Text Evidence (default for all agents)

For terminal output (test results, build logs, lint output), use collapsible code blocks. These are searchable, accessible, and need no hosting.

```markdown
<details>
<summary>✅ Test Results — 32 passed, 0 failed</summary>

\```
PASS src/todo.test.ts
  ✓ adds a single todo (3ms)
  ✓ auto-increments IDs (2ms)
  ...

Test Suites: 1 passed, 1 total
Tests:       32 passed, 32 total
\```

</details>
```

Use this for: test output, build logs, lint results, typecheck output, CLI command output.

## Visual Evidence (for UI/frontend changes)

When changes affect anything visual, agents should capture and post screenshots.

### Setup (one-time per repo)

Create a draft release to host screenshot assets:

```bash
gh release create _screenshots --draft --title "Pipeline Screenshots" --notes "Screenshots from agent pipeline runs. Do not delete." --repo <owner>/<repo>
```

### Capture Screenshots

Use Playwright (preferred) or Puppeteer to capture the running application:

```bash
# Install Playwright if not present
npx playwright install chromium

# Start the dev server in background
npm run dev &
DEV_PID=$!
sleep 3  # wait for server

# Capture screenshot
npx playwright screenshot --browser chromium http://localhost:3000 /tmp/screenshot.png

# Stop the dev server
kill $DEV_PID
```

### Upload and Embed

```bash
# Generate unique filename
FILENAME="screenshot-$(date +%s)-${PR_NUMBER}.png"

# Upload to release assets
gh release upload _screenshots /tmp/screenshot.png --repo <owner>/<repo> --clobber

# The URL for embedding:
# https://github.com/<owner>/<repo>/releases/download/_screenshots/screenshot.png
```

In the PR comment:
```markdown
## Visual Evidence

![Homepage after changes](https://github.com/owner/repo/releases/download/_screenshots/screenshot-1234567890-5.png)
```

### Multiple Screenshots

For multi-page or multi-state captures, use descriptive filenames:

```bash
TIMESTAMP=$(date +%s)
# Capture multiple pages/states
npx playwright screenshot http://localhost:3000 /tmp/home-${TIMESTAMP}.png
npx playwright screenshot http://localhost:3000/dashboard /tmp/dashboard-${TIMESTAMP}.png

# Upload all
gh release upload _screenshots /tmp/home-${TIMESTAMP}.png /tmp/dashboard-${TIMESTAMP}.png --repo <owner>/<repo>
```

## Agent Integration

### QA Agent

The QA agent should capture evidence for every PR comment:

```markdown
## QA Report

**Result: PASS**

<details>
<summary>✅ Test Results — 32/32 passed</summary>

\```
[test output here]
\```

</details>

### Visual Verification

![App running on localhost:3000](https://github.com/.../releases/download/_screenshots/qa-1234567890.png)

Server started successfully, all pages render correctly.
```

### Review Agent

The review agent posts text evidence (diff analysis, security findings). Screenshots are typically not needed for review, but can be used to document visual regressions.

## When to Capture Screenshots

- **Always:** When the PR changes UI components, styles, layouts, or frontend logic
- **Always:** When the issue/task involves visual changes (new pages, redesigns, etc.)
- **On request:** When the issue or acceptance criteria mention "visual verification"
- **Never:** For pure backend, CLI, or library changes with no visual component

## Limitations

- GitHub has no public API for image upload to PR comments directly — release assets are the workaround
- Release assets are permanent (no auto-cleanup). For high-volume repos, consider periodic cleanup of old screenshots
- Playwright requires chromium to be installed (`npx playwright install chromium`)
