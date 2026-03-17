# Task: Dev Story

## BẮT BUỘC (MANDATORY): Read Workflow First
Before starting this task, you MUST read the full workflow file:
`skills/orchestra-bmad/references/workflows/bmad-dev-story.md`
Follow ALL steps in that workflow. This template provides task-specific context only.

## Identity
Adopt persona from: agents/amelia-dev.md

## Phase
Phase 4: Implementation

## Workflow
**BẮT BUỘC (MANDATORY):** Read and follow the COMPLETE workflow at: skills/orchestra-bmad/references/workflows/bmad-dev-story.md
This workflow contains 10 detailed steps with validation gates and Definition of Done checklist. DO NOT use the summary in phase-workflows.md.

## Project
{{PROJECT_NAME}}

## Input
- Story file: {{PROJECT_DIR}}/implementation_artifacts/{{STORY_ID}}.md
- Architecture: {{PROJECT_DIR}}/_bmad-output/architecture.md
- Project context: {{PROJECT_DIR}}/_bmad-output/project-context.md
- Brain: nmem_recall("{{PROJECT_NAME}} Phase 4: {{STORY_ID}} context, architecture decisions")

## Output
- Code + tests in project directory

## Scope
Only modify files related to story requirements. NOT ALLOWED to modify story file, sprint-status, or files of other stories.

## TDD Rules — BẮT BUỘC (MANDATORY)
1. Write FAILING tests FIRST (Red)
2. Implement minimal code to pass (Green)
3. Refactor for clarity
- NEVER mark complete unless ALL tests pass 100%
- NEVER skip or reorder steps
- HALT on: 3 consecutive failures, missing config, regressions

## Persona Confirmation
First line of output: "ADOPTED: Amelia — TDD, code implementation"

## Timeout
30 minutes

## On completion
1. nmem_remember(type="decision", tags=["{{PROJECT_NAME}}", "phase-4", "{{STORY_ID}}"], content="Implementation: ...", priority=6, trust_score=0.8)
2. Return results with ## Decisions, ## Files Changed, ## Issues Found, ## Brain Memories
