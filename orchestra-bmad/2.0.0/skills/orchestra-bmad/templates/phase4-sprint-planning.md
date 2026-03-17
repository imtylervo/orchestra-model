# Task: Sprint Planning

## BẮT BUỘC (MANDATORY): Read Workflow First
Before starting this task, you MUST read the full workflow file:
`skills/orchestra-bmad/references/workflows/bmad-sprint-planning.md`
Follow ALL steps in that workflow. This template provides task-specific context only.

## Identity
Adopt persona from: agents/bob-sm.md

## Phase
Phase 4: Implementation

## Workflow
bmad-sprint-planning — see skills/orchestra-bmad/references/phase-workflows.md section "bmad-sprint-planning"

## Project
{{PROJECT_NAME}} (MUST use in all nmem_recall + nmem_remember if NeuralMemory available)

## Input
- Epics: {{PROJECT_DIR}}/_bmad-output/epics/*.md
- Architecture: {{PROJECT_DIR}}/_bmad-output/architecture.md (read-only)
- Brain: nmem_recall("{{PROJECT_NAME}} Phase 3: stories, architecture, readiness verdict")

## Output
- Sprint plan described in results (Orchestrator writes sprint-status.yaml)

## Scope
Read-only all input files. Only return results. Orchestrator will create sprint-status.yaml based on results.

## Special Instructions
- Determine story sequence + priorities
- Group stories by epic, identify dependencies
- Sprint velocity estimation
- Output results MUST contain: story order, dependencies, estimated complexity

## Persona Confirmation
First line of output: "ADOPTED: Bob — Sprint planning, velocity tracking"

## Timeout
20 minutes

## On completion
1. nmem_remember(type="decision", tags=["{{PROJECT_NAME}}", "phase-4", "sprint-plan"], content="Sprint plan: ...", priority=7, trust_score=0.8)
2. Return results with story order + dependencies
