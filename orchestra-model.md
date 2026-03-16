# Orchestra Model v2 — Mai's Company

## Overview

Multi-agent system: Mai (CEO/Opus) điều phối workers (Sonnet) qua 2 communication layers:
- **Shared Brain** (Shared Brain (NMEM_BRAIN env var)) — real-time memory sharing, tất cả agents đọc/ghi cùng 1 brain
- **Filesystem Bus** — task dispatch, signals, scope control, structured results

## Architecture

```
                         ╔═══════════════════════╗
                         ║    TYLER (End User)    ║
                         ║  Chỉ nói với Mai       ║
                         ╚═══════════╤═══════════╝
                                     │
                                     ▼
              ┌──────────────────────────────────────────┐
              │              MAI (CEO / Opus)             │
              │                                          │
              │  ┌────────────┐ ┌──────────┐ ┌────────┐ │
              │  │  Dispatch  │ │  Agent   │ │Quality │ │
              │  │  Engine    │ │ Registry │ │ Gates  │ │
              │  └────────────┘ └──────────┘ └────────┘ │
              └────────┬─────────────┬───────────────────┘
                       │             │
          ┌────────────▼──┐  ┌───────▼────────────┐
          │ Filesystem Bus│  │ Shared Brain        │
          │               │  │  NMEM_BRAIN=bemai   │
          │ tasks/*.md    │  │                     │
          │ results/*.md  │  │  Direct SQLite      │
          │ signals/*.done│  │  No server needed   │
          │               │  │                     │
          │ WHO does WHAT │  │  WHY + WHAT we KNOW │
          └──────┬────────┘  └──────┬──────────────┘
                 │                  │
    ┌────────────┴──────────────────┴────────────────┐
    │              TMUX WORKER PANES                  │
    │                                                 │
    │  ┌───────────┐ ┌───────────┐ ┌───────────┐    │
    │  │ Worker 1  │ │ Worker 2  │ │ Worker 3  │    │
    │  │ (Sonnet)  │ │ (Sonnet)  │ │ (Sonnet)  │    │
    │  │           │ │           │ │           │    │
    │  │ Reads:    │ │ Reads:    │ │ Reads:    │    │
    │  │ · task    │ │ · task    │ │ · task    │    │
    │  │ · brain   │ │ · brain   │ │ · brain   │    │
    │  │           │ │           │ │           │    │
    │  │ Writes:   │ │ Writes:   │ │ Writes:   │    │
    │  │ · results │ │ · results │ │ · results │    │
    │  │ · brain   │ │ · brain   │ │ · brain   │    │
    │  │ · signal  │ │ · signal  │ │ · signal  │    │
    │  └───────────┘ └───────────┘ └───────────┘    │
    └────────────────────────────────────────────────┘
```

## Communication Layers

### Layer 1: Shared Brain (NMEM_BRAIN env var)
- Tất cả sessions set `NMEM_BRAIN=bemai` → đọc/ghi cùng 1 SQLite database trực tiếp
- KHÔNG cần server — SQLite WAL mode handle concurrent writes (tested OK)
- Mỗi worker .mcp.json: `"env": { "NMEM_BRAIN": "bemai" }`
- Real-time: worker remember → Mai recall thấy ngay (cùng database file)
- Workers tự recall decisions cũ trước khi làm task
- Workers tự remember decisions mới khi xong
- Docs NeuralMemory: "multiple agents simultaneously PHẢI dùng NMEM_BRAIN env var"

