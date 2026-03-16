# Block 2: End-to-End Framework

> **Done when:** Each phase tested independently + full Phase 1→4 on synthetic project completes.

**Parent plan:** [../2026-03-16-orchestra-bmad.md](../2026-03-16-orchestra-bmad.md)
**Depends on:** Block 1 (working worker dispatch)

---

## Task 11: Create Test Fixtures + Brain Seeding (PREREQUISITE)

All Block 2 tests need a synthetic project with brain context from prior phases.

- [ ] **Step 1: Create synthetic project**

```bash
~/.claude/orchestra/templates/bmad-output-init.sh ~/test-orchestra-e2e
cd ~/test-orchestra-e2e && git init && git add -A && git commit -m "init"
```

- [ ] **Step 2: Create mock Phase 1 output**

Write `_bmad-output/product-brief.md`:
- Vision: "Task management app for small teams"
- Users: Team leads, developers
- Features: Create/assign tasks, kanban board, due dates, notifications
- Constraints: FastAPI backend, React frontend, PostgreSQL
- Metrics: 100 concurrent users, <200ms response

- [ ] **Step 3: Seed brain with Phase 1 decisions**

```
nmem_remember(type="decision", tags=["test-orchestra-e2e", "phase-1", "product-brief"],
  content="Product brief: Task management app. FastAPI + React + PostgreSQL. Key features: CRUD tasks, kanban, notifications.",
  priority=6, trust_score=0.8)
```

- [ ] **Step 4: Create mock Phase 2 outputs**

Write `_bmad-output/PRD.md`:
- Epic 1: User Authentication (login, register, password reset)
- Epic 2: Task CRUD (create, read, update, delete tasks with due dates)
- Epic 3: Kanban Board (drag-drop columns: todo/in-progress/done)
- NFRs: <200ms API response, 100 concurrent users, mobile-responsive
- Tech: FastAPI + SQLAlchemy + PostgreSQL + React + TailwindCSS

Write `_bmad-output/ux-spec.md`:
- Kanban board layout with 3 columns
- Task card: title, assignee, due date, priority badge
- Modal for task CRUD operations
- Responsive: sidebar collapses on mobile

- [ ] **Step 5: Seed brain with Phase 2 decisions**

```
nmem_remember(type="decision", tags=["test-orchestra-e2e", "phase-2", "prd"],
  content="PRD: 3 epics (Auth, Tasks CRUD, Kanban). 8 stories total. Tech: FastAPI, SQLAlchemy, React, TailwindCSS.",
  priority=6, trust_score=0.8)
```

- [ ] **Step 6: Git commit fixtures**

```bash
cd ~/test-orchestra-e2e
git add -A && git commit -m "test: fixtures for Phase 1+2 outputs" && git tag phase-2-complete
```

---

## Task 12: Test Phase 1+2 (Analysis + Planning)

Phase 1 = Mai interactive (no worker). Phase 2 = John PRD + Sally UX (partial parallel).

- [ ] **Step 1: Test Phase 1 — Mai as Mary**

Mai adopts Mary persona, runs brainstorm on a NEW test topic (not the fixture project).
Verify: product-brief.md created, brain memories saved, interactive conversation works.

Pass: product-brief.md has all 5 sections (Vision, Users, Features, Constraints, Metrics).

- [ ] **Step 2: Test Phase 2 — dispatch John (PRD)**

Use fixtures project. Dispatch worker with `~/.claude/orchestra/templates/phase2-prd.md`.
Wait for `signals/w1.feature-scope-ready` (mid-task signal).

Pass: signal appears before `w1.done`, PRD.md created with features + user stories.

- [ ] **Step 3: On feature-scope-ready, dispatch Sally (UX)**

Dispatch with `~/.claude/orchestra/templates/phase2-ux.md`. Sally reads feature scope from brain.
Wait for both `w1.done` + `w2.done`.

Pass: ux-spec.md created, references features from PRD.

- [ ] **Step 4: Verify document chain**

