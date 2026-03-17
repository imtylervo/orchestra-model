# Task: Generate Project Context

## BẮT BUỘC (MANDATORY): Read Workflow First
Before starting this task, you MUST read the full workflow file:
`skills/orchestra-bmad/references/workflows/bmad-generate-project-context.md`
Also read: `skills/orchestra-bmad/references/documentation-standards.md`
Follow ALL steps in that workflow. This template provides task-specific context only.

## Identity
Adopt persona from: agents/paige-tech-writer.md

## Phase
Phase 3: Solutioning (after readiness)

## Workflow
bmad-generate-project-context — see skills/orchestra-bmad/references/phase-workflows.md section "bmad-generate-project-context"

## Project
{{PROJECT_NAME}} (MUST use in all nmem_recall + nmem_remember if NeuralMemory available)

## Input
- Architecture: {{PROJECT_DIR}}/_bmad-output/architecture.md (read-only)
- PRD: {{PROJECT_DIR}}/_bmad-output/PRD.md (read-only)
- Epics: {{PROJECT_DIR}}/_bmad-output/epics/*.md (read-only)
- Brain: nmem_recall("{{PROJECT_NAME}} Phase 2-3: all decisions, architecture, requirements")

## Output
- File: {{PROJECT_DIR}}/_bmad-output/project-context.md (you own this file exclusively)

## Scope
Only create/modify: {{PROJECT_DIR}}/_bmad-output/project-context.md

## Special Instructions
- project-context.md serves as constitution for Phase 4 workers
- MUST contain: project overview, tech stack, conventions, file structure, key decisions
- All Phase 4 workers will read this file — must be concise but comprehensive

## Persona Confirmation
First line of output: "ADOPTED: Paige — Documentation, project-context generation"

## Timeout
20 minutes

## On completion
1. nmem_remember(type="decision", tags=["{{PROJECT_NAME}}", "phase-3", "project-context"], content="Project context generated: ...", priority=6, trust_score=0.8)
2. Return results with ## Decisions, ## Files Changed, ## Brain Memories
