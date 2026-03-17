# BMAD Workflow Map

Overview of the 4-phase Orchestra-BMAD workflow.

## Phase 1: Analysis
**Agent:** Mary (Orchestrator acts directly)
**Goal:** Discover what to build through interactive brainstorm
**Output:** `_bmad-output/product-brief.md`
**Workflows:**
- bmad-create-product-brief: 2-stage discovery → brief document
- bmad-brainstorming: SCAMPER, reverse brainstorming, 100+ ideas, anti-bias protocol

## Phase 2: Planning
**Agents:** John (PRD), Sally (UX — optional)
**Goal:** Detailed requirements + UX design
**Output:** `_bmad-output/PRD.md`, `_bmad-output/ux-spec.md`
**Workflows:**
- bmad-create-prd: Requirements from brief → PRD with features, user stories, constraints
- bmad-create-ux-design: User flows, wireframes, design system from PRD
**Gate:** PRD must cover ALL brief requirements

## Phase 3: Solutioning
**Agents:** Winston (arch), John (stories), Winston (readiness), Paige (context)
**Goal:** Architecture + epics/stories + readiness validation
**Output:** `_bmad-output/architecture.md`, `_bmad-output/epics/*.md`, `_bmad-output/project-context.md`
**Workflows:**
- bmad-create-architecture: ADRs, component breakdown, tech selection
- bmad-create-epics-and-stories: Epics with stories aligned to architecture
- bmad-check-implementation-readiness: Validate PRD ↔ Architecture ↔ Stories alignment
- bmad-generate-project-context: Constitution document for Phase 4 workers
**Gate:** Readiness check must PASS

## Phase 4: Implementation
**Agents:** Bob (planning/stories), Amelia (dev), Reviewers (3x), Quinn (E2E)
**Goal:** Sprint execution with TDD, code review, E2E tests
**Output:** Working code + tests
**Workflows:**
- bmad-sprint-planning: Story sequencing, velocity estimation
- bmad-create-story: Full story context for developers
- bmad-dev-story: TDD Red-Green-Refactor cycle
- bmad-code-review: 3 parallel reviewers (Blind, Edge Case, Acceptance)
- bmad-qa-generate-e2e-tests: API + E2E test generation per epic
- bmad-retrospective: Lessons learned per epic
- bmad-correct-course: Impact analysis for mid-sprint changes
**Gate:** Min 3 findings per review, all tests must pass

## Quick Flow (bypass Phases 1-3)
**Agent:** Barry (solo)
**Goal:** Small changes — spec + implement in one pass
**Output:** `_bmad-output/tech-spec.md` + code changes
**Workflows:**
- bmad-quick-spec: Tech spec from request + code context
- bmad-quick-dev: Implement spec with self-audit
**Scope:** < 3 files, single component. Escalate if bigger.

## State Machine

```
Epic:  backlog → in-progress → done
Story: backlog → ready-for-dev → in-progress → review → done
```

## Artifact Relationships

```
product-brief → PRD → architecture
                PRD → ux-spec
                PRD → epics/stories
architecture → epics/stories
epics/stories → project-context
project-context → implementation (constitution)
```
