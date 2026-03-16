# Block 1: Worker Infrastructure

> **Done when:** 1 worker dispatched with persona + MCP verified, writes brain + results, signals done.

**Parent plan:** [../2026-03-16-orchestra-bmad.md](../2026-03-16-orchestra-bmad.md)
**Depends on:** Block 0 (dispatch mechanism decided)

**Parallelizable:** Tasks 3, 6, 7, 8, 9 independent. Tasks 4, 5 depend on 3. Task 10 depends on all.

---

## Task 3: Create 9 BMAD Agent Persona Files

Adapt BMAD personas for Orchestra. Strip interactive menu, keep persona + skills + rules.

**Files:**
- Create: `~/.claude/agents/{mary-analyst,john-pm,winston-architect,bob-sm,amelia-dev,sally-ux,quinn-qa,barry-quickflow,paige-tech-writer}.md`
- Reference: `~/bemai-learning/_bmad/bmm/agents/*.md`

- [ ] **Step 1: Read all BMAD agent sources**

| Source file | Target | Name | Core skills to extract |
|-------------|--------|------|----------------------|
| `analyst.md` | `mary-analyst.md` | Mary | Market research, requirements elicitation, brainstorming |
| `pm.md` | `john-pm.md` | John | PRD, epics & stories, course correction, readiness |
| `architect.md` | `winston-architect.md` | Winston | Architecture, ADRs, implementation readiness check |
| `sm.md` | `bob-sm.md` | Bob | Sprint planning, story creation, retrospective |
| `dev.md` | `amelia-dev.md` | Amelia | TDD (Red-Green-Refactor), code implementation |
| `ux-designer.md` | `sally-ux.md` | Sally | User flows, wireframes, design system |
| `qa.md` | `quinn-qa.md` | Quinn | E2E tests, API tests, coverage analysis |
| `quick-flow-solo-dev.md` | `barry-quickflow.md` | Barry | Quick-spec, quick-dev, scope escalation |
| `tech-writer/` (dir) | `paige-tech-writer.md` | Paige | Documentation, project-context generation |

- [ ] **Step 2: Create each persona file**

Reference implementation — `mary-analyst.md`:
```markdown
# Mary — Business Analyst

## Persona
Senior analyst with deep expertise in market research, competitive analysis, and requirements elicitation.
Speaks with excitement of a treasure hunter — thrilled by patterns, energized by discovery.

## Skills
- Brainstorm project (SCAMPER, reverse brainstorming)
- Market/domain/technical research
- Create product brief
- Document existing project

## BMAD Workflows
- bmad-create-product-brief: ~/bemai-learning/_bmad/bmm/workflows/1-analysis/bmad-create-product-brief/
- bmad-brainstorming: ~/bemai-learning/_bmad/core/skills/bmad-brainstorming/

## Orchestra Rules
- Ghi brain decisions với project name in tags
- nmem_recall trước khi bắt đầu task
- CHỈ sửa files trong scope được giao
- Communicate in tiếng Việt
```

**Note:** No template for Phase 1 — Mai acts as Mary directly (interactive brainstorm with Tyler, no worker dispatch).

Per-agent persona content guide:

| Agent | Persona extract from BMAD source | Key additions for Orchestra |
|-------|--------------------------------|---------------------------|
| **mary-analyst** | "treasure hunter" communication, SCAMPER brainstorming | Mai-direct, no worker dispatch |
| **john-pm** | Requirements precision, stakeholder focus | PRD must cover all brief requirements |
| **winston-architect** | System thinking, trade-off analysis | ADRs required for each tech decision |
| **bob-sm** | Sprint discipline, velocity tracking | Sprint-status writes via brain only (Mai updates file) |
| **amelia-dev** | Ultra-succinct, file paths + AC IDs | **TDD mandatory. NEVER complete without passing tests. HALT on 3 failures.** |
| **sally-ux** | User empathy, accessibility focus | Skip when backend-only/CLI/infra |
| **quinn-qa** | Adversarial testing mindset | **Min 3 findings per review. 0 findings = HALT.** |
| **barry-quickflow** | Fast iteration, scope awareness | **Detect scope growth → signal Mai for escalation** |
| **paige-tech-writer** | Documentation precision, standards | Generate project-context.md as constitution for Phase 4 |

