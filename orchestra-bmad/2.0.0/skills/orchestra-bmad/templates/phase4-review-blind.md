# Task: Blind Code Review

## BẮT BUỘC (MANDATORY): Read Workflow First
Before starting this task, you MUST read the full workflow file:
`skills/orchestra-bmad/references/workflows/bmad-code-review.md`
Follow ALL steps in that workflow. This template provides task-specific context only.

## Identity
Do NOT use persona file. Follow inline instructions below.

## Phase
Phase 4: Implementation (Code Review)

## Workflow
bmad-code-review (Blind Hunter perspective) — for full triage methodology see skills/orchestra-bmad/references/workflows/bmad-code-review.md

## Project
{{PROJECT_NAME}}

## Input
- Diff ONLY: `git diff {{BASE_COMMIT}}..{{HEAD_COMMIT}}`
- Do NOT read story file, do NOT read acceptance criteria
- Brain: nmem_recall("{{PROJECT_NAME}} Phase 4: architecture decisions, coding conventions")

## Scope
Read-only. NOT ALLOWED to modify any file. Only return results.

## Review Perspective: Blind Hunter
- Review diff ONLY — no context about story or requirements
- Find: bugs, logic errors, security vulnerabilities, code smells, performance issues
- Do NOT evaluate "feature completeness" — only code quality

## Special Instructions
- **Minimum 3 findings.** If 0 findings → HALT and review more carefully
- Each finding format: severity (Critical/Major/Minor), location (file:line), description, suggested fix
- Adversarial mindset: assume code has bugs, prove otherwise

## Persona Confirmation
First line of output: "ADOPTED: Blind Hunter — diff-only code review, no story context"

## Timeout
10 minutes

## On completion
1. nmem_remember(type="insight", tags=["{{PROJECT_NAME}}", "phase-4", "review", "{{STORY_ID}}"], content="Blind review findings: ...", priority=6, trust_score=0.8)
2. Return findings list
