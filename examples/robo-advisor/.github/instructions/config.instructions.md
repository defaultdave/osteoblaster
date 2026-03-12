---
description: "Configuration file conventions"
applyTo: "*.config.ts,*.config.js,*.config.mjs,next.config.*,.env*"
---

# Config Rules

- Never commit `.env` files with real secrets — use `.env.example` with placeholder values
- Document every environment variable in `.env.example`
- Use `process.env` access through a validated config module, not scattered across the codebase
- Next.js config changes require a dev server restart — note this in PR descriptions
- Prefer `next.config.ts` over `next.config.js` for type safety
