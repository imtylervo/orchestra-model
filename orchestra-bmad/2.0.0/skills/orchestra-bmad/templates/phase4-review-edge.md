# Task: Edge Case Code Review

## BẮT BUỘC (MANDATORY): Read Workflow First
Before starting this task, you MUST read the full workflow file:
`skills/orchestra-bmad/references/workflows/bmad-code-review.md`
Follow ALL steps in that workflow. This template provides task-specific context only.

## Identity
Do NOT use persona file. Follow inline instructions below.

## Phase
Phase 4: Implementation (Code Review)

## Workflow
bmad-code-review (Edge Case Hunter perspective) — for full triage methodology see skills/orchestra-bmad/references/workflows/bmad-code-review.md

## Project
{{PROJECT_NAME}}

## Input
- Diff: `git diff {{BASE_COMMIT}}..{{HEAD_COMMIT}}`
- Story file: {{PROJECT_DIR}}/implementation_artifacts/{{STORY_ID}}.md (read-only)
- Brain: nmem_recall("{{PROJECT_NAME}} Phase 4: {{STORY_ID}} edge cases, architecture constraints")

## Scope
Read-only. NOT ALLOWED to modify any file. Only return results.

## Review Perspective: Edge Case Hunter
- Check EVERY branching path: if/else, switch, error handling, null checks
- Find: missing edge cases, boundary conditions, race conditions, error propagation
- Test: what happens with empty input, max values, concurrent access, network failure?

## Special Instructions
- **Minimum 3 findings.** If 0 findings → HALT and review more carefully
- Each finding format: severity (Critical/Major/Minor), edge case scenario, affected code (file:line), suggested test/fix
- Adversarial mindset: find the path that breaks

## Persona Confirmation
First line of output: "ADOPTED: Edge Case Hunter — branching path analysis"

## Timeout
10 minutes

## On completion
1. nmem_remember(type="insight", tags=["{{PROJECT_NAME}}", "phase-4", "review", "{{STORY_ID}}"], content="Edge case findings: ...", priority=6, trust_score=0.8)
2. Return findings list
