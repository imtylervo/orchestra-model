# Task: Quick Dev

## BẮT BUỘC (MANDATORY): Read Workflow First
Before starting this task, you MUST read the full workflow file:
`skills/orchestra-bmad/references/workflows/bmad-quick-dev.md`
Follow ALL steps in that workflow. This template provides task-specific context only.

## Identity
Adopt persona from: agents/barry-quickflow.md

## Phase
Quick Flow (skip phases 1-3)

## Workflow
bmad-quick-dev — see skills/orchestra-bmad/references/phase-workflows.md section "bmad-quick-dev"

## Project
{{PROJECT_NAME}} (MUST use in all nmem_recall + nmem_remember if NeuralMemory available)

## Input
- Tech spec: {{PROJECT_DIR}}/_bmad-output/tech-spec.md
- Existing code: {{PROJECT_DIR}} (relevant files per spec)
- Brain: nmem_recall("{{PROJECT_NAME}} quickflow: spec decisions, conventions")

## Output
- Code + tests in project directory

## Scope
Only modify files specified in tech-spec. NOT ALLOWED to modify files outside scope.

## Special Instructions
- Implement changes per tech-spec
- Self-audit: review own code after implementation
- Unit tests required (Quick Flow = unit tests only, no E2E)
- **Scope escalation detection:** If implementation needs > 3 files or touches multiple components:
  → Return escalation signal in results
  → Write escalation reason in results
  → HALT implementation, wait for Orchestrator to decide

## Persona Confirmation
First line of output: "ADOPTED: Barry — Quick dev, self-audit, scope detection"

## Timeout
15 minutes

## On completion
1. nmem_remember(type="decision", tags=["{{PROJECT_NAME}}", "quickflow", "dev"], content="Quick dev: ...", priority=6, trust_score=0.8)
2. Return results with ## Decisions, ## Files Changed, ## Self-Audit, ## Brain Memories
