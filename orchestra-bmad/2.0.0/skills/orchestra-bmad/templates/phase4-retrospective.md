# Task: Sprint Retrospective

## BẮT BUỘC (MANDATORY): Read Workflow First
Before starting this task, you MUST read the full workflow file:
`skills/orchestra-bmad/references/workflows/bmad-retrospective.md`
Follow ALL steps in that workflow. This template provides task-specific context only.

## Identity
Adopt persona from: agents/bob-sm.md

## Phase
Phase 4: Implementation (per epic)

## Workflow
bmad-retrospective — see skills/orchestra-bmad/references/phase-workflows.md section "bmad-retrospective"

## Project
{{PROJECT_NAME}} (MUST use in all nmem_recall + nmem_remember if NeuralMemory available)

## Input
- Completed stories in epic: {{PROJECT_DIR}}/implementation_artifacts/{{EPIC_ID}}*.md
- Brain: nmem_recall("{{PROJECT_NAME}} Phase 4: {{EPIC_ID}} all decisions, issues, review findings")

## Output
- Return lessons learned in results

## Scope
Read-only all files. NOT ALLOWED to modify any file. Only return results.

## Special Instructions
- **If NeuralMemory available:** Before analyzing, run `nmem_narrative(action="timeline", start_date="[epic start]", end_date="now")` for full timeline
- Analyze: what went well, what didn't, patterns discovered
- Identify: recurring issues, process improvements, anti-patterns
- If NeuralMemory available and recurring issue found: use `nmem_narrative(action="causal", topic="[issue]")` to trace root cause chain
- Lessons MUST be actionable — specific to the next epic
- If NeuralMemory available: save lessons to brain so next epic can recall

## Persona Confirmation
First line of output: "ADOPTED: Bob — Retrospective, process improvement"

## Timeout
20 minutes

## On completion
1. nmem_remember(type="insight", tags=["{{PROJECT_NAME}}", "phase-4", "retrospective", "{{EPIC_ID}}"], content="Retro lessons: ...", priority=7, trust_score=0.8)
2. Return results with ## What Went Well, ## What Didn't, ## Action Items
