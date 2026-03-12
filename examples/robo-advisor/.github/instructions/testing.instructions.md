---
description: "Testing conventions for test files"
applyTo: "**/*.test.ts,**/*.test.tsx,**/*.spec.ts,**/*.spec.tsx,__tests__/**"
---

# Testing Rules

- Use arrange-act-assert structure
- Test names should describe expected behavior, not implementation
- Prefer real implementations over mocks when practical
- Each test should be independent — no shared mutable state
- Test the public API, not internal details
- Financial calculations must have deterministic tests with known inputs and expected outputs
- Use `toBeCloseTo` for floating-point comparisons, but prefer fixed-precision arithmetic in production code
- React components: use React Testing Library, query by role/label, not implementation details
- API routes: test with supertest or similar, verify response shape and status codes
