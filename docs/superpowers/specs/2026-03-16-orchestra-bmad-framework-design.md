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

Mỗi **dispatch** = 1 fresh worker session. Knowledge persist qua shared brain (NMEM_BRAIN=bemai).

Worker lifecycle:
```
Spawn → load persona → nmem_recall context → execute task → nmem_remember results → signal done → die
```

"Fresh" = fresh context window (không có context từ task trước). KHÔNG = fresh knowledge (brain recall mang lại decisions/lessons từ trước). Xem "Fresh Session vs Brain Bridge Clarification" section.

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
  ├── CONCERNS → Mai fix specific issues → re-check (max 2 lần, sau đó escalate to FAIL)
  └── FAIL → Mai re-dispatch Winston hoặc John với feedback
```

**Partial parallel benefit:** Winston starts first, nhưng John bắt đầu khi arch foundations ready (không cần đợi full architecture.md). Winston tiếp tục refine details song song với John. Tiết kiệm ~30-40% time so với full sequential, không có structural risk.

**Paige generate project-context.md (sau Readiness PASS):**
```
Paige (Worker): bmad-generate-project-context
  Input: architecture.md + PRD.md + brain recall (decisions + ADRs)
  Output: _bmad-output/project-context.md
    - Technology stack + versions
    - Critical implementation rules
    - Code organization conventions
    - Testing patterns
    - Framework-specific patterns
  Scope: READ architecture.md, PRD.md, brain. WRITE project-context.md only.
  Signal: touch signals/paige.done
```

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
  (Review retries supersede general escalation ladder — go straight to Tyler, skip sequential/Mai-direct fallbacks)

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

Guard rails:
  - Max 3 course corrections per sprint. After 3rd → Mai warn Tyler: "Sprint đang thrash, cần stabilize requirements trước khi tiếp."
  - Cooldown: minimum 1 story completed giữa 2 corrections (trừ critical blocker)
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
│   ├── checkpoint.yaml         # Current state — resume point
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

## Worker Startup & Persona Loading

### Persona injection mechanism

Worker cần "trở thành" John, Winston, v.v. trước khi làm task. Cách hoạt động:

1. Mai ghi task file vào `tasks/wN.md` (chứa persona path + task details)
2. Mai chạy command trong tmux pane:
   ```bash
   tmux send-keys -t %2 "cat ~/.claude/orchestra/tasks/w1.md | claude --dangerously-skip-permissions -p 'Đọc task trên. Bước 1: đọc file persona được chỉ định trong Identity section và ADOPT persona đó hoàn toàn. Bước 2: follow WORKER-CLAUDE.md protocol. Bước 3: thực hiện task.'" Enter
   ```
3. Worker nhận task content qua stdin → đọc persona file → adopt → execute

**Decision: File-based dispatch (primary)**

tmux send-keys fragile với special characters. Thay vào đó:
1. Mai ghi task file vào `tasks/wN.md`
2. Mai chạy lệnh đơn giản trong tmux pane:
   ```bash
   tmux send-keys -t %2 "claude --dangerously-skip-permissions -p 'Đọc file ~/.claude/orchestra/tasks/w1.md và thực hiện task trong đó. Follow WORKER-CLAUDE.md protocol tại ~/.claude/orchestra/WORKER-CLAUDE.md'" Enter
   ```
3. Worker đọc task file (simple path reference, không pipe content)
4. Prompt ngắn, không special characters, không pipe

Lý do chọn: Tất cả complexity nằm trong task FILE (markdown, safe), không nằm trong shell command (fragile).

### WORKER-CLAUDE.md (updated cho BMAD)

```markdown
# Worker Protocol — Orchestra-BMAD

Bạn là worker trong Orchestra-BMAD system.

## Khi nhận task:
1. Đọc task file được cung cấp
2. Đọc agent persona file trong ## Identity section → ADOPT persona hoàn toàn
3. nmem_recall("[PROJECT] [PHASE]: relevant context") để lấy context
4. CHỈ sửa files trong ## Scope — KHÔNG sửa files ngoài scope
5. KHÔNG tự ý liên lạc worker khác

## Recall format (BẮT BUỘC):
nmem_recall("[project-name] Phase [N]: [specific topic]")
Ví dụ: nmem_recall("bemai-learning Phase 2: user stories, acceptance criteria")

## Khi xong:
1. nmem_remember decisions + findings (include project name in tags) — PostgreSQL handle concurrent writes OK
2. Ghi kết quả chi tiết vào file results được chỉ định (Mai cần để review)
3. touch signal file được chỉ định

## Trước khi ghi brain:
- nmem_recall xem đã có memory tương tự chưa
- Nếu có → nmem_edit (update) thay vì nmem_remember (tạo mới)
- Tránh duplicate memories khi task bị re-dispatch

## Shutdown check:
Trước mỗi bước lớn (trước khi bắt đầu subtask mới, trước khi ghi file output):
- Check: ls ~/.claude/orchestra/signals/shutdown
- Nếu tồn tại → ghi partial results + brain → exit gracefully
- Nếu không → tiếp tục bình thường

## KHÔNG được:
- Sửa files ngoài scope
- Tự ý liên lạc worker khác
- Skip tests trong dev-story (Red phase bắt buộc)
```

### Mai's Signal Polling

Mai cần poll signals trong khi vẫn available cho Tyler. Cơ chế:

**Option A (recommend): Background polling script**
```bash
# ~/claude-signal-monitor.sh
# Chạy bởi Mai hoặc cron mỗi 10 giây
# Check signals/ directory, nếu có .done file → ghi alert vào Mai's tmux pane
```

**Option B: Mai poll thủ công giữa các interaction**
- Sau khi dispatch workers, Mai chạy `ls signals/` định kỳ
- Khi Tyler hỏi gì → Mai xử lý Tyler trước, rồi poll lại
- Đơn giản hơn nhưng chậm hơn nếu Tyler im lặng

**Option C: inotifywait (event-based)**
```bash
inotifywait -m -e create signals/ | while read dir event file; do
  echo "Worker done: $file" >> /tmp/orchestra-signals.log