```bash
# PRD references product-brief
grep -l "product-brief\|Vision\|task management" ~/test-orchestra-e2e/_bmad-output/PRD.md
# UX references PRD features
grep -l "kanban\|tasks\|CRUD" ~/test-orchestra-e2e/_bmad-output/ux-spec.md
```

Pass: Each phase output references prior phase's key concepts.

- [ ] **Step 5: Git commit Phase 2 gate**

```bash
git add -A && git commit -m "[orchestra-bmad] Phase 2 complete" && git tag phase-2-test
```

---

## Task 13: Test Phase 3 Partial Parallel

Winston → arch-ready signal → John stories → both done → Readiness Check → Paige.

- [ ] **Step 1: Update checkpoint**

```bash
~/orchestra-checkpoint.sh phase 3 Solutioning
```

- [ ] **Step 2: Dispatch Winston (architecture)**

Template: `phase3-architecture.md`. Wait for `signals/w1.arch-ready`.

Pass: architecture.md created with component breakdown + tech decisions. Signal appears before `done`.

- [ ] **Step 3: On arch-ready, dispatch John (stories)**

Template: `phase3-stories.md`. Wait for `w1.done` + `w2.done`.

Pass: `epics/` directory has epic files with stories. Stories reference architecture components.

- [ ] **Step 4: Dispatch Winston (readiness check)**

Template: `phase3-readiness.md`. Check results.

Pass: Output is PASS, CONCERNS, or FAIL (not empty or garbage).

- [ ] **Step 5: If PASS, dispatch Paige (project-context)**

Template: `phase3-project-context.md`.

Pass: project-context.md created with tech stack, conventions, testing patterns from architecture.

- [ ] **Step 6: Verify outputs + brain**

```bash
test -s ~/test-orchestra-e2e/_bmad-output/architecture.md && echo "arch OK"
ls ~/test-orchestra-e2e/_bmad-output/epics/*.md | wc -l  # Expected: 1+ epic files
test -s ~/test-orchestra-e2e/_bmad-output/project-context.md && echo "context OK"
```

Brain: `nmem_recall("test-orchestra-e2e Phase 3: architecture")` returns decisions.

- [ ] **Step 7: Git commit Phase 3 gate**

```bash
git add -A && git commit -m "[orchestra-bmad] Phase 3 complete" && git tag phase-3-complete
```

---

## Task 14: Test Phase 4 Sprint Cycle — 1 Story

Bob plan → Bob create-story → Amelia dev (TDD) → Review → done.

- [ ] **Step 1: Dispatch Bob (sprint planning)**

Template: `~/.claude/orchestra/templates/phase4-sprint-planning.md`
Pass: Results describe story sequence. Brain has sprint scope.

- [ ] **Step 2: Dispatch Bob (create story-1-1)**

Template: `~/.claude/orchestra/templates/phase4-create-story.md`
Pass: `implementation_artifacts/story-1-1.md` created with requirements + acceptance criteria.

- [ ] **Step 3: Dispatch Amelia (dev story-1-1)**

Template: `~/.claude/orchestra/templates/phase4-dev-story.md`
Pass: Code written with TDD. Tests exist AND pass. Files only within scope.

- [ ] **Step 4: Assess + dispatch reviewer(s)** (spec D3: flexible allocation)

Mai checks scope:
- Security/auth/payment? → 3 parallel (Blind Hunter + Edge Case Hunter + Acceptance Auditor)
- >3 files / >200 LOC? → 2 (Blind + Acceptance)
- Else → 1 reviewer cycling all 3 perspectives

Templates: `phase4-review-blind.md`, `phase4-review-edge.md`, `phase4-review-acceptance.md`
Pass: Review results have >= 3 findings total. Zero findings = HALT + re-evaluate.

- [ ] **Step 5: Dispatch Quinn (E2E tests) — per spec Phase 4 Step 4**

