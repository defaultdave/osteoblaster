---
paths: ["**/*.test.ts", "**/*.spec.ts", "tests/**"]
---

# Testing Rules

- Use arrange-act-assert structure
- Test names should describe expected behavior, not implementation
- Prefer real implementations over mocks when practical
- Each test should be independent — no shared mutable state
- Test the public API, not internal details
- When a test fails, the failure message should explain what went wrong