### Layer 2: Filesystem Bus (Dispatch Protocol)
- tasks/*.md — Mai ghi task assignment (agent persona, scope, constraints)
- results/*.md — Workers ghi structured output
- signals/*.done — Workers touch khi xong, Mai poll
- Scope control — mỗi worker chỉ sửa files trong scope được giao

### Phân chia rõ:
| Filesystem Bus | Shared Brain |
|---|---|
| WHO does WHAT (dispatch) | WHY + WHAT we KNOW (memory) |
| Task-scoped, ephemeral | Persistent, cross-session |
| Structured I/O format | Semantic, searchable |
| Scope enforcement | Knowledge sharing |

## Agent Registry — Open Pool

13 agents hiện tại trong ~/.claude/agents/, expandable bất cứ lúc nào.

### Engineering
- backend-architect — API, microservices, DB schema
- software-architect — System design, ADR, trade-offs
- python-pro — Python/FastAPI/async/pytest specialist
- rapid-prototyper — MVP nhanh 3 ngày
- devops-automator — CI/CD, IaC, monitoring
- mcp-developer — Build MCP servers

### Database
- database-optimizer — DB tuning general
- postgres-pro — PostgreSQL deep (WAL, pgvector, replication)

### Quality & Security
- code-reviewer — Review 3 tiers (blockers/suggestions/nits)
- security-engineer — Threat modeling, OWASP, STRIDE
- reality-checker — Quality gate cuối, default "NEEDS WORK"
- performance-benchmarker — Load test k6, Core Web Vitals

### Orchestration
- agents-orchestrator — Pipeline orchestration patterns

### Agent Sources (thêm agents khi cần)
| Source | Stars | Agents | Đặc điểm |
|---|---|---|---|
| agency-agents (msitarzewski) | 47k | 100+ | Content sâu, code examples, deliverable templates — PRIMARY |
| VoltAgent | 14k | 127+ | Tools/model spec, language specialists — SUPPLEMENT |
| Custom | — | unlimited | Tự tạo .md cho domain riêng |

Thêm agent = drop file .md vào ~/.claude/agents/. Không cần restart, không cần config.

## Claude Code Session — Worker Setup

### Mỗi worker pane là 1 Claude Code session riêng:
- Chạy: `claude --dangerously-skip-permissions`
- Project dir: cùng project với Mai
- Neural-memory plugin: enabled → có nmem_* MCP tools
- Shared mode: `nmem shared enable http://localhost:8000` → đọc/ghi cùng brain

### Agent persona load vào worker:
Em ghi task file có luôn agent identity:
```markdown
# ~/.claude/orchestra/tasks/w1.md
## Identity
Đọc và follow persona từ: ~/.claude/agents/python-pro.md
## Project
/home/toanvous/bemai-learning
## Task
Implement GET /api/topics endpoint...
## Scope
CHỈ sửa: routers/topics.py, tests/routers/test_topics.py
## Khi xong
1. nmem_remember decisions + results summary
2. Ghi summary vào ~/.claude/orchestra/results/w1.md
3. touch ~/.claude/orchestra/signals/w1.done
```

### WORKER-CLAUDE.md — Protocol cho workers:
```markdown
Bạn là worker trong Orchestra system.
1. Khi nhận task, đọc task file được chỉ định
2. Đọc agent persona file trong task
3. nmem_recall brain để lấy context + decisions cũ
4. CHỈ sửa files trong scope được giao
5. Khi xong: nmem_remember decisions + ghi results + touch signal
6. KHÔNG sửa files ngoài scope
7. KHÔNG tự ý liên lạc worker khác
```

## Memory Architecture (3 layers)

```
┌─────────────────────────────────────────────┐
│ Layer 1: Shared Brain (NMEM_BRAIN env var)  │
│                                             │
│  Mai remember ←→ Workers remember           │
│  Mai recall   ←→ Workers recall             │
│  Real-time, persistent, semantic search     │
│  All agents see same brain via SQLite       │
│                                             │
│  NMEM_BRAIN=bemai (no server needed)        │
│  .mcp.json env var per worker session       │
│  SQLite WAL = concurrent writes OK          │
└──────────────────────┬──────────────────────┘
                       │
┌──────────────────────▼──────────────────────┐
│ Layer 2: Filesystem (task-scoped)           │
│                                             │
│  tasks/*.md   — structured task input       │
│  results/*.md — structured task output      │
│  signals/     — completion notifications    │
│  Ephemeral, per-task, enforces scope        │
└──────────────────────┬──────────────────────┘
                       │
┌──────────────────────▼──────────────────────┐
│ Layer 3: CLAUDE.md + Agent Personas         │
│                                             │
│  WORKER-CLAUDE.md — worker protocol         │
│  ~/.claude/agents/*.md — agent expertise    │
│  Static, loaded at session start            │
└─────────────────────────────────────────────┘
```

### Memory Flow cụ thể:
```
Tyler: "build topic API"
  │
  ▼
Mai: nmem_recall("topic API, FastAPI patterns")
  │   → memories: "async SQLAlchemy", "Pydantic v2", "router pattern health.py"
  │
  ▼
Mai: ghi tasks/w1.md + tasks/w2.md (scope riêng mỗi worker)
  │
  ▼
Workers đọc task → nmem_recall brain → làm task → nmem_remember decisions
  │   (workers đọc/ghi trực tiếp vào shared brain, không qua Mai)
  │
  ▼
Workers xong → ghi results + signal
  │
  ▼
Mai: đọc results + nmem_recall workers' new memories → quality gate → report
  │   nmem_remember tóm tắt kết quả cuối
```

## Dispatch Flow

```
Tyler ──"build topic API"──▶ Mai
                               │
                               ├─ nmem_recall("topic API, FastAPI patterns")
                               ├─ Check Agent Registry → python-pro + postgres-pro + code-reviewer
                               │
                               ├─ Write tasks/w1.md → @python-pro (scope: routers/, tests/)
                               ├─ Write tasks/w2.md → @postgres-pro (scope: migrations/, models.py)
                               ├─ tmux send-keys %2 + %3
                               │
                               ▼
                        Workers chạy parallel
                        Mỗi worker:
                          1. Đọc task file
                          2. nmem_recall brain cho context
                          3. Làm task trong scope
                          4. nmem_remember decisions
                          5. Ghi results/*.md
                          6. touch signals/*.done
                               │
                               ▼
                        Mai poll signals → all done
                               │
                               ├─ Đọc results
                               ├─ nmem_recall workers' new memories
                               ├─ Dispatch @code-reviewer → Worker 3
                               │
                               ▼
                        Review cycle (max 3 retries)
                               │
                               ├─ PASS → merge, nmem_remember, update TASKS.md
                               └─ FAIL → re-dispatch worker với feedback
```

## Dynamic Teams — Không preset cứng

Mai tự chọn team dựa trên task:
- "build API" → python-pro + postgres-pro + code-reviewer
- "security audit" → security-engineer + code-reviewer
- "research repos" → 3 research workers
- "performance test" → performance-benchmarker + devops-automator
- Số workers cũng dynamic: 1, 2, hoặc 3 tùy task

Shortcut scripts có sẵn nhưng Mai có thể compose team tự do.

## TMUX Layout

```
┌────────────────────┬────────────────────┬──────────────────┐
│     PANE %0        │     PANE %2        │                  │
│                    │                    │    PANE %1        │
│  MAI (Opus)        │  Worker 1          │                  │
│  CEO/Orchestrator  │  (rotatable)       │    PREVIEW       │
│                    │                    │                  │
│  · Tyler talks here│                    │  Any agent push  │
│  · Dispatch engine │                    │  files here      │
│  · Quality gates   │                    │                  │
├────────────────────┼────────────────────┤  .md .pdf .docx  │
│     PANE %3        │     PANE %4        │                  │
│                    │                    │                  │
│  Worker 2          │  Worker 3          │                  │
│  (rotatable)       │  (rotatable)       │                  │
│                    │                    │                  │
└────────────────────┴────────────────────┴──────────────────┘
      LEFT (60%) — Interactive              RIGHT (40%) — View
```

## Setup Requirements

1. **Shared Brain**: Mỗi worker .mcp.json set `"env": { "NMEM_BRAIN": "bemai" }` → cùng SQLite database, no server
2. **Orchestra Directory**: `~/.claude/orchestra/` — tasks/, results/, signals/
3. **Worker Config**: WORKER-CLAUDE.md protocol + neural-memory plugin per worker
4. **tmux-work script**: Launch script tạo layout + start Claude Code sessions
5. **Agent Registry**: ~/.claude/agents/*.md — 13 agents hiện tại, expandable

## Strengths
- True parallelism — 4 API streams đồng thời, tổng 4M context
- Shared brain — workers đọc/ghi memory real-time, không cần file trung gian
- Fault isolation — 1 worker crash không ảnh hưởng others
- Context isolation — mỗi worker fresh context, không bị degradation
- Dynamic teams — Mai tự compose team theo task
- Expandable — thêm agents bất cứ lúc nào từ 200+ sources
- Anh hands-off — chỉ nói với Mai, Mai tự điều phối

## Limitations
- Workers cần neural-memory plugin — phải verify MCP tools load đúng (REG-004)
- Tmux send-keys fragile — special characters có thể lỗi, dùng file-based dispatch
- Shared brain concurrent writes — SQLite WAL tested OK với 2 writers, chưa test 4 concurrent (cần verify khi build)
- Rate limit — Max x20 plan đủ, nhưng cần test 4 concurrent sessions thực tế
