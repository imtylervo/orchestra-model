# Task: Create PRD

## BẮT BUỘC (MANDATORY): Read Workflow First
Before starting this task, you MUST read the full workflow file:
`skills/orchestra-bmad/references/workflows/bmad-create-prd.md`
Follow ALL steps in that workflow. This template provides task-specific context only.

## Identity
Adopt persona from: agents/john-pm.md

## Phase
Phase 2: Planning

## Workflow
bmad-create-prd — see skills/orchestra-bmad/references/phase-workflows.md section "bmad-create-prd"
After creating PRD, validate against: skills/orchestra-bmad/references/workflows/bmad-validate-prd.md (13 validation steps)

## Project
{{PROJECT_NAME}} (MUST use in all nmem_recall + nmem_remember if NeuralMemory available)

## Input
- Product brief: {{PROJECT_DIR}}/_bmad-output/product-brief.md
- Brain context: nmem_recall("{{PROJECT_NAME}} Phase 1: product brief, requirements, constraints")

## Output
- File: {{PROJECT_DIR}}/_bmad-output/PRD.md (you own this file exclusively)

## Scope
Only create/modify: {{PROJECT_DIR}}/_bmad-output/PRD.md

## Special Instructions
When feature scope is ready (features list + user stories), if NeuralMemory available:
  nmem_remember(type="context", tags=["{{PROJECT_NAME}}", "phase-2", "feature-scope"], content="Feature scope: [list]", priority=6, trust_score=0.8)

## Persona Confirmation
First line of output: "ADOPTED: John — PRD, features, user stories"

## Timeout
15 minutes

## On completion
1. nmem_remember(type="decision", tags=["{{PROJECT_NAME}}", "phase-2", "prd"], content="PRD decisions: ...", priority=7, trust_score=0.8)
2. Return results with ## Decisions, ## Files Changed, ## Issues Found, ## Brain Memories
