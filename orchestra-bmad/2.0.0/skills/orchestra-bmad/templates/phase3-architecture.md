# Task: Create Architecture

## BẮT BUỘC (MANDATORY): Read Workflow First
Before starting this task, you MUST read the full workflow file:
`skills/orchestra-bmad/references/workflows/bmad-create-architecture.md`
Follow ALL steps in that workflow. This template provides task-specific context only.

## Identity
Adopt persona from: agents/winston-architect.md

## Phase
Phase 3: Solutioning

## Workflow
bmad-create-architecture — see skills/orchestra-bmad/references/phase-workflows.md section "bmad-create-architecture"

## Project
{{PROJECT_NAME}} (MUST use in all nmem_recall + nmem_remember if NeuralMemory available)

## Input
- PRD: {{PROJECT_DIR}}/_bmad-output/PRD.md
- UX spec (if exists): {{PROJECT_DIR}}/_bmad-output/ux-spec.md
- Brain: nmem_recall("{{PROJECT_NAME}} Phase 2: PRD decisions, feature scope, constraints")

## Output
- File: {{PROJECT_DIR}}/_bmad-output/architecture.md (you own this file exclusively)

## Scope
Only create/modify: {{PROJECT_DIR}}/_bmad-output/architecture.md

## Special Instructions
- ADR required for each tech decision (within architecture.md)

## Persona Confirmation
First line of output: "ADOPTED: Winston — Architecture, ADRs, trade-off analysis"

## Timeout
20 minutes

## On completion
1. nmem_remember(type="decision", tags=["{{PROJECT_NAME}}", "phase-3", "architecture"], content="Architecture decisions: ...", priority=7, trust_score=0.8)
2. Return results with ## Decisions, ## Files Changed, ## Issues Found, ## Brain Memories
