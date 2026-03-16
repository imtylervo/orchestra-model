# Orchestra-BMAD Framework Design

## Overview

Framework lấy cảm hứng từ BMAD Method v6, chạy trên Orchestra Model v2. Kết hợp BMAD's structured agile workflow (4 phases, adversarial review, document chain) với Orchestra's parallel execution + shared brain.

**Core thesis:** BMAD cung cấp discipline và quality gates. Orchestra cung cấp parallelism và real-time knowledge sharing. Kết hợp = faster delivery + same quality.

## Design Decisions

### D1: Giữ nguyên BMAD agent personas

Tạo BMAD agent files trong `~/.claude/agents/`:
- `mary-analyst.md` — Brainstorm, research, product brief
- `john-pm.md` — PRD, epics & stories, readiness, course correction
- `winston-architect.md` — Architecture, ADRs, implementation readiness
- `bob-sm.md` — Sprint planning, create story, retrospective
- `amelia-dev.md` — Dev story (Red-Green-Refactor), code review
- `sally-ux.md` — UX design
- `quinn-qa.md` — Test generation
- `barry-quickflow.md` — Quick spec + quick dev
- `paige-tech-writer.md` — Documentation, standards, diagrams, project-context generation

Lý do: Consistent naming, dễ dispatch, không thay đổi khi gọi agent.

### D2: Fresh session per task + brain bridge

Mỗi workflow = 1 fresh worker session. Knowledge persist qua shared brain (NMEM_BRAIN=bemai).

Worker lifecycle:
```
Spawn → load persona → nmem_recall context → execute task → nmem_remember results → signal done → die
```

Lý do: Context sạch như BMAD yêu cầu. Shared brain thay thế project-context.md với semantic search (chỉ pull context liên quan, không load full file).

### D3: Flexible review allocation

Mai tự quyết số reviewers dựa trên story scope:
- Security/auth/payment → 3 workers parallel (Blind Hunter + Edge Case Hunter + Acceptance Auditor)
- >3 files hoặc >200 LOC → 2 workers (Blind Hunter + Acceptance Auditor)
- Else → 1 worker cycle 3 perspectives tuần tự

Rule cứng giữ từ BMAD: zero findings = halt and re-analyze.

### D4: Progressive parallelism across phases

Phases 1-3 tăng dần mức parallel. Phase 4 full parallel.

## Phase Workflows

### Phase 1: Analysis (Mai trực tiếp)

Mai đóng vai Mary Analyst. Không dispatch worker.

```
Tyler: "build X"
  │
  ▼
Mai (as Mary):
  1. Brainstorm interactive (SCAMPER, reverse brainstorming)
  2. Domain/market research nếu cần
  3. Create product brief
  │
  ▼
nmem_remember:
  - Key decisions + constraints (type=decision, priority=7)
  - Requirements discovered (type=fact, priority=6)
  - User preferences (type=preference, priority=8)
  │
  ▼
Save: _bmad-output/product-brief.md
```

**Lý do Mai trực tiếp:** Mary cần interactive conversation liên tục với Tyler. Dispatch worker rồi relay = chậm và mất nuance.

### Phase 2: Planning (Partial parallel)

```
Mai: dispatch Worker 1 (John → PRD)
  │
  ▼
John viết PRD:
  1. nmem_recall(product brief, requirements)
  2. Feature list + user stories (viết trước)
  3. nmem_remember(feature scope)  ← trigger cho Sally
  4. NFRs, constraints, success metrics (tiếp tục)
  │
  ├── Khi feature scope ready ──▶ Mai dispatch Worker 2 (Sally → UX)
  │                                Sally: nmem_recall(feature scope) → UX design
  │
  ▼
Cả 2 xong:
  Mai cross-verify PRD ↔ UX alignment
  Save: _bmad-output/PRD.md + _bmad-output/ux-spec.md
```

**Skip UX khi:** Backend API, CLI tool, infrastructure work. Mai tự assess.

**Timing:** John ~5-8 min. Sally starts after ~2-3 min (khi feature list done). Total ~6-8 min thay vì ~10-13 min sequential.

