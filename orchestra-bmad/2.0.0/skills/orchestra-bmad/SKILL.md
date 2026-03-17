---
name: orchestra-bmad
description: Use when building features, products, or running structured agile workflow with BMAD phases. Triggers on "build X", "/orchestra", or any multi-step development task.
---

# Orchestra-BMAD

Structured agile workflow. The Orchestrator dispatches 9 agents across 4 phases to build features end-to-end.

## Branching Matrix Analysis — BẮT BUỘC (MANDATORY)

Invoke `branching-matrix-analysis` skill automatically at these points — do NOT wait for user prompt:

| # | Trigger Point | When | Depth |
|---|---------------|------|-------|
| 1 | **After Phase 1 (brainstorm)** | Before Phase 2 — verify product brief covers all angles | 3-4 domains |
| 2 | **After Phase 2 (PRD+UX)** | Before Phase 3 — verify PRD + UX complete | 5-6 domains |
| 3 | **After Phase 3 (architecture)** | Before Phase 4 — verify architecture + stories aligned | 7-10 domains |
| 4 | **After plan written** | Before executing plan | 6-7 domains |
| 5 | **After code review** | Before marking story done — verify review coverage | 3-4 domains |
| 6 | **After each phase gate** | Before committing phase gate — verify deliverables complete | 5-6 domains |
| 7 | **When User changes requirements** | Before course correction — assess impact across domains | 5-7 domains |
| 8 | **After implementation complete** | Before claiming done (REG-024) — verify + cleanup | 6-7 domains |
| 9 | **Quick Flow: after spec** | Before Barry dev | 3-4 domains |

**Rule:** If matrix analysis finds critical gaps → fix BEFORE proceeding. No exceptions.
**Depth calibration:** Trivial (3-4), medium (5-6), large/architecture (7-10).

## Scope Assessment

Determine workflow type from user input:

**Quick Flow** (Barry solo) when ANY:
- `--quick` flag passed
- Request is < 3 files, single component, no new architecture
- Bug fix, small enhancement, config change

**Full Cycle** (Phase 1-4) when ANY:
- New feature/product/app
- Multi-component changes
- Architecture decisions needed
- No `--quick` flag and request is substantial

**Resume** when:
- `--resume` flag OR checkpoint detected at `_bmad-output/.orchestra-state.yaml`
- Read checkpoint, resume from saved phase/step

**Status** when:
- `--status` flag — read checkpoint and report progress

---

## Quick Flow

1. Read template: `skills/orchestra-bmad/templates/quickflow-spec.md`
2. Dispatch Barry via Agent tool with template + worker-protocol.md
3. On completion, read template: `skills/orchestra-bmad/templates/quickflow-dev.md`
4. Dispatch Barry for implementation
5. If Barry signals escalation → switch to Full Cycle Phase 2
6. Report result to User

---

## Phase 1: Analysis (Orchestrator as Mary)

Orchestrator adopts Mary's persona directly (no Agent dispatch).

1. Read agent persona: `agents/mary-analyst.md`
2. **BẮT BUỘC (MANDATORY): Read workflow** `references/workflows/bmad-create-brief.md` — follow ALL 5 stages
3. Interactive brainstorm with User — guided elicitation (not just 5 questions):
   - Understand intent → Contextual discovery → Gap-filling questions → Draft & review → Finalize
4. Optional: If User needs research first:
   - Market research: dispatch Mary with `references/workflows/bmad-market-research.md`
   - Domain research: dispatch Mary with `references/workflows/bmad-domain-research.md`
   - Technical research: dispatch Mary with `references/workflows/bmad-technical-research.md`
5. Write `_bmad-output/product-brief.md` using template from workflow
6. If NeuralMemory available: nmem_remember product brief decisions with project tags
7. Save checkpoint: phase=1, status=complete

**Output to User:** "Product brief complete. Starting planning phase..."

---

## Phase 2: Planning (John + Sally)

1. Read template: `skills/orchestra-bmad/templates/phase2-prd.md`
2. **BẮT BUỘC (MANDATORY): Include workflow** `references/workflows/bmad-create-prd.md` in dispatch prompt
3. Fill placeholders: `{{PROJECT_NAME}}`, `{{PROJECT_DIR}}`, `{{WORKER_ID}}`
4. Dispatch John via Agent tool with filled template + workflow + worker-protocol.md
5. **Quality Gate**: Validate PRD with `references/workflows/bmad-validate-prd.md` (13 steps)
   - If gaps found → dispatch John with `references/workflows/bmad-edit-prd.md` (max 2 retries)
