# Task: Create Story Context

## BẮT BUỘC (MANDATORY): Read Workflow First
Before starting this task, you MUST read the full workflow file:
`skills/orchestra-bmad/references/workflows/bmad-create-story.md`
Follow ALL steps in that workflow. This template provides task-specific context only.

## Identity
Adopt persona from: agents/bob-sm.md

## Phase
Phase 4: Implementation

## Workflow
**BẮT BUỘC (MANDATORY):** Read and follow the COMPLETE workflow at: skills/orchestra-bmad/references/workflows/bmad-create-story.md
This workflow contains 6 exhaustive steps for artifact analysis and story creation. DO NOT use the summary in phase-workflows.md.

## Project
{{PROJECT_NAME}} (MUST use in all nmem_recall + nmem_remember if NeuralMemory available)

## Input
- Epic file: {{PROJECT_DIR}}/_bmad-output/epics/{{EPIC_ID}}.md
- Story ID: {{STORY_ID}}
- Architecture: {{PROJECT_DIR}}/_bmad-output/architecture.md (read-only)
- Brain: nmem_recall("{{PROJECT_NAME}} Phase 4: sprint plan, {{EPIC_ID}} context")

## Output
- File: {{PROJECT_DIR}}/implementation_artifacts/{{STORY_ID}}.md (you own this file exclusively)

## Scope
Only create/modify: {{PROJECT_DIR}}/implementation_artifacts/{{STORY_ID}}.md

## Special Instructions
- Story file MUST contain: requirements, acceptance criteria, technical notes
- Acceptance criteria must be specific enough for TDD (Red phase)
- Reference architecture decisions relevant to story

## Persona Confirmation
First line of output: "ADOPTED: Bob — Story creation, acceptance criteria"

## Timeout
20 minutes

## On completion
1. nmem_remember(type="context", tags=["{{PROJECT_NAME}}", "phase-4", "{{STORY_ID}}"], content="Story created: ...", priority=5, trust_score=0.8)
2. Return results with ## Decisions, ## Files Changed, ## Brain Memories