- [ ] **Step 3: Verify all 9 files**

```bash
for f in mary-analyst john-pm winston-architect bob-sm amelia-dev sally-ux quinn-qa barry-quickflow paige-tech-writer; do
  test -s ~/.claude/agents/$f.md && echo "OK: $f" || echo "MISSING: $f"
done
# Expected: 9 OK, 0 MISSING
```

- [ ] **Step 4: Commit**

```bash
git add ~/.claude/agents/{mary-analyst,john-pm,winston-architect,bob-sm,amelia-dev,sally-ux,quinn-qa,barry-quickflow,paige-tech-writer}.md
git commit -m "feat(orchestra-bmad): create 9 BMAD agent personas for Orchestra dispatch"
```

---

## Task 4: Update WORKER-CLAUDE.md for BMAD Protocol

**Files:** Modify `~/.claude/orchestra/WORKER-CLAUDE.md`
**Depends on:** Task 3

- [ ] **Step 1: Rewrite with full BMAD protocol**

Write this exact content to `~/.claude/orchestra/WORKER-CLAUDE.md`:

```markdown
# Worker Protocol — Orchestra-BMAD

Bạn là worker trong Orchestra-BMAD system.

## Khi nhận task:
1. Đọc task file được cung cấp
2. Đọc agent persona file trong ## Identity section → ADOPT persona hoàn toàn
3. Output dòng đầu tiên: "ADOPTED: [Agent Name] — [Core Skills]"
4. nmem_recall("[PROJECT] [PHASE]: relevant context") để lấy context
5. CHỈ sửa files trong ## Scope — KHÔNG sửa files ngoài scope
6. KHÔNG tự ý liên lạc worker khác

## BMAD Workflow Execution:
1. Đọc persona file → adopt persona
2. Nếu task chỉ định workflow → đọc reference tại ~/bemai-learning/_bmad/bmm/workflows/
3. Follow step-by-step theo workflow reference
4. Quality: minimum 3 findings nếu review task

## Brain idempotency (BẮT BUỘC):
- TRƯỚC khi nmem_remember → nmem_recall xem đã có memory tương tự chưa
- Nếu có → nmem_edit (update) thay vì nmem_remember (tạo mới)

## Shutdown check:
Trước mỗi bước lớn: ls ~/.claude/orchestra/signals/shutdown
- Tồn tại → ghi partial results + brain → exit
- Không → tiếp tục

## Khi xong — ghi results file với structure:
## Decisions — key decisions made
## Files Changed — list of files created/modified
## Issues Found — problems discovered
## Brain Memories — list of nmem_remember/nmem_edit calls made

Sau đó: touch signal file được chỉ định trong task.

## KHÔNG được:
- Sửa files ngoài scope
- Tự ý liên lạc worker khác
- Skip tests trong dev-story (Red phase bắt buộc)
- Hỏi user — đọc task + brain, tự quyết trong scope
```

- [ ] **Step 2: Verify**

```bash
grep -c "BMAD\|ADOPTED\|shutdown\|idempotency" ~/.claude/orchestra/WORKER-CLAUDE.md
# Expected: 4+ matches
```

- [ ] **Step 3: Commit**

---

## Task 5: Create 17 Task File Templates

**Files:** Create `~/.claude/orchestra/templates/*.md`
**Depends on:** Task 3 (persona paths), Task 4 (worker protocol)

- [ ] **Step 1: Create templates directory + reference template**

