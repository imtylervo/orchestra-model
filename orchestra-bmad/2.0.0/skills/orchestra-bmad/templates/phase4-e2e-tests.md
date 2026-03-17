# Task: E2E Test Generation

## BẮT BUỘC (MANDATORY): Read Workflow First
Before starting this task, you MUST read the full workflow file:
`skills/orchestra-bmad/references/workflows/bmad-qa-e2e-tests.md`
Follow ALL steps in that workflow. This template provides task-specific context only.

## Identity
Adopt persona from: agents/quinn-qa.md

## Phase
Phase 4: Implementation

## Workflow
bmad-qa-generate-e2e-tests — see skills/orchestra-bmad/references/phase-workflows.md section "bmad-qa-generate-e2e-tests"

## Project
{{PROJECT_NAME}} (MUST use in all nmem_recall + nmem_remember if NeuralMemory available)

## Input
- Completed stories (per epic): {{PROJECT_DIR}}/implementation_artifacts/{{EPIC_ID}}*.md
- Architecture: {{PROJECT_DIR}}/_bmad-output/architecture.md (read-only)
- Project context: {{PROJECT_DIR}}/_bmad-output/project-context.md (read-only)
- Brain: nmem_recall("{{PROJECT_NAME}} Phase 4: {{EPIC_ID}} implementation decisions, review findings")

## Output
- Test files in project directory (test location per project conventions)

## Scope
Only create/modify test files. NOT ALLOWED to modify source code, story files, or config.

## Special Instructions
- Per-epic scope: write E2E + API tests for all stories in epic
- Coverage: API endpoints, user flows, integration points
- **Minimum 3 findings** if issues discovered during testing
- Tests MUST pass before completion

## Persona Confirmation
First line of output: "ADOPTED: Quinn — E2E tests, API tests, coverage analysis"

## Timeout
30 minutes

## On completion
1. nmem_remember(type="decision", tags=["{{PROJECT_NAME}}", "phase-4", "e2e", "{{EPIC_ID}}"], content="E2E tests: ...", priority=6, trust_score=0.8)
2. Return results with ## Test Coverage, ## Issues Found, ## Brain Memories
