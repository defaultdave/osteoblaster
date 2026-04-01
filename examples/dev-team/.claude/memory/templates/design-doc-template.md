# Design Doc Template

Use this template when creating design documents for complex features or new projects. Design docs are created by the architect agent and serve as handoff artifacts to the senior agent.

**Storage:** `memory/projects/{project}/designs/{issue}-{slug}.md`

---

## Template

```markdown
# {Feature Name} Design Document

**Component:** {Component or subsystem name}
**Created:** {YYYY-MM-DD}
**Author:** {agent or person}
**Status:** Draft | In Review | Approved | Implemented
**Target Project:** {project-name}
**Related Issue:** #{issue_number}

---

## Problem Statement

{What problem does this solve? Who has this problem? Why does it matter?}

## Goals

- {Goal 1}
- {Goal 2}

## Non-Goals

- {What this does NOT aim to solve}
- {Explicit boundaries}

## Proposed Solution

### Overview

{High-level description of the approach}

### Component Architecture

{File structure, component hierarchy, data flow}

### Data Model

{Database schema changes, key entity relationships, new types}

Include **type signatures only** — no implementation code:

```
ExampleEntity {
  id: string
  name: string
  status: 'active' | 'archived'
  createdAt: DateTime
  relations: belongs to ParentEntity, has many ChildEntity
}
```

### API Changes

{New routes, modified endpoints, request/response shapes — signatures only}

### UI Design

{For UI features: layout, states, responsive behavior}

### Accessibility

{For UI features — required for all user-facing changes}

- **Keyboard navigation:** {How will users navigate this feature without a mouse?}
- **Screen reader:** {What ARIA labels, live regions, or semantic HTML are needed?}
- **Color contrast:** {Any custom colors that need contrast verification?}
- **Focus management:** {Where does focus go after modal open/close, form submit, navigation?}
- **Required fields:** {Which fields are required? How are they indicated?}
- **Error handling:** {How are errors announced to assistive technology?}
- **Responsive:** {How does this work at mobile breakpoints? Touch target sizes?}

## Alternatives Considered

### {Alternative 1}

{Description, why it was rejected}

### {Alternative 2}

{Description, why it was rejected}

## Implementation Phases

### Phase 1 — {Name}
- {Task 1}
- {Task 2}

### Phase 2 — {Name}
- {Task 1}
- {Task 2}

## Testing Strategy

- **Unit tests:** {What to test, key scenarios}
- **Integration tests:** {API route tests, database interactions}
- **E2e tests:** {User flows to cover with Playwright}
- **Accessibility tests:** {Keyboard navigation paths, screen reader flows, axe-core checks}

## Security Considerations

- {Auth requirements}
- {Input validation}
- {Data sensitivity}

## Performance Considerations

- {Expected load}
- {Optimization strategies}
- {Caching approach}

## Open Questions

1. {Question — include proposed answer if you have one}
2. {Question}

## Handoff Checklist

- [ ] Design reviewed and approved
- [ ] Data model finalized
- [ ] API contracts defined
- [ ] Accessibility section complete (keyboard nav, screen reader, contrast, focus management)
- [ ] UX friction addressed (autoFocus, required indicators, smart defaults, navigation)
- [ ] Testing strategy clear (including a11y test plan)
- [ ] Implementation phases ordered
- [ ] Open questions resolved

---

**Ready for:** `@senior` (Implementation)
**Design Sign-off:** {author}
**Date:** {YYYY-MM-DD}
**Status:** {Ready for implementation | Needs revision}
```

---

## Guidelines

### When to Create a Design Doc

- New feature with 3+ components or files
- Database schema changes
- New API endpoints
- Architectural decisions with trade-offs
- Cross-cutting changes affecting multiple subsystems
- Any work that would benefit from upfront design review

### When NOT to Create a Design Doc

- Bug fixes (just fix it)
- Simple CRUD additions
- Styling changes
- Configuration changes
- Single-file changes with obvious implementation

### Quality Bar

A good design doc:
- States the problem clearly in 2-3 sentences
- Lists explicit non-goals (what you're NOT doing)
- Describes at least one rejected alternative
- Includes key type/interface **signatures** (not implementation code)
- Has a concrete testing strategy
- Identifies open questions honestly
- Can be understood by someone unfamiliar with the codebase
- For UI features: has a complete Accessibility section and addresses UX friction
- **Contains NO implementation code** — only signatures, diagrams, and pseudocode where the algorithm IS the decision (see [Stan Design Docs](https://github.com/stan-dev/design-docs) philosophy)

### Integration with Workflow

1. Architect agent creates the design doc
2. Design doc is stored in `memory/projects/{project}/designs/`
3. Doc becomes a handoff artifact — senior reads it before implementing
4. Implementation can reference the doc for context
5. Doc is updated to "Implemented" when work is complete
