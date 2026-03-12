---
description: "API route conventions for Next.js route handlers"
applyTo: "app/api/**,src/app/api/**"
---

# API Route Rules

- Use Next.js Route Handlers (`route.ts`) in the App Router
- Validate request bodies with Zod schemas — never trust raw input
- Return consistent response shapes: `{ data: T }` for success, `{ error: string }` for failures
- Use appropriate HTTP status codes (200, 201, 400, 401, 404, 500)
- Never expose PII, account numbers, or financial details in error responses
- Log errors server-side but return sanitized messages to clients
- Rate-limit sensitive endpoints (portfolio changes, transactions)
- Use TypeScript return types on all handler functions
