---
description: "React component conventions"
applyTo: "components/**,src/components/**,app/**/*.tsx,src/app/**/*.tsx"
---

# Component Rules

- Default to Server Components. Only add `"use client"` when the component needs event handlers, hooks, or browser APIs
- Use Tailwind CSS for styling — no inline style objects unless dynamically computed
- Financial data displays must format numbers consistently (locale-aware, proper decimal places for currency)
- Charts and graphs must include text alternatives for accessibility
- Forms must have proper labels, validation messages, and keyboard navigation
- Use semantic HTML elements (`<main>`, `<nav>`, `<section>`, `<article>`)
- Keep components focused — one responsibility per component