### Phase 3: Solutioning (Partial parallel — Architecture leads)

BMAD's workflow map specifies architecture BEFORE stories — story decomposition depends on component boundaries, API contracts, and DB schema. Full parallel ở đây sẽ gây structural misalignment.

```
PRD + Brief đã xong (trong brain + files)
  │
  ▼
Worker 1 (Winston → Architecture)
  Input: PRD + Brief (từ brain + files)
  Output: architecture.md + ADRs
  nmem_remember: tech decisions, component boundaries, patterns, standards
  │
  ├── Khi component breakdown + key ADRs xong → nmem_remember
  │   → touch signals/w1.arch-ready
  │
  ▼ Mai detect signal → dispatch John
  │
Worker 2 (John → Epics & Stories)
  Input: PRD + Brief + Architecture decisions (từ brain)
  Output: epics/*.md với stories
  nmem_remember: story breakdown, dependencies
  │
  ▼ (Winston có thể tiếp tục refine architecture details song song)
  │
  ▼ (cả 2 xong)
  │
  ▼
Worker 3 (Winston → Implementation Readiness Check)
  Input: architecture + epics + brain
  Cross-verify:
    - Stories align với architecture decisions?
    - Tech stack consistent across stories?
    - No conflicting ADRs?
  Output: PASS / CONCERNS / FAIL
  │
  ├── PASS → Dispatch Paige → generate project-context.md → Phase 4
  ├── CONCERNS → Mai fix specific issues → re-check
  └── FAIL → Mai re-dispatch Winston hoặc John với feedback
```

**Partial parallel benefit:** Winston starts first, nhưng John bắt đầu khi arch foundations ready (không cần đợi full architecture.md). Winston tiếp tục refine details song song với John. Tiết kiệm ~30-40% time so với full sequential, không có structural risk.

**project-context.md generation:** Sau Readiness PASS, Paige (Tech Writer) generate từ architecture + PRD + brain. Đây là constitution cho Phase 4 workers. Trong Orchestra, project-context.md + shared brain cùng serve role này.

### Phase 4: Implementation (Sprint cycle)

#### Sprint Planning (1 lần per project)

```
Bob (Worker 1): bmad-sprint-planning
  Input: epics + stories + architecture
  Output: sprint-status.yaml
  nmem_remember: sprint scope, story sequence, priorities
```

#### Per Story Build Cycle

```
Step 1: Create Story Context
  Bob (Worker 1): bmad-create-story
    Input: epic + story ID + architecture + brain
    Output: implementation_artifacts/{story_key}.md
      - Story requirements + acceptance criteria
      - Developer context (tech reqs, architecture compliance)
      - Previous story intelligence (từ brain — auto)
    nmem_remember: story context, developer notes

Step 2: Development
  Amelia (Worker 1 or 2): bmad-dev-story
    Input: story file + architecture + project-context.md + brain
    Process: Red-Green-Refactor
      1. Write FAILING tests (Red) ← mandatory
      2. Implement minimal code to pass (Green)
      3. Refactor for clarity
    Rules:
      - NEVER mark complete unless tests exist AND pass 100%
      - NEVER skip or reorder steps
      - HALT on: 3 consecutive failures, missing config, regressions
    Output: working code + tests
    nmem_remember: implementation decisions, patterns discovered
    Update: sprint-status.yaml → in-progress → review

Step 3: Code Review (flexible allocation)
  Security/auth/payment story:
    Worker 1: Blind Hunter (diff ONLY, no context)
    Worker 2: Edge Case Hunter (every branching path)
    Worker 3: Acceptance Auditor (diff vs story acceptance criteria)

  Large story (>3 files / >200 LOC):
    Worker 1: Blind Hunter
    Worker 2: Acceptance Auditor

  Small story:
    Worker 1: cycle all 3 perspectives sequentially

  Finding classification: intent_gap, bad_spec, patch, defer, reject
  Rule: zero findings from ANY reviewer = HALT + Mai re-evaluate
    - Check reviewer output length + specificity
    - Suspiciously short/generic review = reviewer malfunction → re-dispatch
    - Genuine zero (after re-eval) = rare, proceed with caution

  PASS → story done, update sprint-status.yaml → done
  FAIL → re-dispatch Amelia với findings (max 3 retries)
  After 3 failed retries → Mai escalate to Tyler với summary of persistent issues

Step 4: Test Generation (per epic, after all stories done)
  Quinn (Worker 1): bmad-qa-generate-e2e-tests
    Input: all completed stories in epic + architecture + brain
    Output: API + E2E tests (khác với unit tests của Amelia)
    nmem_remember: test coverage gaps, integration patterns
    Note: Amelia viết unit/integration tests (Red-Green-Refactor).
          Quinn viết API + E2E tests — different concern, per BMAD design.

Step 5: Retrospective (per epic, not per story)
  Bob (Worker 1): bmad-retrospective
    Input: all completed stories in epic + brain
    Output: lessons learned
    nmem_remember: patterns, anti-patterns, process improvements
    → lessons apply cho next epic automatically via brain
```