done
```
Mai check log file thay vì poll directory. Nhanh hơn, không tốn CPU.

**Recommend Option C** — event-based, không miss signal, không tốn CPU polling.

Timeout handling tích hợp vào script: nếu signal không xuất hiện sau N phút → kill worker pane + alert Mai.

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

## Project
bemai-learning (PHẢI dùng trong mọi nmem_recall + nmem_remember)

## Input
- Product brief: _bmad-output/product-brief.md
- Brain context: nmem_recall("bemai-learning Phase 1: product brief, requirements, constraints")

## Output
- File: _bmad-output/PRD.md (CHỈ bạn sở hữu file này trong Phase 2)
- Results: ~/.claude/orchestra/results/w1.md

## Scope
CHỈ tạo/sửa: _bmad-output/PRD.md

## Khi xong
1. nmem_remember(type="decision", tags=["bemai-learning", "phase-2", "prd"], content="PRD key decisions...")
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

Lý do: Tránh concurrent write conflicts trên 1 file YAML. Brain handles concurrent writes OK (PostgreSQL MVCC), YAML file không.

**Sprint status reporting:**
- Mai tự track qua sprint-status.yaml + brain
- Tyler hỏi "tiến độ?" → Mai đọc sprint-status.yaml + nmem_recall recent progress → báo cáo

## Checkpoint & Resume

### Checkpoint file

```yaml
# ~/.claude/orchestra/checkpoint.yaml
# Ghi mỗi khi quy trình chuyển bước. Source of truth cho resume.

project: bemai-learning
phase: 3
phase_name: Solutioning
status: in-progress
started_at: "2026-03-16T14:30:00"
updated_at: "2026-03-16T14:45:00"

# Phase-specific state
phase_state:
  architecture:
    status: done              # pending | in-progress | done | failed
    worker: w1
    output: _bmad-output/architecture.md
    completed_at: "2026-03-16T14:42:00"
  stories:
    status: in-progress
    worker: w2
    output: _bmad-output/epics/
    started_at: "2026-03-16T14:43:00"
  readiness_check:
    status: pending
  project_context:
    status: pending

# Phase 4 specific (khi đang ở Phase 4)
sprint_state:
  current_epic: epic-1
  current_story: story-1-3
  story_step: review         # create | dev | review | test | done
  stories_done: [story-1-1, story-1-2]
  stories_remaining: [story-1-3, story-1-4, story-1-5]
  course_corrections: 0

# Active workers
workers:
  w1: { pane: "%2", status: idle, last_task: architecture }
  w2: { pane: "%3", status: running, task: stories, persona: john-pm }
  w3: { pane: "%4", status: idle }

# Completed phases (audit trail)
completed_phases:
  - { phase: 1, completed_at: "2026-03-16T14:00:00", output: product-brief.md }
  - { phase: 2, completed_at: "2026-03-16T14:25:00", output: [PRD.md, ux-spec.md] }
```

### Khi nào ghi checkpoint

| Event | Ghi checkpoint |
|-------|---------------|
| Phase bắt đầu | phase, status=in-progress |
| Dispatch worker | workers section update |
| Worker xong (signal received) | phase_state item = done |
| Phase hoàn thành | status=done, thêm vào completed_phases |
| Story chuyển step | sprint_state update |
| Course correction | course_corrections++ |
| Tyler nói "dừng" / session end | current state snapshot |
| Error/crash detected | last known state |

### Resume protocol (khi Mai restart)

```
Mai start / restart
  │
  ▼
1. Đọc checkpoint.yaml → biết phase + step hiện tại
  │
  ▼
2. Đọc brain (nmem_recall) → biết decisions đã make
  │
  ▼
3. Verify files → _bmad-output/ documents tồn tại + complete?
  │
  ▼
4. Check workers → tmux list-panes, ai còn sống?
  │
  ├── Workers còn sống + đang chạy → đợi signals
  ├── Workers chết + task chưa xong → re-spawn + re-dispatch
  └── Workers chết + task đã xong (signal exists) → process results
  │
  ▼
5. Resume đúng bước tiếp theo trong checkpoint
  │
  ▼
6. nmem_remember("Session resumed from checkpoint: Phase X, Step Y")
```

### Kịch bản cụ thể

**Tyler nói "mai làm tiếp" giữa Phase 3:**
- Em ghi checkpoint (Phase 3, Winston done, John running)
- Em ghi brain summary
- Mai hôm sau → đọc checkpoint → thấy John chưa xong → check worker pane
- Worker đã chết (session expired) → re-dispatch John với brain context
- John recall brain → có Winston's architecture decisions → tiếp tục

**Em crash giữa Phase 4 review:**
- Keepalive script restart Mai session
- Mai đọc checkpoint → Phase 4, story-1-3, step=review
- Check signals → w1.done + w2.done exist (2 reviewers xong trước crash)
- w3 chưa done → check pane → chết → re-dispatch reviewer thứ 3
- Collect 3 results → continue

**Máy reboot:**
- Checkpoint.yaml + brain + files đều persist trên disk/PostgreSQL
- tmux-work script recreate layout
- Keepalive script restart Mai
- Mai đọc checkpoint → resume

## Signal Mechanisms

Partial parallel coordination dùng signal files (simple, reliable):

```
Phase 2: John touch signals/w1.feature-scope-ready → Mai poll → dispatch Sally
Phase 3: Winston touch signals/w1.arch-ready → Mai poll → dispatch John
Phase 4: Workers touch signals/wN.done → Mai poll → next step
```

Mai poll interval: check signals mỗi 10 giây. Timeout per phase (initial values — tune based on testing):
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
| Brain content conflict | 2 workers remember contradictory decisions | Mai detect via nmem_recall → resolve manually, nmem_edit winner |
| PostgreSQL connection fail | Worker cannot reach DB | Retry 2x → ghi vào results file → Mai ghi brain sau |

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

### Rollback (quay về trạng thái cũ)

**Document rollback:** Git commits tại mỗi phase gate. `git checkout` commit cụ thể nếu cần.

**Story rollback (Amelia code dở, review fail 3 lần):**
```
Mai: git stash hoặc git checkout -- <files trong scope>
  → Revert files về trạng thái trước khi Amelia bắt đầu
  → Re-dispatch Amelia với clearer story + review findings
  → Brain memories từ attempt trước VẪN GIỮ (lessons learned, không xóa)
```

**Phase rollback (Readiness Check FAIL sau 2 CONCERNS):**
```
Mai: git checkout phase-2-complete (tag/commit)
  → Documents revert về end-of-Phase-2 state
  → Re-dispatch Phase 3 từ đầu với adjusted approach
  → Brain memories từ Phase 3 failed attempt vẫn giữ → workers tránh lặp lỗi
