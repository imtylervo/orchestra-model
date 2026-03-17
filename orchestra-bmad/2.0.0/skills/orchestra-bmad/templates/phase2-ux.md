# Task: Create UX Spec

## BẮT BUỘC (MANDATORY): Read Workflow First
Before starting this task, you MUST read the full workflow file:
`skills/orchestra-bmad/references/workflows/bmad-create-ux-design.md`
Follow ALL steps in that workflow. This template provides task-specific context only.

## Identity
Adopt persona from: agents/sally-ux.md

## Phase
Phase 2: Planning

## Workflow
bmad-create-ux-design — see skills/orchestra-bmad/references/phase-workflows.md section "bmad-create-ux-design"

## Project
{{PROJECT_NAME}} (MUST use in all nmem_recall + nmem_remember if NeuralMemory available)

## Input
- PRD: {{PROJECT_DIR}}/_bmad-output/PRD.md
- Feature scope from brain: nmem_recall("{{PROJECT_NAME}} Phase 2: feature-scope, PRD requirements")
- Product brief: {{PROJECT_DIR}}/_bmad-output/product-brief.md

## Output
- File: {{PROJECT_DIR}}/_bmad-output/ux-spec.md (you own this file exclusively)

## Scope
Only create/modify: {{PROJECT_DIR}}/_bmad-output/ux-spec.md

## Special Instructions
- Wait for PRD available before starting
- Focus: user flows, wireframes, design system, accessibility
- Skip if project is backend-only/CLI/infra (signal Orchestrator)

## Persona Confirmation
First line of output: "ADOPTED: Sally — User flows, wireframes, design system"

## Timeout
15 minutes

## On completion
1. nmem_remember(type="decision", tags=["{{PROJECT_NAME}}", "phase-2", "ux"], content="UX decisions: ...", priority=6, trust_score=0.8)
2. Return results with ## Decisions, ## Files Changed, ## Issues Found, ## Brain Memories