#### Course Correction (khi cần, any time trong Phase 4)

Trigger conditions:
- Tyler thay đổi requirements mid-sprint
- Technical blocker buộc phải re-plan
- Story phát hiện architecture gap

```
Mai detect trigger (Tyler feedback / worker HALT / brain conflict)
  │
  ▼
Dispatch Worker (John hoặc Bob): bmad-correct-course
  Input: current sprint-status.yaml + change request + brain
  Output:
    - Updated stories (nếu scope change)
    - Updated sprint-status.yaml
    - Notification cho in-progress workers
  │
  ▼
Mai propagate changes:
  - Nếu Amelia đang dev story bị affected → signal stop + re-dispatch với updated story
  - Nếu story chưa started → update story file trực tiếp
  - nmem_remember course correction reason + impact
```

### Quick Flow (Parallel track)

Cho bug fixes, small changes, refactoring. Skip phases 1-3.

```
Mai assess: < 3 files changed, single component, no new architecture decisions?
  │
  ├── YES → Quick Flow
  │    Barry (Worker 1): bmad-quick-spec → tech-spec
  │    Barry (Worker 1 or 2): bmad-quick-dev → implement + self-audit
  │    Nếu scope grows → escalate to full cycle
  │
  └── NO → Full BMAD cycle (phases 1-4)
```

## Architecture: Shared Brain thay thế project-context.md

BMAD dùng `project-context.md` làm constitution — static file, load vào mỗi workflow.

Orchestra dùng **shared brain** (NeuralMemory) + `project-context.md`:
- `project-context.md` vẫn generate (cho compatibility + human readable)
- Shared brain chứa semantic version — workers `nmem_recall` chỉ lấy context liên quan
- Brain có "previous story intelligence" tự nhiên — worker trước remember → worker sau recall
- Brain có temporal context — biết decision nào mới nhất nếu có conflict

```
BMAD gốc:                          Orchestra-BMAD:
project-context.md (static)    →   project-context.md (backup)
                                   + shared brain (primary, semantic)
                                   + filesystem bus (task dispatch)
```

## Directory Structure

```
~/.claude/
├── agents/                     # Agent personas
│   ├── mary-analyst.md
│   ├── john-pm.md
│   ├── winston-architect.md
│   ├── bob-sm.md
│   ├── amelia-dev.md
│   ├── sally-ux.md
│   ├── quinn-qa.md
│   ├── barry-quickflow.md
│   ├── paige-tech-writer.md
│   └── (existing agents remain)
├── orchestra/                  # Filesystem bus
│   ├── tasks/                  # Mai writes, workers read
│   ├── results/                # Workers write, Mai reads
│   └── signals/                # Workers touch *.done
└── skills/
    └── bmad-method-reference/  # BMAD docs (already exists)

<project>/
├── _bmad-output/               # BMAD document chain
│   ├── product-brief.md        # Phase 1 output
│   ├── PRD.md                  # Phase 2 output
│   ├── ux-spec.md              # Phase 2 output (optional)
│   ├── architecture.md         # Phase 3 output
│   ├── project-context.md      # Generated after Phase 3
│   └── epics/                  # Phase 3 output
│       ├── epic-1.md
│       └── epic-2.md
├── implementation_artifacts/   # Phase 4 story files
│   ├── story-1-1.md
│   └── story-1-2.md
└── sprint-status.yaml          # Sprint tracking
```