6. If project has UI:
   - Read template: `skills/orchestra-bmad/templates/phase2-ux.md`
   - **BẮT BUỘC (MANDATORY): Include workflow** `references/workflows/bmad-create-ux-design.md` (14 steps)
   - Dispatch Sally via Agent tool (can run after PRD feature-scope ready)
7. Save checkpoint: phase=2, status=complete

**Output to User:** "Phase 2: John is writing the PRD..."

---

## Phase 3: Solutioning (Winston + John + Paige)

### Step 3a: Architecture
1. Read template: `skills/orchestra-bmad/templates/phase3-architecture.md`
2. **BẮT BUỘC (MANDATORY): Include workflow** `references/workflows/bmad-create-architecture.md` (8 steps)
3. Dispatch Winston via Agent tool

### Step 3b: Stories (after architecture ready)
1. Read template: `skills/orchestra-bmad/templates/phase3-stories.md`
2. **BẮT BUỘC (MANDATORY): Include workflow** `references/workflows/bmad-create-epics.md` (4 steps)
3. Dispatch John via Agent tool

### Step 3c: Readiness Check
1. Read template: `skills/orchestra-bmad/templates/phase3-readiness.md`
2. **BẮT BUỘC (MANDATORY): Include workflow** `references/workflows/bmad-check-readiness.md` (6 steps)
3. Dispatch Winston via Agent tool
4. **Quality Gate**: Verdict must be PASS
   - CONCERNS → fix issues + re-check (max 2 retries)
   - FAIL → escalate to User with details

### Step 3d: Project Context
1. Read template: `skills/orchestra-bmad/templates/phase3-project-context.md`
2. **BẮT BUỘC (MANDATORY): Include workflow** `references/workflows/bmad-generate-project-context.md` (3 steps)
3. Dispatch Paige via Agent tool
4. **BẮT BUỘC (MANDATORY): Read** `references/documentation-standards.md` — include in Paige's dispatch

5. Save checkpoint: phase=3, status=complete

**Output to User:** "Phase 3: Winston is designing the architecture..."

---

## Phase 4: Implementation (Sprint Cycle)

### Step 4a: Sprint Planning
1. Read template: `skills/orchestra-bmad/templates/phase4-sprint-planning.md`
2. Dispatch Bob via Agent tool
3. Create `sprint-status.yaml` from Bob's results

### Step 4b: Per-Story Cycle
For each story in sprint order:

**Create Story Context:**
1. Read template: `skills/orchestra-bmad/templates/phase4-create-story.md`
2. Dispatch Bob with story details

**Develop Story (TDD):**
1. Read template: `skills/orchestra-bmad/templates/phase4-dev-story.md`
2. Dispatch Amelia via Agent tool
3. Amelia follows Red-Green-Refactor strictly

**Code Review (3 parallel reviewers):**
1. Read templates: `phase4-review-blind.md`, `phase4-review-edge.md`, `phase4-review-acceptance.md`
2. Dispatch 3 reviewers in parallel via Agent tool
3. **Quality Gate**: Each reviewer must find min 3 issues
   - 0 findings from any reviewer → re-dispatch that reviewer
   - Aggregate findings → dispatch Amelia to fix (max 3 fix cycles)

**Update Status:**
- Update `sprint-status.yaml`: story → done
- If NeuralMemory available: nmem_remember story completion with findings summary
- Save checkpoint with stories_done count

**Output to User:** "Phase 4: Building story {n}/{total}..."

### Step 4c: Per-Epic Completion
After all stories in an epic:
1. Read template: `skills/orchestra-bmad/templates/phase4-e2e-tests.md`
2. Dispatch Quinn for E2E tests
3. Read template: `skills/orchestra-bmad/templates/phase4-retrospective.md`
4. Dispatch Bob for retrospective
5. Git commit epic milestone

### Step 4d: Course Correction (when needed)
If User requests changes mid-sprint:
1. Read template: `skills/orchestra-bmad/templates/phase4-course-correction.md`
2. Dispatch John+Bob for impact analysis
3. Apply changes based on results
4. Guard: max 3 corrections per sprint

---

## Worker Dispatch Protocol

When dispatching any agent via Agent tool:

```
1. Read agent persona file from agents/ directory
2. Read task template from skills/orchestra-bmad/templates/
3. Read worker protocol from skills/orchestra-bmad/worker-protocol.md
4. Fill template placeholders:
   - {{PROJECT_NAME}} → project name
   - {{PROJECT_DIR}} → absolute path to project
   - {{WORKER_ID}} → unique worker identifier
   - {{STORY_ID}} → story identifier (Phase 4)
   - {{EPIC_ID}} → epic identifier (Phase 4)
   - {{BASE_COMMIT}} → git commit before changes (reviews)
   - {{HEAD_COMMIT}} → git commit after changes (reviews)
   - {{CHANGE_REQUEST}} → change description (course correction)
5. Compose Agent prompt: persona + filled template + worker protocol
6. Dispatch via Agent tool
7. Read results, check quality gates
```

