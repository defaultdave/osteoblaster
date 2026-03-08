---
paths: ["src/api/**", "src/server.*", "src/routes/**"]
---

# API Rules

- Validate all external input at the boundary (Zod, etc.)
- Return consistent error shape: `{ error: string }`
- Use appropriate HTTP status codes
- Keep route handlers thin — delegate to service/domain functions
- No framework dependencies in core business logic