## Task File Format (Filesystem Bus)

Mai writes task files cho workers:

```markdown
# ~/.claude/orchestra/tasks/w1.md

## Identity
Đọc và follow persona từ: ~/.claude/agents/john-pm.md

## Phase
Phase 2: Planning

## Workflow
bmad-create-prd

## Input
- Product brief: _bmad-output/product-brief.md
- Brain context: nmem_recall("product requirements, user needs, constraints")

## Output
- File: _bmad-output/PRD.md
- Brain: nmem_remember PRD highlights, feature scope, NFRs

## Scope
CHỈ tạo/sửa: _bmad-output/PRD.md

## Khi xong
1. nmem_remember(type="decision", content="PRD key decisions...")
2. Ghi summary vào ~/.claude/orchestra/results/w1.md
3. touch ~/.claude/orchestra/signals/w1.done
```

## Mai's Dispatch Logic

```
Tyler request arrives
  │
  ▼
Mai assess scope:
  ├── Bug fix / small change → Quick Flow (Barry)
  └── Feature / product → Full BMAD cycle
        │
        ▼
      Phase 1: Mai as Mary (interactive brainstorm)
        │ output: product-brief.md + brain
        ▼
      Phase 2: dispatch John (PRD) → then Sally (UX) partial parallel
        │ output: PRD.md + ux-spec.md + brain
        ▼
      Phase 3: Winston (arch) → John (stories) partial parallel → Readiness Check → Paige (project-context)
        │ output: architecture.md + epics/ + project-context.md
        ├── PASS → Phase 4
        ├── CONCERNS → fix → re-check
        └── FAIL → re-dispatch
        ▼
      Phase 4: Sprint cycle
        Per story: Bob create → Amelia dev → Review (flexible) → next
        Per epic: Quinn (E2E tests) → Bob retrospective
        Mid-sprint: Course Correction nếu cần
        │
        ▼
      Done: Mai report to Tyler
```

## Sprint Status Ownership

`sprint-status.yaml` is single-writer: chỉ Mai hoặc Bob (được Mai delegate) update.

Workers KHÔNG trực tiếp sửa sprint-status.yaml. Thay vào đó:
- Worker signal status change qua brain: `nmem_remember("story X status: review", type="context")`
- Worker touch signal file: `signals/w1.done`
- Mai poll signals + brain → update sprint-status.yaml

Lý do: Tránh concurrent write conflicts trên 1 file YAML. Brain handles concurrent writes OK (SQLite WAL), YAML file không.

**Sprint status reporting:**
- Mai tự track qua sprint-status.yaml + brain
- Tyler hỏi "tiến độ?" → Mai đọc sprint-status.yaml + nmem_recall recent progress → báo cáo

## Signal Mechanisms

Partial parallel coordination dùng signal files (simple, reliable):

```
Phase 2: John touch signals/w1.feature-scope-ready → Mai poll → dispatch Sally
Phase 3: Winston touch signals/w1.arch-ready → Mai poll → dispatch John
Phase 4: Workers touch signals/wN.done → Mai poll → next step
```

Mai poll interval: check signals mỗi 10 giây. Timeout per phase:
- Phase 2 worker: 15 min max
- Phase 3 worker: 20 min max
- Phase 4 dev worker: 30 min max
- Phase 4 review worker: 10 min max

Timeout → Mai kill worker + re-assess (re-dispatch hoặc escalate).

## Error Handling

### Worker failures

| Failure | Detection | Recovery |
|---------|-----------|----------|
| Worker crash (pane dies) | tmux pane missing | Re-spawn worker + re-dispatch same task |
| Worker hang (no signal) | Timeout exceeded | Kill worker + re-dispatch (max 2 retries) |
| MCP plugin fail (REG-004) | Worker reports no nmem tools | Kill + re-spawn with plugin verification |
| Worker ignores scope | Mai checks files modified vs scope | Reject results + re-dispatch with stricter scope warning |
| Worker produces garbage | Mai reviews results quality | Re-dispatch with clearer instructions, or do manually |
| Brain write conflict | 2 workers remember contradictory decisions | Mai detect via nmem_recall → resolve manually, nmem_edit winner |