---

## Progress Reporting

Report to User with concise, non-technical updates:
- Phase transitions: "Phase N: [who] is working on [what]..."
- Story progress: "Building story {done}/{total}..."
- Completion: "Done! Tests pass. Code committed."
- Errors: "[agent] encountered an issue: [brief]. Fixing..."
- Escalation: "Need your decision: [question]"

---

## Error Handling

1. Worker fails → auto-retry with same template (max 3 attempts)
2. Quality gate fails → re-dispatch responsible agent with specific feedback
3. 3 consecutive failures → escalate to User:
   - Show what failed, why, what was tried
   - Ask for direction
4. Worker timeout → check partial results, retry or escalate

---

## Checkpoint (Save/Resume)

Save state to `_bmad-output/.orchestra-state.yaml` after each phase/story:

```yaml
schema_version: 1
project: "project-name"
phase: 3
step: "3c-readiness"
status: "in-progress"
started_at: "2026-03-17T10:00:00Z"
updated_at: "2026-03-17T12:30:00Z"
stories_done: 0
stories_remaining: 5
current_epic: "epic-1"
current_story: null
notes: "Readiness check in progress"
```

**On resume:**
1. Read `_bmad-output/.orchestra-state.yaml`
2. If NeuralMemory available: nmem_recall project context
3. Continue from saved phase/step
4. Report to User: "Project [name] was in progress at phase [N]. Resuming..."

---

## Template Resolution

All templates are read via Read tool at plugin-relative paths:
- Templates: `skills/orchestra-bmad/templates/<template>.md`
- **Detailed workflows**: `skills/orchestra-bmad/references/workflows/<workflow>.md`
- Quick reference: `skills/orchestra-bmad/references/phase-workflows.md`
- Other references: `skills/orchestra-bmad/references/<reference>.md`
- Worker protocol: `skills/orchestra-bmad/worker-protocol.md`
- Agent personas: `agents/<agent>.md`

Placeholders use `{{PLACEHOLDER}}` syntax. Orchestrator replaces in prompt text before passing to Agent.

### Workflow Files (BMAD Fidelity) — 23 workflows, 7,690 lines

ALL workflows adapted from BMAD Method v6.2.0 source (346 files → 23 self-contained workflow files).

**Phase 1 — Analysis:**
- `bmad-create-brief.md` — 5-stage product brief with multi-lens review
- `bmad-market-research.md` — 6-step market research with citations
- `bmad-domain-research.md` — 6-step industry/regulatory research
- `bmad-technical-research.md` — 6-step technical feasibility research

**Phase 2 — Planning:**
- `bmad-create-prd.md` — 8-step PRD creation with anti-pattern checks
- `bmad-validate-prd.md` — 13-step PRD validation with domain compliance
- `bmad-edit-prd.md` — 4-step PRD editing with legacy conversion
- `bmad-create-ux-design.md` — 14-step UX design (discovery → accessibility)

**Phase 3 — Solutioning:**
- `bmad-create-architecture.md` — 8-step architecture with ADR template
- `bmad-create-epics.md` — 4-step epic & story creation
- `bmad-check-readiness.md` — 6-step implementation readiness validation
- `bmad-generate-project-context.md` — 3-step LLM-optimized context
- `bmad-document-project.md` — Project documentation with deep-dive mode

**Phase 4 — Implementation:**
- `bmad-sprint-planning.md` — Sprint status YAML generation
- `bmad-sprint-status.md` — Status check with next-action recommendation
- `bmad-create-story.md` — 6-step exhaustive context engine
- `bmad-dev-story.md` — 10-step TDD with Definition of Done
- `bmad-code-review.md` — 4-step adversarial review
- `bmad-qa-e2e-tests.md` — E2E test generation
- `bmad-retrospective.md` — 10-step epic retrospective
- `bmad-correct-course.md` — 6-step change management

**Quick Flow:**
- `bmad-quick-spec.md` — 4-step rapid spec creation
- `bmad-quick-dev.md` — 6-step quick dev with adversarial review

**Supporting references:**
- `documentation-standards.md` — CommonMark, Mermaid, writing standards
- `project-context-template.md` — Brainstorming context template
- `command-registry.md` — Complete 33-command registry
- `agent-personas.md` — Full persona details for 9 agents

Workers MUST read the full workflow file before starting work. phase-workflows.md is the Orchestrator's quick index only.