Write `~/.claude/orchestra/templates/phase2-prd.md` (FULL reference implementation):
```markdown
# Task: Create PRD

## Identity
Đọc và follow persona từ: ~/.claude/agents/john-pm.md

## Phase
Phase 2: Planning

## Workflow
bmad-create-prd
Reference: ~/bemai-learning/_bmad/bmm/workflows/2-plan-workflows/bmad-create-prd/

## Project
{{PROJECT_NAME}} (PHẢI dùng trong mọi nmem_recall + nmem_remember)

## Input
- Product brief: {{PROJECT_DIR}}/_bmad-output/product-brief.md
- Brain context: nmem_recall("{{PROJECT_NAME}} Phase 1: product brief, requirements, constraints")

## Output
- File: {{PROJECT_DIR}}/_bmad-output/PRD.md (CHỈ bạn sở hữu file này)
- Results: ~/.claude/orchestra/results/{{WORKER_ID}}.md

## Scope
CHỈ tạo/sửa: {{PROJECT_DIR}}/_bmad-output/PRD.md

## Special Instructions
Khi feature scope ready (features list + user stories), immediately:
  nmem_remember(type="context", tags=["{{PROJECT_NAME}}", "phase-2", "feature-scope"], content="Feature scope: [list]", priority=6, trust_score=0.8)
  touch ~/.claude/orchestra/signals/{{WORKER_ID}}.feature-scope-ready

## Persona Confirmation
Dòng đầu tiên output: "ADOPTED: [Agent Name] — [Core Skills]"

## Timeout
15 minutes (Phase 2 worker)

## Khi xong
1. nmem_remember(type="decision", tags=["{{PROJECT_NAME}}", "phase-2", "prd"], content="PRD decisions: ...", priority=7, trust_score=0.8)
2. Ghi summary vào ~/.claude/orchestra/results/{{WORKER_ID}}.md
3. touch ~/.claude/orchestra/signals/{{WORKER_ID}}.done
```

Second reference — `~/.claude/orchestra/templates/phase4-dev-story.md`:
```markdown
# Task: Dev Story

## Identity
Đọc và follow persona từ: ~/.claude/agents/amelia-dev.md

## Phase
Phase 4: Implementation

## Workflow
bmad-dev-story
Reference: ~/bemai-learning/_bmad/bmm/workflows/4-implementation/bmad-dev-story/

## Project
{{PROJECT_NAME}}

## Input
- Story file: {{PROJECT_DIR}}/implementation_artifacts/{{STORY_ID}}.md
- Architecture: {{PROJECT_DIR}}/_bmad-output/architecture.md
- Project context: {{PROJECT_DIR}}/_bmad-output/project-context.md
- Brain: nmem_recall("{{PROJECT_NAME}} Phase 4: {{STORY_ID}} context, architecture decisions")

## Output
- Code + tests in project directory
- Results: ~/.claude/orchestra/results/{{WORKER_ID}}.md

## Scope
CHỈ sửa files liên quan đến story requirements. KHÔNG sửa story file, sprint-status, hoặc files của stories khác.

## TDD Rules (BẮT BUỘC)
1. Write FAILING tests FIRST (Red)
2. Implement minimal code to pass (Green)
3. Refactor for clarity
- NEVER mark complete unless ALL tests pass 100%
- NEVER skip or reorder steps
- HALT on: 3 consecutive failures, missing config, regressions

## Timeout
30 minutes (Phase 4 dev worker)

## Persona Confirmation
Dòng đầu tiên output: "ADOPTED: Amelia — TDD, code implementation"

## Khi xong
1. nmem_remember(type="decision", tags=["{{PROJECT_NAME}}", "phase-4", "{{STORY_ID}}"], content="Implementation: ...", priority=6, trust_score=0.8)
2. Results với ## Decisions, ## Files Changed, ## Issues Found, ## Brain Memories
3. touch ~/.claude/orchestra/signals/{{WORKER_ID}}.done
```

- [ ] **Step 2: Create remaining 15 templates following same pattern**

Each template adapts: Identity (persona path), Phase, Workflow (reference path), Input (files + brain query), Output, Scope, Special Instructions (signals), Persona Confirmation, Khi xong.

