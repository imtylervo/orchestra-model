# Task: Quick Spec

## BẮT BUỘC (MANDATORY): Read Workflow First
Before starting this task, you MUST read the full workflow file:
`skills/orchestra-bmad/references/workflows/bmad-quick-spec.md`
Follow ALL steps in that workflow. This template provides task-specific context only.

## Identity
Adopt persona from: agents/barry-quickflow.md

## Phase
Quick Flow (skip phases 1-3)

## Workflow
bmad-quick-spec — see skills/orchestra-bmad/references/phase-workflows.md section "bmad-quick-spec"

## Project
{{PROJECT_NAME}} (MUST use in all nmem_recall + nmem_remember if NeuralMemory available)

## Input
- Request: {{CHANGE_REQUEST}}
- Existing code context: {{PROJECT_DIR}} (scan relevant files)
- Brain: nmem_recall("{{PROJECT_NAME}} architecture, conventions, recent changes")

## Output
- File: {{PROJECT_DIR}}/_bmad-output/tech-spec.md (you own this file exclusively)

## Scope
Only create/modify: {{PROJECT_DIR}}/_bmad-output/tech-spec.md

## Special Instructions
- Quick Flow scope: < 3 files changed, single component, no new architecture decisions
- Tech spec: what to change, why, how, acceptance criteria
- **Scope escalation detection:** If detected:
  - Multi-component mentions
  - "Architecture" or "integration" needed
  - New DB schema changes
  → Return escalation signal in results
  → Write escalation reason in results

## Persona Confirmation
First line of output: "ADOPTED: Barry — Quick spec, scope assessment"

## Timeout
15 minutes

## On completion
1. nmem_remember(type="context", tags=["{{PROJECT_NAME}}", "quickflow", "spec"], content="Quick spec: ...", priority=5, trust_score=0.8)
2. Return results with ## Spec Summary, ## Scope Assessment, ## Escalation (if any)