```

**Nguyên tắc:** Rollback files, KHÔNG rollback brain. Memories từ attempts thất bại là lessons — giữ để không lặp.

### Idempotency (chạy lại không hỏng)

Khi re-dispatch task (worker crash, retry), worker có thể tạo:
- **Duplicate brain memories** — cùng decision ghi 2 lần
- **Duplicate/conflicting code changes** — file đã sửa 1 phần, worker sửa lại từ đầu

**Giải pháp:**

**Brain idempotency:**
- Worker PHẢI `nmem_recall` trước khi `nmem_remember` — nếu memory tương tự đã tồn tại → skip hoặc update thay vì tạo mới
- WORKER-CLAUDE.md rule: "Trước khi ghi brain, recall xem đã có memory tương tự chưa. Nếu có → nmem_edit thay vì nmem_remember mới"

**Code idempotency:**
- Task file ghi rõ **expected starting state**: "File X hiện có function Y. Nếu function Z đã tồn tại = task đã partially done → continue từ đó"
- Hoặc đơn giản: Mai `git stash/checkout` về clean state trước khi re-dispatch → worker luôn bắt đầu từ trạng thái sạch
- **Recommend:** Git clean state trước re-dispatch — đơn giản, deterministic

### State Consistency (các nguồn truth khớp nhau)

Sau resume, 4 nguồn truth có thể lệch:
1. `checkpoint.yaml` — "John done"
2. Brain — có/không có John's decisions
3. Files — `epics/*.md` tồn tại/thiếu/incomplete
4. `sprint-status.yaml` — story statuses

**Consistency check protocol (chạy khi resume):**
```
Mai resume:
  1. Đọc checkpoint.yaml → expected state
  2. Verify files:
     - checkpoint nói "Phase 2 done" → PRD.md PHẢI tồn tại + non-empty
     - checkpoint nói "story-1-2 done" → implementation file PHẢI tồn tại
     - Nếu file thiếu/empty → đánh dấu inconsistent → re-dispatch step đó
  3. Verify brain:
     - nmem_recall("[project] Phase [N]: key decisions")
     - Nếu brain thiếu decisions mà checkpoint nói đã xong → re-read output files + ghi brain bổ sung
  4. Verify sprint-status.yaml khớp checkpoint sprint_state
     - Nếu lệch → checkpoint.yaml là source of truth → update sprint-status.yaml
```

**Nguyên tắc:** Checkpoint.yaml > sprint-status.yaml > files > brain. Khi conflict, source cao hơn thắng.

### Graceful Shutdown (dừng có trật tự)

**Khi Tyler nói "dừng" / "mai làm tiếp":**
```
Mai:
  1. Ghi checkpoint với current state
  2. Ghi brain summary: nmem_remember("Session paused at Phase X, Step Y. Reason: Tyler requested pause")
  3. Signal workers to wrap up:
     - touch signals/shutdown → workers check signal trước mỗi bước lớn
     - Worker thấy shutdown signal → ghi partial results + brain → exit gracefully
  4. Đợi max 60 giây cho workers wrap up
  5. Kill remaining workers nếu vẫn chạy
  6. Report to Tyler: "Đã dừng tại [phase/step]. Checkpoint saved. Resume bất cứ lúc nào."
```

**WORKER-CLAUDE.md addition:**
```markdown
## Shutdown protocol
Trước mỗi bước lớn (trước khi bắt đầu task mới, trước khi ghi file output):
- Check: ls ~/.claude/orchestra/signals/shutdown
- Nếu tồn tại → ghi partial results + brain → exit
- Nếu không → tiếp tục bình thường
```

**Hard shutdown (crash, kill):**
- Không có graceful wrap-up — checkpoint.yaml có last known state
- Resume protocol handle (đã document ở Checkpoint section)

### Observability (biết đang xảy ra gì)

**Orchestra log file:**
```
~/.claude/orchestra/orchestra.log
```

Mai ghi log mỗi action:
```
[2026-03-16 14:30:00] PHASE_START phase=3 project=bemai-learning
[2026-03-16 14:30:05] DISPATCH worker=w1 persona=winston-architect task=architecture
[2026-03-16 14:42:00] SIGNAL_RECEIVED worker=w1 signal=arch-ready
[2026-03-16 14:42:05] DISPATCH worker=w2 persona=john-pm task=stories
[2026-03-16 14:50:00] SIGNAL_RECEIVED worker=w1 signal=w1.done
[2026-03-16 14:55:00] SIGNAL_RECEIVED worker=w2 signal=w2.done
[2026-03-16 14:55:05] DISPATCH worker=w3 persona=winston-architect task=readiness-check
[2026-03-16 14:58:00] QUALITY_GATE readiness=PASS
[2026-03-16 14:58:00] PHASE_COMPLETE phase=3
```

**Tyler hỏi "tiến độ?":**
Mai đọc checkpoint.yaml + orchestra.log + brain → báo cáo:
- Đang ở phase nào, step nào
- Bao nhiêu stories xong / còn lại
- Workers đang làm gì
- Estimated time (dựa trên log timing của stories trước)

**Health check (systematic, mỗi 5 phút khi có workers running):**
```
Check 1: tmux panes alive? (tmux list-panes)
Check 2: PostgreSQL reachable? (pg_isready)
Check 3: Workers responsive? (signal file age < timeout)
Check 4: Disk space OK? (df check)
→ Nếu bất kỳ check fail → alert Mai → trigger error handling
```

## Brain Scoping (Cross-project isolation)

Shared brain `NMEM_BRAIN=bemai` serves all projects. To prevent cross-contamination:

1. **Tagging convention:** Every nmem_remember MUST include project name in tags: `tags=["project-name", "phase", "topic"]`
2. **Recall convention:** Every nmem_recall MUST include project name in query: `nmem_recall("project-name: topic")`
3. **Project context in content:** Memory content should reference project: "Trong project X, quyết định dùng Y vì Z"

Lý do: NeuralMemory semantic search tự nhiên filter khi project name có trong cả memory và query. Không cần technical isolation — convention đủ.

## Brain Write Strategy (PostgreSQL — concurrent writes OK)

NeuralMemory đã migrate sang PostgreSQL 16.13. MVCC + row-level locking cho phép nhiều writers đồng thời — không còn giới hạn 1 writer.

### Nguyên tắc: Workers tự ghi brain trực tiếp

```
Workers làm task:
  - Đọc brain (nmem_recall) → nhiều người đọc cùng lúc OK
  - Ghi brain (nmem_remember) → nhiều người ghi cùng lúc OK (PostgreSQL MVCC)
  - Ghi kết quả → vào FILE (results/wN.md) cho Mai review
  - Signal done → touch signals/wN.done
```

Workers PHẢI ghi brain trực tiếp khi có:
- Decisions quan trọng (architecture, tech choices, patterns)
- Findings cần workers khác biết (review results, bug discoveries)
- Learnings cần persist (previous story intelligence)

Workers vẫn ghi file results vì:
- Mai cần structured output để review/aggregate
- File dễ đọc hơn brain recall cho quality checks
- Backup nếu brain có vấn đề

### PostgreSQL concurrent capacity

- Connection pool: max 10 concurrent (config)
- Orchestra max 4 sessions (Mai + 3 workers) → well within limits
- Row-level locking: workers ghi khác rows, không block nhau
- MVCC: readers thấy committed data, không bị dirty reads

### Lưu ý: Một số NeuralMemory features chưa migrate sang PostgreSQL

Các tools sau vẫn chạy trên SQLite fallback:
- Cognitive tools (nmem_hypothesize, nmem_schema)
- Sync engine (nmem_sync)
- Review & source registry (nmem_review, nmem_source)
- Hooks, calibration, drift detection

Core operations (remember, recall, pin, forget, edit) đã hoàn toàn trên PostgreSQL — đủ cho Orchestra-BMAD.

## Document Ownership (tránh concurrent file edit)

Mỗi document trong `_bmad-output/` có 1 owner duy nhất tại mỗi thời điểm:

| Document | Owner | Phase | Others |
|----------|-------|-------|--------|
| product-brief.md | Mai (as Mary) | 1 | — |
| PRD.md | John | 2 | Sally read-only |
| ux-spec.md | Sally | 2 | John read-only |
| architecture.md | Winston | 3 | John read-only |
| epics/*.md | John | 3 | Winston read-only |
| project-context.md | Paige | 3 (after readiness) | All read-only |
| sprint-status.yaml | Mai/Bob | 4 | Workers signal via brain/files |
| implementation_artifacts/*.md | Bob (create), Amelia (update) | 4 | Reviewers read-only |

**Rule:** Task file PHẢI ghi rõ "CHỈ bạn sở hữu file X" + "file Y là read-only". Mai verify qua git diff sau mỗi phase — nếu worker sửa file ngoài scope → reject results.

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

1. **PostgreSQL concurrent writes** — NeuralMemory v4.8.0 đã migrate sang PostgreSQL 16.13. MVCC + row-level locking cho phép nhiều writers đồng thời. Connection pool max 10, Orchestra dùng max 4 — không vấn đề. Lưu ý: một số NeuralMemory features (cognitive tools, sync, review) chưa migrate, vẫn fallback SQLite.
2. **Rate limits** — 4 concurrent Claude sessions cần Max plan. Monitor token usage.
3. **tmux send-keys** — Special characters fragile. File-based dispatch (task files) là primary mechanism.
4. **Worker startup overhead** — ~10-15 sec per fresh session (plugin load, MCP init, persona load). Acceptable vì tasks run minutes, not seconds.
5. **Brain as project-context.md replacement** — Semantic search powerful nhưng không guarantee deterministic results. Keep project-context.md file as human-readable backup.

## Open Architecture Decision: Native Agent vs tmux Dispatch

Claude Code có built-in Agent tool — dispatch subagents trực tiếp, không cần tmux.

| | tmux Dispatch (current spec) | Native Agent tool |
|---|---|---|
| Parallelism | True parallel (separate processes) | Parallel nhưng trong Mai's context |
| Shared brain | Mỗi session connect riêng (NMEM_BRAIN env) | Kế thừa Mai's MCP config |
| Context isolation | Hoàn toàn isolated (fresh session) | Subagent có context riêng nhưng không 100% isolated |
| Persona loading | File-based (task file + persona .md) | Prompt-based (Agent tool parameter) |
| Signal/polling | Cần filesystem signals + polling script | Agent tool tự return results |
| Complexity | Cao (tmux, scripts, polling, signals) | Thấp (built-in mechanism) |
| Reliability | tmux send-keys fragile | Built-in, tested |
| Brain write | Mỗi worker ghi brain trực tiếp | Subagent có thể dùng MCP tools |

**Cần test trước khi quyết (pass/fail thresholds):**

| Test | Pass | Fail |
|------|------|------|
| Shared brain access | Worker nmem_recall + nmem_remember thành công, data persist | Worker không có MCP tools hoặc data không persist |
| Persona loading | Worker output confirm persona đúng tên + skills | Worker ignore persona hoặc adopt sai |
| Performance | < 2x slower so với tmux dispatch | > 2x slower |
| Context isolation | Mai's conversation history KHÔNG xuất hiện trong worker context | Worker thấy Mai's prior messages |

**Recommend:** Test cả 2 trong Block 0. Nếu Native Agent pass 4/4 → dùng Native Agent (đơn giản hóa framework). Nếu fail bất kỳ → giữ tmux.

## BMAD Core Tools Integration

11 BMAD core tools — khi nào dùng, ai dùng:

| Tool | Khi nào | Ai | Trong Orchestra |
|------|---------|-----|-----------------|
| `bmad-help` | Agent không biết làm gì tiếp | Any worker | Worker tự invoke nếu stuck |
| `bmad-brainstorming` | Phase 1, hoặc khi cần creative input | Mai (as Mary) | Mai trực tiếp |
| `bmad-party-mode` | Major decisions, retrospectives | Mai | Mai invoke, simulate multi-agent debate |
| `bmad-distillator` | Document > 8000 tokens | Mai | Compress trước khi load vào worker context |
| `bmad-advanced-elicitation` | PRD/architecture shallow | Worker hoặc Mai | Optional, khi output chưa đủ sâu |
| `bmad-review-adversarial-general` | Phase 3 readiness, doc review | Worker | Winston invoke khi review architecture |
| `bmad-review-edge-case-hunter` | Code review (high-risk stories) | Worker | Review worker invoke |
| `bmad-editorial-review-prose` | Phase 2-3 documents | Worker hoặc Mai | Paige invoke trước phase gate |
| `bmad-editorial-review-structure` | Large documents | Mai | Mai invoke nếu doc > 5000 words |
| `bmad-shard-doc` | Architecture doc quá lớn | Mai | Split trước khi dispatch workers |
| `bmad-index-docs` | Project completion | Paige | Auto-generate doc index |

**Auto-trigger rules:**
- Document > 8000 tokens → distillator trước khi load vào worker
- Phase 2-3 docs trước quality gate → editorial review (prose + structure)
- Architecture doc > 5000 words → shard trước khi dispatch Phase 4

## Adversarial Review Discipline (expanded)

BMAD yêu cầu nghiêm khắc hơn spec hiện tại:

**Minimum findings:**
- Mỗi reviewer PHẢI tìm tối thiểu 3 findings (adjusted từ BMAD's 10 cho single-story scope)
- < 3 findings → reviewer chạy pass thứ 2 (mandatory)
- 0 findings → HALT + Mai re-evaluate reviewer quality

**Multi-pass protocol:**
- Pass 1: Tìm obvious issues (logic, security, performance)
- Pass 2 (mandatory nếu < 3 findings): Tìm "what's missing" — gaps, unhandled cases, spec deviations
- Pass 3 (optional): Diminishing returns, chỉ chạy nếu high-risk story

**Finding classification guide:**
| Type | Khi nào | Action |
|------|---------|--------|
| `intent_gap` | Story wording mơ hồ, dev hiểu khác ý PRD | Clarify story → re-dev |
| `bad_spec` | PRD/story thiếu hoặc contradictory | Fix spec → re-dev |
| `patch` | Bug có thể fix tại chỗ | Dev fix |
| `defer` | Valid nhưng out of scope | Log → next sprint |
| `reject` | PHẢI fix trước khi approve | Dev fix, re-review |

**Escalation:** Nếu cùng 1 finding type lặp lại qua 3+ stories → process issue, không phải implementation issue → Mai escalate to Tyler.

## Existing Project Onboarding

Khi Orchestra-BMAD chạy trên project ĐÃ CÓ code:

```
Step 0: Cleanup
  - Archive old _bmad-output/ artifacts (nếu có)
  - Git clean state

Step 1: Early context generation
  - Paige (Worker): bmad-generate-project-context
    Input: existing codebase (scan files, patterns, conventions)
    Output: _bmad-output/project-context.md
  - Chạy TRƯỚC Phase 1 (khác với new project chạy sau Phase 3)

Step 2: Mai assess scope
  - Small change (bug fix, refactor) → Quick Flow (Barry)
  - New feature on existing code → Full cycle, nhưng Phase 2 PRD reference existing architecture
  - Major overhaul → Full cycle from scratch

Step 3: Proceed as normal
  - Phase 1-4 nhưng workers recall existing project-context.md
  - Architecture (Phase 3) là delta, không redesign from scratch
```

**Quick Flow escalation logic:**
- Barry detect scope growth: multi-component mentions, "architecture", "integration", new DB schema → signal Mai
- Light escalation: "Cần quick-spec trước" → Barry viết tech-spec
- Heavy escalation: "Cần full BMAD" → tech-spec carries forward as Phase 2 input
- Carryforward: Quick Flow work không bị mất → trở thành input cho full cycle

## Scale Tracks

| Track | Scope | Phases | Review | Testing |
|-------|-------|--------|--------|---------|
| Quick Flow | < 3 files, 1 component | Skip 1-3 | Barry self-audit + 1 reviewer | Unit tests only |
| Simple | 1-3 epics, < 15 stories | All 4 | 1-2 reviewers | Quinn (E2E) |
| Enterprise | > 3 epics, regulated, compliance | All 4 + TEA | 3 reviewers mandatory | TEA module (9 workflows, ATDD, traceability) |

**Mai auto-detect track:**
- Barry detect Quick Flow thresholds
- Mai assess Simple vs Enterprise: if project has compliance requirements OR > 5 epics → Enterprise track
- Enterprise track adds: TEA module cho test strategy, ATDD (acceptance tests trước code), risk-based P0-P3 prioritization

**TEA module (khi cần):**
- Install separately: `npx bmad-method install` → select TEA
- 9 workflows: test design, ATDD, automate, review, traceability, NFR, CI, scaffolding, release gate
- Quinn đủ cho hầu hết projects. TEA cho regulated/complex domains.

## Brain vs project-context.md Precedence

Khi 2 nguồn nói khác nhau:

```
Brain (real-time decisions) > project-context.md (static baseline) > generic best practices
```

**Ví dụ:** Brain có memory "chuyển từ REST sang GraphQL" (decision mới), project-context.md vẫn ghi "use REST API". → Brain thắng.

**Consistency maintenance:**
- Sau mỗi phase gate, Mai verify brain decisions khớp với documents
- Nếu brain có decision mới mà project-context.md chưa reflect → Paige update project-context.md
- Phase 4 workers load cả 2: project-context.md (baseline) + brain recall (latest decisions)

## Sprint Status Schema

```yaml
# sprint-status.yaml — full schema
project: bemai-learning
sprint: 1
started_at: "2026-03-16T15:00:00"

epics:
  epic-1:
    name: "User Authentication"
    status: in-progress          # backlog | in-progress | done
    stories:
      story-1-1:
        name: "Login page"
        status: done             # backlog | ready-for-dev | in-progress | review | done
        completed_at: "2026-03-16T15:30:00"
        duration_min: 25
      story-1-2:
        name: "Registration"
        status: in-progress
        started_at: "2026-03-16T15:35:00"
      story-1-3:
        name: "Password reset"
        status: backlog
        depends_on: [story-1-1]  # dependency tracking

# State machine transitions (valid):
# backlog → ready-for-dev (Bob creates story)
# ready-for-dev → in-progress (Amelia starts dev)
# in-progress → review (Amelia finishes dev)
# review → done (review PASS)
# review → in-progress (review FAIL → re-dev)

# Velocity tracking (auto-calculated):
velocity:
  stories_per_hour: 2.4
  avg_duration_min: 25
  avg_review_cycles: 1.3
```

**Story parallelization rule:** Chỉ 1 story "in-progress" (dev) tại 1 thời điểm cho mỗi Amelia worker. Review + test có thể parallel nếu nhiều workers.

**Story ordering:** Bob quyết sequence trong sprint-planning. Stories có `depends_on` phải xong dependency trước.

## Tyler Interaction Model (End User Experience)

### Phase Orientation (hiển thị 1 lần khi bắt đầu project)

Khi Tyler nói "build X", Mai giải thích quy trình bằng tiếng Việt đơn giản:

```
Dạ anh, em sẽ build [X] theo quy trình sau:

Bước 1: Nói chuyện (5-10 phút)
  → Em hỏi anh về ý tưởng, ai dùng, giới hạn gì
  → Anh trả lời thoải mái, em ghi nhận hết
  → Em viết bản tóm tắt, anh duyệt

Bước 2: Lên kế hoạch (20-30 phút)
  → Em viết kế hoạch chi tiết (tính năng, giao diện)
  → Anh duyệt kế hoạch

Bước 3: Thiết kế hệ thống (30 phút)
  → Em thiết kế phần kỹ thuật (anh không cần hiểu phần này)
  → Em tự kiểm tra mọi thứ khớp nhau

Bước 4: Xây dựng (tùy số tính năng)
  → Em build từng phần, anh thấy tiến độ liên tục
  → Anh góp ý bất cứ lúc nào

Bắt đầu bước 1 nha anh?
```

### Progress Reporting (khi workers đang chạy)

Mai báo cáo bằng tiếng Việt, không dùng thuật ngữ kỹ thuật:

```
📍 Bước 3: Thiết kế hệ thống
├─ Winston: Đang thiết kế nền tảng kỹ thuật... 70%
└─ John: Đang chia nhỏ công việc... (đợi Winston)

Cập nhật lần cuối: 2 phút trước
Dự kiến xong: ~25 phút nữa

Anh có thể:  /tiendо   /dung   /gopу "thay đổi X"
```

### Translation Dictionary (Mai dùng internally)

| Thuật ngữ kỹ thuật | Mai nói với Tyler |
|---------------------|-------------------|
| PRD | Kế hoạch sản phẩm |
| Architecture | Thiết kế hệ thống |
| ADR | Quyết định kỹ thuật |
| Readiness Check | Kiểm tra: mọi thứ khớp nhau chưa? |
| CONCERNS | Có vài chỗ cần sửa |
| Adversarial review | Nhiều người kiểm tra cùng 1 đoạn code |
| Sprint | Đợt xây dựng |
| Story | 1 phần tính năng nhỏ |
| Epic | 1 nhóm tính năng lớn |
| Code review | Kiểm tra chất lượng code |
| Rollback | Quay lại phiên bản trước |

### Quality Gate Notifications

Khi có vấn đề, Mai giải thích cho Tyler:

```
⚠️  Kiểm tra phát hiện 1 vấn đề nhỏ

Chi tiết: Phần "đăng nhập" và phần "quên mật khẩu" dùng
cách lưu dữ liệu khác nhau — cần thống nhất.

Em đang làm: Sửa cho đồng bộ (~5 phút)
Nếu không sửa được, em hỏi anh.
```

### Error Abstraction

Tyler KHÔNG BAO GIỜ thấy lỗi kỹ thuật. Mai translate:

| Internal error | Tyler thấy |
|---------------|------------|
| PostgreSQL connection fail | "Hệ thống lưu trữ tạm gián đoạn. Em đang retry..." |
| Worker crash | "Nhân viên gặp sự cố. Em cử người khác thay." |
| PostgreSQL connection pool exhausted | (không hiển thị — Mai tự xử lý, retry) |
| Review fail 3x | "Phần này khó hơn dự kiến. Em cần anh góp ý. [options]" |
| Timeout | "Phần này tốn thời gian hơn bình thường. Đợi thêm 5 phút nha anh." |

### Deliverables (khi xong project)

```
✅ [PROJECT NAME] — Hoàn thành!

Anh nhận được:
  📄 Tài liệu (tiếng Việt)
     → Kế hoạch sản phẩm
     → Hướng dẫn sử dụng

  🌐 Ứng dụng
     → Link test: [URL]
     → Anh test thử rồi cho em feedback

  💾 Code
     → Đã push lên GitHub
     → Tất cả tests pass

Bước tiếp:
  1. Test ứng dụng
  2. Góp ý: /gopy "thích X, sửa Y"
  3. Deploy chính thức: /deploy (hoặc hỏi em trước)
```

### Feedback Intake (khi Tyler muốn thay đổi giữa chừng)

```
Tyler: "đổi màu xanh đậm thành xanh nhạt"

Mai:
  Được anh. Em đánh giá ảnh hưởng:

  Thay đổi: Đổi màu xanh đậm → xanh nhạt
  Ảnh hưởng: Chỉ giao diện, không ảnh hưởng logic
  Thời gian thêm: ~2 phút

  Em sửa luôn nha? Hay để sau khi xong phần đang làm?
```

### Multi-project (chuyển project)

```
Tyler: /projects
Mai:
  Các project của anh:
  1. 📍 Learning Hub v2 (đang build, bước 4, xong 8/12 tính năng)
  2. Marketing Site (đang lên kế hoạch, bước 2)

Tyler: /chuyen marketing
Mai: Đã chuyển sang Marketing Site. Lần trước dừng ở bước 2...
```

## Sonnet Worker Context Limits

Workers dùng Sonnet (200K context) — nhỏ hơn Mai (Opus 1M). Cần quản lý context budget:

**Context budget per worker (200K):**
- Persona file: ~2K tokens
- Task file: ~1K tokens
- Brain recall: ~5-10K tokens (limit via max_tokens parameter)
- Project-context.md: ~3K tokens
- Story file: ~5K tokens
- Source code in scope: varies (50-100K)
- Output buffer: ~30-50K tokens

**Mitigation:**
- Distillator compress documents > 8K tokens trước khi load
- Brain recall: set max_tokens=5000 trong task file
- Scope constraint: mỗi worker chỉ đọc files trong scope, không load full codebase
- Nếu story lớn (>100K source code) → split thành sub-tasks

## BMAD Skill Execution Protocol (cross-domain fix: BMAD × Platform)

Workers cần invoke BMAD skills (bmad-create-prd, bmad-dev-story, etc.). Cách hoạt động:

Task file KHÔNG chỉ ghi skill name — phải ghi **full execution instructions**:

```markdown
## Workflow
bmad-create-prd

## Execution
Workers KHÔNG cần BMAD skills installed — follow reference docs manually:
1. Đọc persona file (## Identity) → adopt persona
2. Đọc BMAD workflow reference: ~/.claude/skills/bmad-method-reference/reference-workflow-map.md
   → Tìm section cho workflow được chỉ định (e.g. "bmad-create-prd") → follow step-by-step
3. Input/output theo ## Input và ## Output sections
4. Quality: follow adversarial review discipline (minimum 3 findings nếu review task)

Lý do không install BMAD skills per worker: Worker là fresh session ngắn hạn.
Install skills = overhead không cần thiết. Reference docs đủ để follow workflow.
```

Worker KHÔNG cần biết BMAD internals — task file chứa đủ instructions. Mai responsible cho việc viết task file chính xác.

## Fresh Session vs Brain Bridge Clarification (cross-domain fix: BMAD × Fault tolerance)

"Fresh session" trong Orchestra-BMAD nghĩa là:
- **Fresh context window** — Claude Code session mới, không có context từ task trước
- **KHÔNG fresh knowledge** — worker recall brain để lấy decisions, patterns, lessons từ trước

Khi re-dispatch (sau crash/retry):
- Tạo fresh Claude session (context sạch) ✓
- Worker recall brain (knowledge persist) ✓
- Đây ĐÚNG với BMAD fresh chat spirit — BMAD yêu cầu fresh chat để tránh context pollution, không phải để mất knowledge

## In-flight MCP Transaction Safety (cross-domain fix: Platform × Fault tolerance)

Nếu worker crash giữa lúc đang ghi brain (nmem_remember):
- PostgreSQL: transaction chưa commit → data KHÔNG ghi → safe (không corrupt)
- PostgreSQL: transaction đã commit → data đã ghi → safe (complete)
- Không có trạng thái "half-written" — PostgreSQL atomic transactions đảm bảo

Worker re-dispatch: recall brain → thấy memory đã commit (nếu có) hoặc không thấy (nếu chưa commit) → cả 2 trường hợp đều consistent.

File writes (results/wN.md): có thể bị truncated nếu crash giữa write. Mai verify file completeness trước khi accept results.

## Persona Adoption Verification

Worker PHẢI confirm persona trước khi bắt đầu task:

```
Task file addition:
  ## Persona Confirmation
  Sau khi đọc persona file, output dòng đầu tiên:
  "ADOPTED: [Agent Name] — [Core Skills]"
  Ví dụ: "ADOPTED: John PM — PRD, epics, stories, requirements"
```

Mai verify confirmation trong results file. Nếu thiếu hoặc sai → reject + re-dispatch.

## What This Framework Does NOT Change

- Orchestra Model v2 architecture (tmux layout, shared brain, filesystem bus) — unchanged
- Existing technical agents (python-pro, postgres-pro, etc.) — still available, used when BMAD agents need specialist help
- Mai's role as CEO/orchestrator — enhanced with BMAD workflow knowledge
- NeuralMemory usage patterns — same shared brain, more structured content

## Implementation Priority

### Block 0: Architecture Decision (TRƯỚC HẾT)
0. **Test Native Agent vs tmux dispatch** — chạy cùng 1 task trên cả 2, so sánh: reliability, brain access, persona adoption, performance. Quyết định nền tảng.
1. **Verify Sonnet context limits** — test actual working context cho workers

### Block 0: Architecture Decision (TRƯỚC HẾT)
**Done when:** ADR documented, Sonnet limits measured.
0a. **Test Native Agent vs tmux dispatch** — pass/fail thresholds defined above
0b. **Measure Sonnet context limits** — verify 200K, test with realistic task payload

### Block 1: Worker có thể chạy được (unblock mọi testing)
**Done when:** 1 worker dispatched, executes task with persona, writes brain + results, signals done.

Parallel group (1a, 1d, 1e independent):
1a. **Create 9 BMAD agent persona files** — ~/.claude/agents/
1b. **Update WORKER-CLAUDE.md** — BMAD protocol + brain scoping (depends on 1a)
1c. **Finalize worker startup command** — file-based dispatch (depends on 1a, 1b)
1d. **Create signal polling script** — inotifywait-based + timeout handling
1e. **Create checkpoint system** — checkpoint.yaml format + write/read logic + resume protocol

### Block 2: Framework chạy end-to-end
**Done when:** Full Phase 1→4 on synthetic project completes without manual intervention.
2a. **Create test fixtures** — sample project, synthetic stories (PREREQUISITE for all tests)
2b. **Create observability** — orchestra.log + health check script
2c. **Create _bmad-output/ directory structure** — template cho projects
2d. **Create task file templates** — 1 template per workflow
2e. **Test Phase 4 cycle** — 1 story: Bob create → Amelia dev → Review → Quinn tests
2f. **Test Phase 3 partial parallel** — Winston arch → John stories → Readiness Check → Paige
2g. **Test checkpoint + resume** — simulate crash (kill -9 worker process) mid-Phase 3

### Block 3: Robustness
**Done when:** All recovery scenarios pass, full cycle on real feature succeeds.
3a. **Test course correction** — simulate mid-sprint scope change
3b. **Test error recovery** — simulate worker crash (kill tmux pane) + hang (no signal)
3c. **Test graceful shutdown + resume** — Tyler nói dừng → workers wrap up → resume
3d. **Test rollback** — Readiness Check FAIL → rollback Phase 3 → redo
3e. **Test idempotency** — re-dispatch task → verify no duplicate memories
3f. **Test brain scoping** — verify cross-project isolation with tagged queries
3g. **Test full cycle** — Phase 1→4 on real feature with checkpoint at every phase gate

## Known Gaps & Future Documents

Branching Matrix Analysis (10 domains) phát hiện gaps thuộc phạm vi ngoài design spec. Ghi nhận ở đây, tạo tài liệu riêng khi implement.

### Ops Manual (tạo khi Block 1 xong)

| Gap | Priority | Notes |
|-----|----------|-------|
| Deployment runbook (install from scratch) | Critical | Step-by-step setup guide cho máy mới |
| Backup strategy (brain + files + checkpoint) | Critical | pg_dump schedule, file backup, retention policy |
| Disaster recovery playbook | Critical | Complete system loss → rebuild procedure |
| Upgrade path (Claude Code, NeuralMemory, BMAD versions) | Critical | Version compatibility matrix + migration steps |
| Configuration reference (central config file) | High | Tất cả config values → 1 file ~/.claude/orchestra/config.yaml |
| Dependency manifest (plugin versions, lockfile) | High | Pin versions, rollback nếu break |
| Log management (rotation, retention, cleanup) | Medium | logrotate cho orchestra.log |
| Maintenance coordination (brain consolidation vs active sprint) | Medium | Pause workers during consolidation? |

### Security Playbook (tạo khi Block 2 xong)

| Gap | Priority | Notes |
|-----|----------|-------|
| Secret management | Critical | Credentials KHÔNG được lưu trong brain hoặc plain files. Dùng env vars hoặc vault |
| Worker isolation boundaries | High | tmux panes share user context — accepted risk cho single-user system |
| Brain access control | High | Convention-based (tags) cho giờ. DB-level ACLs khi multi-user |
| Scope enforcement (pre-execution) | High | Hiện tại post-check via git diff. Pre-commit hook nếu cần stricter |
| PostgreSQL hardening | Medium | Auth, password policy, connection limits |
| tmux session security | Medium | Single-user assumed. Multi-user cần separate sessions |
| Code injection prevention | Medium | Task file validation, brain content sanitization |
| Audit trail (granular) | Medium | Hiện có orchestra.log. Cần file-change audit nếu compliance |
| Output sanitization | Low | Worker output có thể chứa PII — Mai review catches |
| Dependency security (plugin vetting) | Low | npm audit, plugin review trước khi enable |

### Cost Model (tạo khi Block 2 xong)

| Gap | Priority | Notes |
|-----|----------|-------|
| Token consumption tracking (per phase, per story, per review) | High | Cần measure thực tế, không estimate |
| Cost per project estimate | High | Token → dollar conversion dựa trên plan type |
| Budget alerts/limits | Medium | Threshold-based alerts khi token spend vượt dự kiến |
| Cost optimization (Sonnet vs Opus vs Haiku selection) | Medium | Decision matrix: task complexity → model choice |
| Infrastructure costs (VPS, PostgreSQL, storage) | Low | Monthly cost breakdown |
| Cost reporting dashboard | Low | Per-project, per-phase cost visibility |

### Test Plan (tạo trước Block 1)

| Gap | Priority | Notes |
|-----|----------|-------|
| Framework acceptance criteria ("done" definition) | Critical | Ship criteria: X stories e2e, Y% resume success, Z uptime |
| Test fixtures (sample project, synthetic stories) | Critical | Cần trước khi test bất kỳ thứ gì |
| Framework unit tests (signal, checkpoint, dispatch) | Critical | Test từng component independently |
| Integration test suite (brain + workers + signals) | Critical | Test components together |
| Performance benchmarks (parallel speedup measured) | High | Verify "30-40% faster" claim |
| Chaos testing (kill workers, corrupt signals, disk full) | High | Edge cases beyond normal error handling |
| Regression test suite (framework changes safe) | Medium | Prevent framework updates breaking workflows |
| Validation methodology (success metrics defined) | Medium | Success rate, cycle time, review pass rate baselines |
| Canary deployment strategy | Low | Test changes on 1 project before rolling out |

### Scaling Roadmap (tạo khi framework stable)

| Gap | Priority | Notes |
|-----|----------|-------|
| Multi-worker scaling (4 → 8 → 16) | High | Connection pool, rate limits, coordination complexity |
| Multi-stakeholder (Tyler + team approval workflow) | High | Async review, multiple approvers, role-based gates |
| Multi-project coordination (2-3 simultaneous) | Medium | Resource contention, Mai's attention split |
| Brain performance at scale (100K+ memories) | Medium | Recall latency, consolidation overhead |
| Longer sprints (multi-week projects) | Medium | Checkpoint state management, context freshness |
| Multi-model selection (Opus/Sonnet/Haiku per task) | Low | Cost vs capability optimization matrix |
| Geographic distribution (remote workers) | Low | Network signals thay filesystem signals |
| Filesystem growth management | Low | Archive old _bmad-output/, disk cleanup |

### Cross-Domain Interactions (45 intersections checked, gaps at intersections)

Full Branching Matrix Analysis: 10 domains × 10 domains = 45 unique pairs checked.
52 cross-domain gaps found. Phần lớn overlap với per-domain gaps. Gaps MỚI chỉ thấy tại giao điểm:

**Critical (design spec cần address):**

| Intersection | Gap | Action |
|---|---|---|
| BMAD × Platform (1×2) | Workers cách invoke BMAD skills | **[RESOLVED]** — Added "BMAD Skill Execution Protocol" section |
| BMAD × Fault tolerance (1×4) | Fresh session vs checkpoint resume | **[RESOLVED]** — Added "Fresh Session vs Brain Bridge Clarification" section |
| BMAD × Security (1×6) | Docs có thể chứa credentials | Security Playbook: document scanning rule trước phase gates |
| Platform × Fault tolerance (2×4) | Worker crash giữa MCP write | **[RESOLVED]** — Added "In-flight MCP Transaction Safety" section |
| Fault tolerance × Security (4×6) | checkpoint.yaml + pg_dump chứa sensitive state | Security Playbook: checkpoint + backup encryption/sanitization |

**High (future documents cần address):**

| Intersection | Gap | Document |
|---|---|---|
| Performance × Cost | Distillator tốn tokens để compress, nhưng tiết kiệm tokens cho workers. ROI chưa tính | Cost Model |
| Performance × Scalability | 4 workers = 30% speedup. 8 workers = ? Có thể nonlinear degradation | Scaling Roadmap |
| Security × Scalability | Multi-user cần DB-level ACLs, không chỉ tags | Scaling Roadmap |
| Testing × Operations | Framework tests cần test environment riêng — separate brain, mock workers | Test Plan |
| Security × Testing | BMAD adversarial review test product logic, KHÔNG test security. Thiếu security review role | Security Playbook |
| Operations × Fault tolerance | Backup schedule vs checkpoint — complementary (backup = disaster, checkpoint = resume) | Ops Manual |
| Cost × Fault tolerance | Recovery cycles burn tokens (re-recall brain). Budget cho retries chưa có | Cost Model |
| BMAD × Operations | BMAD version upgrade có thể break persona format, skill invocation, ADR structure | Ops Manual |
| Platform × Security | --dangerously-skip-permissions = worker có thể rm -rf. Accepted risk cho single-user | Security Playbook |
| UX × Testing | Tyler không có cách verify framework đang follow BMAD discipline. Cần audit trail command | Test Plan |

**Medium/Low (ghi nhận, xử lý khi relevant):**

| Intersection | Gap |
|---|---|
| UX × Cost | Tyler không thấy chi phí — nên hay không? |
| UX × Fault tolerance | Tyler thấy crash trên terminal trước khi Mai kịp giải thích |
| UX × Performance | Estimate sai (nói 25 phút, thực tế 1 giờ) — cần proactive timeout alert |
| BMAD × Performance | Phase nào là bottleneck ở scale 50+ stories? Chưa model |
| BMAD × Scalability | sprint-status.yaml phình to ở 50 stories — cần batching |
| Platform × Cost | Token metering per-worker chưa có — Claude Code không expose usage |
| Platform × Operations | Claude Code auto-update có thể break Orchestra |
| Fault tolerance × Scalability | Checkpoint.yaml phình to — cần update batching |
| Fault tolerance × Performance | Recovery overhead ~20-25 sec/retry, chưa budget vào timing |
| Operations × Cost | Monitoring infrastructure cost chưa tính |
