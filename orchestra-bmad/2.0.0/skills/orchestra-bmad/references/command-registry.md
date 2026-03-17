# Command Registry — All BMAD Workflows

Complete registry of all available BMAD workflows, organized by phase.

## Anytime Commands

| Code | Command | Agent | Description | Output |
|------|---------|-------|-------------|--------|
| DP | Document Project | analyst | Analyze an existing project to produce useful documentation | project-knowledge |
| GPC | Generate Project Context | analyst | Scan existing codebase to generate lean LLM-optimized project-context.md containing critical implementation rules, patterns, and conventions | output_folder |
| QS | Quick Spec | quick-flow-solo-dev | Quick one-off tasks, small changes, simple apps — do not use for very complex things unless requested | planning_artifacts |
| QD | Quick Dev | quick-flow-solo-dev | Quick implementation without extensive planning — for small changes, simple apps, utilities | — |
| QQ | Quick Dev New Preview | quick-flow-solo-dev | Unified quick flow (experimental): clarify intent, plan, implement, review, present in single workflow | implementation_artifacts |
| CC | Correct Course | sm | Navigate significant changes — may recommend starting over, updating PRD, redoing architecture, or correcting epics/stories | planning_artifacts |
| WD | Write Document | tech-writer | Describe what you want, agent follows documentation standards. Multi-turn conversation with research/review | project-knowledge |
| US | Update Standards | tech-writer | Update documentation-standards.md with specific preferences | standards |
| MG | Mermaid Generate | tech-writer | Create a Mermaid diagram based on description. Suggests diagram types if not specified | planning_artifacts |
| VD | Validate Document | tech-writer | Review document against documentation standards and best practices. Returns actionable improvement suggestions by priority | planning_artifacts |
| EC | Explain Concept | tech-writer | Create clear technical explanations with examples and diagrams for complex concepts | project_knowledge |

## Phase 1 — Analysis

| Code | Command | Agent | Description | Output |
|------|---------|-------|-------------|--------|
| BP | Brainstorm Project | analyst | Expert guided facilitation through single or multiple techniques | planning_artifacts |
| MR | Market Research | analyst | Market analysis, competitive landscape, customer needs and trends | planning_artifacts, project-knowledge |
| DR | Domain Research | analyst | Industry domain deep dive, subject matter expertise and terminology | planning_artifacts, project_knowledge |
| TR | Technical Research | analyst | Technical feasibility, architecture options and implementation approaches | planning_artifacts, project_knowledge |
| CB | Create Brief | analyst | Guided experience to nail down your product idea into an executive brief | planning_artifacts |

## Phase 2 — Planning

| Code | Command | Agent | Description | Output |
|------|---------|-------|-------------|--------|
| CP | Create PRD | pm | Expert-led facilitation to produce Product Requirements Document | planning_artifacts |
| VP | Validate PRD | pm | Validate PRD is comprehensive, lean, well organized and cohesive | planning_artifacts |
| EP | Edit PRD | pm | Improve and enhance an existing PRD | planning_artifacts |
| CU | Create UX | ux-designer | Guidance through realizing the UX plan — strongly recommended if UI is primary | planning_artifacts |

## Phase 3 — Solutioning

| Code | Command | Agent | Description | Output |
|------|---------|-------|-------------|--------|
| CA | Create Architecture | architect | Guided workflow to document technical decisions | planning_artifacts |
| CE | Create Epics and Stories | pm | Create the epics and stories listing that drives development | planning_artifacts |
| IR | Check Implementation Readiness | architect | Ensure PRD, UX, Architecture and Epics/Stories are all aligned | planning_artifacts |

## Phase 4 — Implementation

| Code | Command | Agent | Description | Output |
|------|---------|-------|-------------|--------|
| SP | Sprint Planning | sm | Generate sprint plan — kicks off implementation by producing sequenced plan for dev agent | implementation_artifacts |
| SS | Sprint Status | sm | Summarize sprint status and route to next workflow | — |
| CS | Create Story | sm | Prepare next story in sprint plan with full context for implementation | implementation_artifacts |
| VS | Validate Story | sm | Validate story readiness and completeness before development begins | implementation_artifacts |
| DS | Dev Story | dev | Execute story implementation tasks and tests | — |
| CR | Code Review | dev | Comprehensive code review across multiple quality facets | — |
| QA | QA Automation Test | qa | Generate automated API and E2E tests for implemented code using project test framework | implementation_artifacts |
| ER | Retrospective | sm | Optional at epic end: review completed work, lessons learned, next epic planning | implementation_artifacts |

## Implementation Cycle

The standard story cycle in Phase 4:

```
SP -> CS -> VS -> DS -> CR -> (back to DS if fixes needed, or next CS, or ER if epic complete)
```

## Required vs Optional

**Required workflows** (must complete for full BMAD process):
- CP (Create PRD), CA (Create Architecture), CE (Create Epics and Stories), IR (Implementation Readiness)
- SP (Sprint Planning), CS (Create Story), DS (Dev Story)

**Optional workflows** enhance quality but are not mandatory:
- All research (MR, DR, TR), validation (VP, VS, VD), QA, ER