Template: `~/.claude/orchestra/templates/phase4-e2e-tests.md`
Pass: API/E2E tests written (different from Amelia's unit tests). Tests pass.

- [ ] **Step 6: Update sprint-status.yaml**

Mai updates: story-1-1 status → done. Verify state machine: `in-progress → review → done`.

- [ ] **Step 7: Verify Phase 4 cycle**

```bash
test -s ~/test-orchestra-e2e/implementation_artifacts/story-1-1.md && echo "story OK"
test -s ~/test-orchestra-e2e/sprint-status.yaml && echo "sprint OK"
# Tests pass
cd ~/test-orchestra-e2e && python -m pytest 2>/dev/null || echo "no pytest"
```

Brain: `nmem_recall("test-orchestra-e2e Phase 4: story-1-1")` returns implementation decisions.

---

## Task 15: Test Quick Flow (Barry)

Quick-spec → quick-dev for small changes. Skip phases 1-3.

- [ ] **Step 1: Dispatch Barry (quick-spec)**

Task: "Add a /health endpoint returning {status: ok} to the FastAPI app"

Template: `quickflow-spec.md`. Pass: tech-spec created, scope confirmed <3 files.

- [ ] **Step 2: Dispatch Barry (quick-dev)**

Template: `quickflow-dev.md`. Pass: endpoint implemented + self-audit done.

- [ ] **Step 3: Test scope escalation**

Dispatch Barry with task that should escalate: "Add user authentication with OAuth2 + role-based permissions"

Pass: Barry writes escalation to results file + `touch signals/w1.escalate` (scope > 3 files / multi-component). Mai detects signal and switches to full BMAD cycle.

---

## Task 16: Test Checkpoint + Resume (Crash Recovery)

- [ ] **Step 1: Start Phase 3 with Winston (architecture) running**

Dispatch Winston via `~/.claude/orchestra/templates/phase3-architecture.md`. Wait ~30s (worker should be mid-task).

- [ ] **Step 2: Kill worker mid-task**

```bash
# If tmux: kill pane
tmux kill-pane -t %2
# If Native Agent: kill Agent process
```

- [ ] **Step 3: Verify checkpoint state**

```bash
~/orchestra-checkpoint.sh read
# Expected: phase=3, status=in-progress
~/orchestra-checkpoint.sh verify ~/test-orchestra-e2e
# Expected: shows which files exist/missing for current phase
```

- [ ] **Step 4: Run resume protocol**

1. Read checkpoint → phase 3, worker w1 running
2. `nmem_recall("test-orchestra-e2e Phase 3")` → what decisions were made
3. `tmux list-panes` → worker pane dead
4. Verify files: architecture.md exists? Partial?
5. Re-dispatch worker with fresh task (git clean state first if needed)

Pass: Resumed worker completes the task. Brain has decisions from both attempts.

- [ ] **Step 5: Record results in `~/.claude/orchestra/tests/block2-crash-recovery.md`**

Include: checkpoint state before/after, files present, brain recall results, resume outcome.

---

## Task 17: Full Phase 1→4 on Synthetic Project (Block 2 Done Criteria)

Run complete cycle without manual intervention (except Phase 1 interactive).

- [ ] **Step 1: New project** (not fixtures — fresh from scratch)

- [ ] **Step 2: Phase 1** — Mai as Mary. Pass: product-brief.md with 5 sections
- [ ] **Step 3: Phase 2** — John PRD + Sally UX. Pass: PRD.md + ux-spec.md, document chain verified
- [ ] **Step 4: Phase 3** — Winston → John → Readiness → Paige. Pass: architecture.md + epics/ + project-context.md
- [ ] **Step 5: Phase 4** — Bob plan → 1 story (create → dev → review → Quinn). Pass: code + tests pass
- [ ] **Step 6: Verify all phase gate commits exist**

```bash
git log --oneline | grep "orchestra-bmad"
# Expected: Phase 1, 2, 3, 4 commits
```

- [ ] **Step 7: Verify brain audit trail**

```
nmem_recall("test-project Phase 1 Phase 2 Phase 3 Phase 4 decisions")
# Expected: memories from all 4 phases
```

Pass: Project has all _bmad-output/ documents, implementation with tests, git history with phase gates.