### Escalation ladder

```
Auto-retry (same task, fresh worker) → 2 attempts max
  ↓ still fails
Fallback to sequential (1 worker at a time)
  ↓ still fails
Mai does it directly (no worker)
  ↓ still fails
Escalate to Tyler
```

## Brain Scoping (Cross-project isolation)

Shared brain `NMEM_BRAIN=bemai` serves all projects. To prevent cross-contamination:

1. **Tagging convention:** Every nmem_remember MUST include project name in tags: `tags=["project-name", "phase", "topic"]`
2. **Recall convention:** Every nmem_recall MUST include project name in query: `nmem_recall("project-name: topic")`
3. **Project context in content:** Memory content should reference project: "Trong project X, quyết định dùng Y vì Z"

Lý do: NeuralMemory semantic search tự nhiên filter khi project name có trong cả memory và query. Không cần technical isolation — convention đủ.

## Document Versioning

`_bmad-output/` documents are versioned via git commits:

- Mỗi phase gate (end of Phase 1, 2, 3) → git commit với message: `"[orchestra-bmad] Phase N complete: <summary>"`
- Readiness Check FAIL → trước khi re-dispatch, current state đã committed → safe to overwrite
- Rollback = `git checkout` phase commit nếu cần

Không dùng file versioning (v1, v2...) — git history đủ và sạch hơn.

## Quality Gates (từ BMAD, adapted)

| Gate | When | Who | Rule |
|------|------|-----|------|
| PRD Validation | End Phase 2 | Mai | PRD covers all brief requirements? |
| Readiness Check | End Phase 3 | Winston (worker) | Architecture ↔ Stories aligned? PASS/CONCERNS/FAIL |
| Code Review | Per story Phase 4 | 1-3 reviewers (flexible) | Zero findings = HALT. Adversarial mandatory |
| E2E Test Generation | Per epic Phase 4 | Quinn (worker) | API + E2E tests pass? Coverage adequate? |
| Retrospective | Per epic | Bob (worker) | Lessons → brain → apply next epic |

## Constraints & Limitations

1. **SQLite concurrent writes** — WAL mode tested OK with 2 writers. 3+ concurrent cần verify khi build. Mitigation: Phase 3 max 2 parallel writers + 1 reader.
2. **Rate limits** — 4 concurrent Claude sessions cần Max plan. Monitor token usage.
3. **tmux send-keys** — Special characters fragile. File-based dispatch (task files) là primary mechanism.
4. **Worker startup overhead** — ~10-15 sec per fresh session (plugin load, MCP init, persona load). Acceptable vì tasks run minutes, not seconds.
5. **Brain as project-context.md replacement** — Semantic search powerful nhưng không guarantee deterministic results. Keep project-context.md file as human-readable backup.

## What This Framework Does NOT Change

- Orchestra Model v2 architecture (tmux layout, shared brain, filesystem bus) — unchanged
- Existing technical agents (python-pro, postgres-pro, etc.) — still available, used when BMAD agents need specialist help
- Mai's role as CEO/orchestrator — enhanced with BMAD workflow knowledge
- NeuralMemory usage patterns — same shared brain, more structured content

## Implementation Priority

1. **Create BMAD agent persona files** — 9 .md files in ~/.claude/agents/ (including Paige)
2. **Create _bmad-output/ directory structure** — template cho projects
3. **Update WORKER-CLAUDE.md** — add BMAD workflow awareness + brain scoping convention
4. **Create dispatch templates** — task file templates per phase/workflow
5. **Create signal + timeout infrastructure** — polling script, timeout handling
6. **Test Phase 4 cycle** — 1 story end-to-end (create → dev → review → Quinn tests)
7. **Test Phase 3 partial parallel** — Architecture → Stories → Readiness Check
8. **Test course correction** — simulate mid-sprint scope change
9. **Test error recovery** — simulate worker crash + hang
10. **Test full cycle** — Phase 1→4 on a real feature
