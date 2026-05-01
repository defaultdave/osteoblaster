---
name: design
description: Create design documents for features or projects
---

# Design Doc Skill

Create and manage design documents (RFCs) for complex features or new projects. Design docs are created before implementation to align on approach, identify risks, and serve as handoff artifacts.

## Usage

```
/design                    # Create a new design doc (interactive)
/design {issue}            # Create design doc from a GitHub issue
/design list               # List all design docs for current project
/design review {doc}       # Review an existing design doc
```

## Process

### `/design` or `/design {issue}`

1. **Determine project context:**
   - Detect project from current working directory or git remote
   - Load project memory from `memory/projects/{project}/`
   - If no project memory exists, initialize a new project directory under `memory/projects/{project}/` (including a `designs/` subdirectory) before proceeding

2. **Gather design inputs:**
   - If `{issue}` provided: fetch issue from GitHub, extract requirements
   - If no issue: ask user for feature name, problem statement, and scope

3. **Create the design doc:**
   - Use the template from `memory/templates/design-doc-template.md`
   - Fill in project context, component architecture, data model
   - Include alternatives considered
   - Define implementation phases
   - Write testing strategy and security considerations

4. **Store the doc:**
   - Save to `memory/projects/{project}/designs/{issue}-{slug}.md`
   - If no issue number, use date-based prefix: `{YYYY-MM-DD}-{slug}.md`

5. **Present for review:**
   - Show summary to user
   - Highlight open questions
   - Ask for approval or revision

### `/design list`

1. Detect current project
2. List all files in `memory/projects/{project}/designs/`
3. Show each doc's title, status, date, and related issue

### `/design review {doc}`

1. Read the specified design doc
2. Evaluate against the quality bar:
   - Problem clearly stated?
   - Non-goals defined?
   - Alternatives considered?
   - TypeScript interfaces for key types?
   - Testing strategy concrete?
   - Accessibility section complete? (for UI features)
   - UX friction points addressed? (forms, navigation, keyboard)
   - Open questions identified?
3. Provide feedback and suggestions

## Template

The design doc template lives at `memory/templates/design-doc-template.md`. Key sections:

- **Problem Statement** — What problem, who has it, why it matters
- **Goals / Non-Goals** — Explicit boundaries
- **Proposed Solution** — Architecture, data model, API changes, UI design
- **Alternatives Considered** — At least one rejected approach with rationale
- **Implementation Phases** — Ordered tasks
- **Testing Strategy** — Unit, integration, e2e, accessibility
- **Security Considerations** — Auth, validation, data sensitivity
- **Open Questions** — Honest unknowns
- **Handoff Checklist** — Readiness criteria for implementation

## Integration with Workflow

- **Architect agent** creates design docs as part of the `feature` pipeline
- Design docs become **handoff artifacts** to the senior agent
- Senior reads the design doc before starting implementation
- Doc status updated to "Implemented" when work is complete
- `/team {issue}` can trigger design doc creation when architect is in the composition

## Quality Bar

A good design doc:
- States the problem in 2-3 sentences
- Lists explicit non-goals
- Describes at least one rejected alternative
- Includes key type/interface signatures (NOT implementation code)
- Has concrete testing strategy (not "we'll add tests")
- Identifies open questions honestly
- Can be understood by someone unfamiliar with the codebase
- **For UI features:** includes a complete Accessibility section covering:
  - Keyboard navigation plan
  - Screen reader considerations (ARIA labels, live regions)
  - Color contrast requirements
  - Focus management (after modals, form submits, navigation)
  - Required field indication strategy
  - Error announcement to assistive technology
- **For UI features:** addresses UX friction:
  - Form field count and auto-fill opportunities
  - Smart defaults (dates, selectors, pre-populated fields)
  - Navigation hierarchy (breadcrumbs, back links, sidebar state)

## Code in Design Docs — The Rule

**Design docs should NOT contain implementation code.**

Reference: [Stan Design Docs](https://github.com/stan-dev/design-docs) — "The technical specification needs to be specific enough that it can be approved as a plan for implementation. These documents should not include every last detail of an implementation — for example, rarely will code other than function or class signatures be appropriate in either a functional or technical specification."

**What belongs in a design doc:**
- Function/class/interface **signatures** (inputs, outputs, types)
- File structure diagrams
- Component interaction diagrams (UML, ASCII, or Mermaid)
- Data flow descriptions (text + diagrams)
- Decision tables and trade-off matrices
- Pseudocode ONLY when the algorithm itself is the design decision

**What does NOT belong:**
- Full function bodies or component implementations
- Configuration objects or config file contents
- Import statements
- Hook usage patterns or state management wiring
- CSS/Tailwind class strings
- API client implementations
- Complete middleware or route handler code

The implementer should be able to read the design doc and know WHAT to build and WHY, then make their own implementation decisions for HOW. If the design doc contains copy-pasteable code, it's doing the implementer's job and will become stale immediately.