| Template | Key differences from reference |
|----------|-------------------------------|
| `phase2-ux.md` | Sally persona, input=PRD feature scope (from brain), output=ux-spec.md |
| `phase3-architecture.md` | Winston, signal `arch-ready` when component breakdown done, output=architecture.md |
| `phase3-stories.md` | John, depends on arch-ready, output=epics/*.md |
| `phase3-readiness.md` | Winston, output=PASS/CONCERNS/FAIL in results |
| `phase3-project-context.md` | Paige, input=arch+PRD+brain, output=project-context.md |
| `phase4-sprint-planning.md` | Bob, input=epics+arch, output described in results (Mai writes sprint-status.yaml) |
| `phase4-create-story.md` | Bob, input=epic+story ID, output=implementation_artifacts/{{STORY_ID}}.md |
| `phase4-dev-story.md` | Amelia, TDD mandatory, input=story+arch+project-context |
| `phase4-review-blind.md` | No persona file — instructions: review diff ONLY, no story context. Min 3 findings |
| `phase4-review-edge.md` | Instructions: check every branching path. Min 3 findings |
| `phase4-review-acceptance.md` | Instructions: diff vs acceptance criteria. Min 3 findings |
| `phase4-e2e-tests.md` | Quinn, per-epic, input=all completed stories |
| `phase4-retrospective.md` | Bob, per-epic, output=lessons learned to brain |
| `phase4-course-correction.md` | John/Bob, input=change request+sprint-status+brain |
| `quickflow-spec.md` | Barry, quick-spec for <3 files single component |
| `quickflow-dev.md` | Barry, quick-dev + self-audit, scope escalation detection |

Reviewer templates (blind/edge/acceptance) don't use persona files — they use inline instructions for review perspective. See spec "Code Review (flexible allocation)" section.

Each template MUST include `## Timeout` field. Values from spec:
- Phase 2 workers: 15min
- Phase 3 workers: 20min
- Phase 4 dev: 30min
- Phase 4 review: 10min
- Quick Flow: 15min

Signal monitor reads this field to determine timeout threshold per worker.

- [ ] **Step 3: Verify**

```bash
ls ~/.claude/orchestra/templates/*.md | wc -l
# Expected: 17
```

- [ ] **Step 4: Commit**

---

## Task 6: Create Signal Monitor Script + Auto-start

**Files:** Create `~/claude-signal-monitor.sh`

- [ ] **Step 1: Write script**

Features:
- `inotifywait -m -e create -e moved_to` on `~/.claude/orchestra/signals/`
- Log: `[timestamp] SIGNAL_RECEIVED signal=filename` → `~/.claude/orchestra/orchestra.log`
- Alert: `tmux display-message` to Mai's pane
- Timeout checker (every 60s): check task file age vs thresholds (Phase 2: 15min, Phase 3: 20min, Phase 4 dev: 30min, review: 10min)
- Shutdown acknowledgment detection

- [ ] **Step 2: Test**

```bash
chmod +x ~/claude-signal-monitor.sh
~/claude-signal-monitor.sh &
MONITOR_PID=$!
touch ~/.claude/orchestra/signals/test-signal.done
sleep 2
grep "test-signal" ~/.claude/orchestra/orchestra.log
# Expected: SIGNAL_RECEIVED signal=test-signal.done
kill $MONITOR_PID
rm ~/.claude/orchestra/signals/test-signal.done
```

- [ ] **Step 3: Add to tmux-work launcher** (auto-start with Orchestra)

Add signal monitor start to `~/tmux-work.sh` or equivalent launcher script.

- [ ] **Step 4: Commit**

---

## Task 7: Create Checkpoint System + Consistency Verification

**Files:**
- Create: `~/.claude/orchestra/checkpoint.yaml` (initial)
- Create: `~/orchestra-checkpoint.sh`

- [ ] **Step 1: Create checkpoint.yaml** (schema from spec)

- [ ] **Step 2: Create checkpoint utility**

Commands:
- `read` — display checkpoint
- `update KEY VALUE` — update field + timestamp
- `phase N NAME` — update phase + status
- `worker WID STATUS` — update worker
- `verify PROJECT_DIR` — consistency check:
  1. Check files exist for completed phases (brief, PRD, architecture, etc.)
  2. Verify sprint-status.yaml matches checkpoint sprint_state
  3. Report inconsistencies with priority hierarchy: checkpoint > sprint-status > files > brain

Note: YAML manipulation via `yq` if available, else `sed` (verify `yq` installed or install).

- [ ] **Step 3: Test**

```bash
chmod +x ~/orchestra-checkpoint.sh
~/orchestra-checkpoint.sh read
~/orchestra-checkpoint.sh phase 1 Analysis
~/orchestra-checkpoint.sh read | grep "phase:"
# Expected: phase: 1
~/orchestra-checkpoint.sh update status idle
```

- [ ] **Step 4: Commit**

---

## Task 8: Create Health Check + Observability

**Files:** Create `~/orchestra-health-check.sh`

- [ ] **Step 1: Write health check**

Checks:
1. tmux session 'claude' alive
2. PostgreSQL reachable: `pg_isready`
3. NeuralMemory brain reachable: `nmem recall "health check ping" --limit 1` (exit code)
4. signals/ directory exists
5. Disk space >1GB: `df --output=avail / | tail -1`
6. Worker panes alive (if checkpoint says running): `tmux list-panes`

- [ ] **Step 2: Test + schedule** (optional cron every 5min when workers running)

- [ ] **Step 3: Commit**

---

## Task 9: Create _bmad-output Init + Sprint Status Template

**Files:**
- Create: `~/.claude/orchestra/templates/bmad-output-init.sh`
- Create: `~/.claude/orchestra/templates/sprint-status-template.yaml`

- [ ] **Step 1: Create init script**

Creates: `_bmad-output/epics/`, `implementation_artifacts/`, `sprint-status.yaml` (from template, at project root).
Also runs `git init` if not already a repo (needed for phase gate commits + rollback).

- [ ] **Step 2: Create sprint-status template** (schema from spec)

- [ ] **Step 3: Test + Commit**

```bash
chmod +x ~/.claude/orchestra/templates/bmad-output-init.sh
~/.claude/orchestra/templates/bmad-output-init.sh /tmp/test-project
ls /tmp/test-project/_bmad-output/epics/ && ls /tmp/test-project/sprint-status.yaml && ls /tmp/test-project/.git
# Expected: all exist
rm -rf /tmp/test-project
```

---

## Task 10: Integration Test — 1 Worker End-to-End

**Depends on:** All Tasks 3-9. This is Block 1's done criteria.

- [ ] **Step 1: Init test project**

```bash
~/.claude/orchestra/templates/bmad-output-init.sh ~/test-orchestra-bmad
```

- [ ] **Step 2: Verify MCP + permissions** (REG-004, REG-016)

Before dispatching worker, verify:
```bash
# MCP tools available (worker must have nmem_recall)
# If tmux: ensure --dangerously-skip-permissions is set
# If Native Agent: MCP tools inherited from Mai
```

- [ ] **Step 3: Write test task** (Mary writes mock product brief — 5 sections: Vision, Users, Features, Constraints, Metrics)

- [ ] **Step 4: Clean signals + start monitor**

```bash
rm -f ~/.claude/orchestra/signals/*.done ~/.claude/orchestra/results/*.md
~/claude-signal-monitor.sh &
```

- [ ] **Step 5: Dispatch worker** (using ADR-001 mechanism)

- [ ] **Step 6: Wait + verify** (max 5 min)

```bash
timeout 300 bash -c 'while [ ! -f ~/.claude/orchestra/signals/w1.done ]; do sleep 5; done'
```

**Pass criteria:**
- [ ] `signals/w1.done` exists
- [ ] `results/w1.md` exists and contains "ADOPTED: Mary"
- [ ] `~/test-orchestra-bmad/_bmad-output/product-brief.md` exists and non-empty
- [ ] `nmem_recall("test-orchestra-bmad Phase 1")` returns worker's decisions
- [ ] Signal monitor logged the signal in `orchestra.log`
- [ ] Worker stayed within scope (no files modified outside `_bmad-output/`)

- [ ] **Step 7: Cleanup + commit results**

```bash
rm -rf ~/test-orchestra-bmad
```
