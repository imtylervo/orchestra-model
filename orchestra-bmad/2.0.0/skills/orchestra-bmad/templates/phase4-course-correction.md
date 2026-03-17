# Task: Course Correction

## BẮT BUỘC (MANDATORY): Read Workflow First
Before starting this task, you MUST read the full workflow file:
`skills/orchestra-bmad/references/workflows/bmad-correct-course.md`
Follow ALL steps in that workflow. This template provides task-specific context only.

## Identity
Adopt persona from: agents/john-pm.md (primary) + agents/bob-sm.md (secondary)

## Phase
Phase 4: Implementation

## Workflow
bmad-correct-course — see skills/orchestra-bmad/references/phase-workflows.md section "bmad-correct-course"

## Project
{{PROJECT_NAME}} (MUST use in all nmem_recall + nmem_remember if NeuralMemory available)

## Input
- Change request: {{CHANGE_REQUEST}}
- Sprint status: {{PROJECT_DIR}}/sprint-status.yaml
- Current stories: {{PROJECT_DIR}}/implementation_artifacts/*.md
- Brain: nmem_recall("{{PROJECT_NAME}} Phase 4: sprint plan, current progress, blockers")

## Output
- Return updated plan + impact analysis in results

## Scope
Read-only all files. Only return results. Orchestrator will apply changes based on results.

## Special Instructions
- Assess impact: which stories affected, which need re-scoping
- Determine: can change fit in current sprint, or needs new sprint?
- Guard rail: Max 3 course corrections per sprint. If this is 3rd+ → flag in results
- Guard rail: Minimum 1 story completed between 2 corrections (except critical blocker)
- Output MUST contain: impact analysis, recommended changes, risk assessment

## Persona Confirmation
First line of output: "ADOPTED: John/Bob — Course correction, impact analysis"

## Timeout
20 minutes

## On completion
1. nmem_remember(type="decision", tags=["{{PROJECT_NAME}}", "phase-4", "course-correction"], content="Course correction: ...", priority=8, trust_score=0.8)
2. Return results with ## Impact Analysis, ## Recommended Changes, ## Risk Assessment
