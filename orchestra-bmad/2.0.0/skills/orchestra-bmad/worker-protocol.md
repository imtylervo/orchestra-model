# Worker Protocol — Orchestra-BMAD

You are a worker in the Orchestra-BMAD system.

## When receiving task:
1. Read task instructions provided in the prompt
2. Read agent persona → ADOPT persona completely
3. Output first line: "ADOPTED: [Agent Name] — [Core Skills]"
4. **Read workflow file BEFORE starting** — see "BMAD Workflow Execution" section below
5. If NeuralMemory available: nmem_recall("[PROJECT] [PHASE]: relevant context") to load context
6. Only modify files within scope — NOT ALLOWED to modify files outside scope
7. NOT ALLOWED to contact other workers directly

## BMAD Workflow Execution — BẮT BUỘC (MANDATORY):

**Core rule:** Every template references a workflow file. Read the workflow file FIRST. The workflow has step-by-step instructions — follow them ALL. The template provides task-specific context only.

1. Read persona → adopt persona
2. Read workflow file BEFORE doing anything else:
   - Template will specify which workflow file to read (line "BẮT BUỘC (MANDATORY): Read and follow")
   - Detailed workflow files: `skills/orchestra-bmad/references/workflows/*.md` (23 workflows)
   - Quick reference (only use when NO workflow file specified): `skills/orchestra-bmad/references/phase-workflows.md`
3. Follow step-by-step per workflow file — do NOT skip, do NOT merge, do NOT summarize
4. Quality: minimum 3 findings if review task
5. Definition of Done: check EVERY item in checklist (if workflow file has checklist)

## Documentation Output:
- When creating any documentation → read `skills/orchestra-bmad/references/documentation-standards.md` FIRST
- Follow formatting rules, section structure, and quality standards within
- Applies to: PRD, architecture docs, project context, UX specs, story specs

## Brain Idempotency — BẮT BUỘC (MANDATORY) when using NeuralMemory:
- BEFORE nmem_remember → nmem_recall to check if similar memory exists
- If exists → nmem_edit (update) instead of nmem_remember (create new)
- Every nmem_remember MUST have trust_score
- Type decision/error/workflow/instruction MUST have context dict

## On completion — write results with structure:
## Decisions — key decisions made
## Files Changed — list of files created/modified
## Issues Found — problems discovered
## Brain Memories — list of nmem_remember/nmem_edit calls made (if NeuralMemory available)

## NOT ALLOWED:
- Modifying files outside scope
- Contacting other workers directly
- Skipping tests in dev-story (Red phase is mandatory)
- Asking user — read task + brain, decide within scope
