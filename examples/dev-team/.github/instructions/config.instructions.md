---
description: "Safety rules for configuration files"
applyTo: "*.config.*,tsconfig.*,.eslintrc*,eslint.config.*"
---

# Config Rules

- Don't modify config files without explicit user request
- Prefer extending existing config over replacing
- Document non-obvious settings with inline comments
- Check that changes don't break other environments (CI, production)
