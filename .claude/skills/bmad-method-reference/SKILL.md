---
name: bmad-method-reference
description: Complete BMAD METHOD v6 reference — workflow phases, agents, implementation cycle, adversarial review, project context. Use when working with any BMAD project or answering questions about BMAD workflows.
---

# BMAD METHOD v6 Reference

Documentation split into 26 topic files in this directory. Key files:

**Tutorials & How-To:**
- `tutorials-getting-started.md` — Full getting started guide
- `how-to-customize-bmad.md` — Agent customization via .customize.yaml
- `how-to-established-projects.md` — Onboarding existing codebases
- `how-to-project-context.md` — Creating project-context.md
- `how-to-quick-fixes.md` — Quick fixes workflow

**Concepts (Explanation):**
- `explanation-adversarial-review.md` — Adversarial review technique
- `explanation-preventing-agent-conflicts.md` — How architecture prevents conflicts
- `explanation-project-context.md` — Deep dive on project-context.md
- `explanation-quick-flow.md` — Quick Flow for small changes
- `explanation-why-solutioning-matters.md` — Why Phase 3 matters

**Reference:**
- `reference-agents.md` — All agents, skill IDs, triggers
- `reference-commands.md` — Skills system and naming
- `reference-core-tools.md` — 11 core tools (help, brainstorming, reviews, etc)
- `reference-workflow-map.md` — Complete workflow map all 4 phases
- `reference-testing.md` — Quinn QA agent + TEA module
- `reference-modules.md` — Available modules (Builder, Creative, Game Dev, TEA)

## Quick Reference — Phase 4 Implementation Cycle

**CRITICAL: Each workflow MUST run in a FRESH CHAT. Never combine workflows.**

### The Build Cycle (for each story)

| Step | Agent | Skill | Purpose |
|------|-------|-------|---------|
| 1 | SM (Bob) | `bmad-create-story` | Create story file with full developer context |
| 2 | DEV (Amelia) | `bmad-dev-story` | Implement using Red-Green-Refactor |
| 3 | DEV (Amelia) | `bmad-code-review` | Adversarial 3-layer quality review |
| 4 | SM (Bob) | `bmad-retrospective` | After all stories in epic complete |

### Story Status State Machine

```
backlog → ready-for-dev → in-progress → review → done
```

### bmad-create-story Output

Creates `/implementation_artifacts/{story_key}.md` with:
- Story requirements + acceptance criteria
- Developer Context (tech requirements, architecture compliance, file structure)
- Previous story intelligence (learnings, patterns, anti-patterns)
- Git intelligence (recent patterns and conventions)

### bmad-dev-story Rules

- **Red-Green-Refactor**: Write FAILING tests first → implement minimal code → refactor
- **NEVER** mark task complete unless tests ACTUALLY exist and pass 100%
- **NEVER** skip steps or reorder tasks
- **HALT** on: 3 consecutive failures, missing config, regressions, ambiguous requirements
- Updates sprint-status.yaml: `in-progress` → `review` when complete

### bmad-code-review — 3 Parallel Reviewers

1. **Blind Hunter** — receives diff ONLY (no context), finds logic/security/performance issues
2. **Edge Case Hunter** — walks every branching path, reports only unhandled cases
3. **Acceptance Auditor** — checks diff against story/spec acceptance criteria

Findings classified as: `intent_gap`, `bad_spec`, `patch`, `defer`, `reject`

**Rule: Zero findings = HALT and re-analyze. "Looks good" is NOT allowed.**

### Key Agents

| Agent | Skill ID | Role |
|-------|----------|------|
| Analyst (Mary) | `bmad-analyst` | Brainstorm, Research, Create Brief |
| PM (John) | `bmad-pm` | PRD, Epics & Stories, Implementation Readiness |
| Architect (Winston) | `bmad-architect` | Architecture, Implementation Readiness |
| SM (Bob) | `bmad-sm` | Sprint Planning, Create Story, Retrospective |
| Developer (Amelia) | `bmad-dev` | Dev Story, Code Review |
| UX Designer (Sally) | `bmad-ux-designer` | UX Design |
| QA (Quinn) | `bmad-qa` | Test generation (after epic complete) |

### All 4 Phases

| Phase | Name | Purpose |
|-------|------|---------|
| 1 | Analysis (optional) | Brainstorming, research, product brief |
| 2 | Planning | PRD, UX Design |
| 3 | Solutioning | Architecture, Epics & Stories, Readiness Check |
| 4 | Implementation | Sprint → Story → Dev → Review → Retro |

### Core Tools (always available)

- `bmad-help` — Context-aware guidance, knows what to do next
- `bmad-brainstorming` — Guided ideation sessions
- `bmad-party-mode` — Multi-agent group discussions
- `bmad-distillator` — Lossless document compression
- `bmad-advanced-elicitation` — Iterative refinement methods
- `bmad-review-adversarial-general` — Cynical review (must find 10+ issues)
- `bmad-review-edge-case-hunter` — Exhaustive branching-path analysis
- `bmad-correct-course` — Handle mid-sprint scope changes

### Anti-Patterns to NEVER Do

- ❌ Gộp nhiều stories thành 1 agent call
- ❌ Skip bmad-create-story (thiếu context → developer mistakes)
- ❌ Skip bmad-code-review (thiếu quality gate → bugs ship)
- ❌ Skip tests trong dev-story (Red phase là bắt buộc)
- ❌ Chạy nhiều workflows trong cùng 1 chat session
- ❌ Tự approve "looks good" trong code review (adversarial = MUST find issues)
- ❌ Skip retrospective sau mỗi epic

### project-context.md

- Location: `_bmad-output/project-context.md`
- Acts as "constitution" for AI agents
- Auto-loaded by: create-architecture, create-story, dev-story, code-review, quick-dev
- Contains: Technology Stack & Versions + Critical Implementation Rules
- Create with `bmad-generate-project-context` or manually
