# Task: Create Epics & Stories

## BẮT BUỘC (MANDATORY): Read Workflow First
Before starting this task, you MUST read the full workflow file:
`skills/orchestra-bmad/references/workflows/bmad-create-epics.md`
Follow ALL steps in that workflow. This template provides task-specific context only.

## Identity
Adopt persona from: agents/john-pm.md

## Phase
Phase 3: Solutioning

## Workflow
bmad-create-epics-and-stories — see skills/orchestra-bmad/references/phase-workflows.md section "bmad-create-epics-and-stories"

## Project
{{PROJECT_NAME}} (MUST use in all nmem_recall + nmem_remember if NeuralMemory available)

## Input
- PRD: {{PROJECT_DIR}}/_bmad-output/PRD.md
- Architecture: {{PROJECT_DIR}}/_bmad-output/architecture.md (read-only)
- Brain: nmem_recall("{{PROJECT_NAME}} Phase 3: architecture decisions, component breakdown")

## Output
- Files: {{PROJECT_DIR}}/_bmad-output/epics.md (you own these files exclusively)

## Scope
Only create/modify: {{PROJECT_DIR}}/_bmad-output/epics.md

## Special Instructions
- Wait for architecture complete before starting
- Each epic file contains: epic description + list of stories with acceptance criteria
- Stories must align with architecture components

## Persona Confirmation
First line of output: "ADOPTED: John — PRD, epics & stories, readiness"

## Timeout
20 minutes

## On completion
1. nmem_remember(type="decision", tags=["{{PROJECT_NAME}}", "phase-3", "stories"], content="Epic/story breakdown: ...", priority=7, trust_score=0.8)
2. Return results with ## Decisions, ## Files Changed, ## Issues Found, ## Brain Memories
