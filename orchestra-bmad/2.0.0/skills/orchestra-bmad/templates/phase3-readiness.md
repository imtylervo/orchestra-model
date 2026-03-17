# Task: Implementation Readiness Check

## BẮT BUỘC (MANDATORY): Read Workflow First
Before starting this task, you MUST read the full workflow file:
`skills/orchestra-bmad/references/workflows/bmad-check-readiness.md`
Follow ALL steps in that workflow. This template provides task-specific context only.

## Identity
Adopt persona from: agents/winston-architect.md

## Phase
Phase 3: Solutioning (Gate)

## Workflow
**BẮT BUỘC (MANDATORY):** Read and follow the COMPLETE workflow at: skills/orchestra-bmad/references/workflows/bmad-check-readiness.md
This workflow contains 6 detailed validation steps with coverage matrix and scoring. DO NOT use the summary in phase-workflows.md.

## Project
{{PROJECT_NAME}} (MUST use in all nmem_recall + nmem_remember if NeuralMemory available)

## Input
- Architecture: {{PROJECT_DIR}}/_bmad-output/architecture.md
- Epics: {{PROJECT_DIR}}/_bmad-output/epics/*.md
- PRD: {{PROJECT_DIR}}/_bmad-output/PRD.md
- Brain: nmem_recall("{{PROJECT_NAME}} Phase 3: architecture, stories, all decisions")

## Output
- Results MUST contain verdict: READY/NEEDS WORK/NOT READY
- If NEEDS WORK/NOT READY: detail issues + recommended fixes

## Scope
Read-only all files. NOT ALLOWED to modify any file. Only return results.

## Special Instructions
- Check: Architecture ↔ Stories aligned?
- Check: Every component in architecture has a corresponding story?
- Check: Acceptance criteria specific enough for TDD?
- Check: Dependencies clear, no circular?
- Verdict MUST be one of: READY, NEEDS WORK, NOT READY

## Persona Confirmation
First line of output: "ADOPTED: Winston — Architecture readiness check"

## Timeout
20 minutes

## On completion
1. nmem_remember(type="decision", tags=["{{PROJECT_NAME}}", "phase-3", "readiness"], content="Readiness: [READY/NEEDS WORK/NOT READY] — ...", priority=8, trust_score=0.9)
2. Return results with verdict + details
