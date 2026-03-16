# Orchestra-BMAD Framework Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Integrate BMAD Method v6's structured agile workflow (4 phases, adversarial review, document chain) into Orchestra Model v2's parallel execution + shared brain infrastructure.

**Architecture:** BMAD agent personas (Mary, John, Winston, Bob, Amelia, Sally, Quinn, Barry, Paige) dispatch as Orchestra workers via tmux or Native Agent tool. Shared brain (NeuralMemory/PostgreSQL) replaces static project-context.md as primary knowledge store. Filesystem bus (tasks/, results/, signals/) coordinates worker lifecycle. Checkpoint system enables crash recovery.

**Tech Stack:** Claude Code (Opus 4.6 orchestrator, Sonnet workers), NeuralMemory v4.10+ (PostgreSQL 16), tmux, inotifywait, YAML (checkpoint/sprint-status), Bash scripts (signal monitor, health check)

**Spec:** `docs/superpowers/specs/2026-03-16-orchestra-bmad-framework-design.md`

**Existing infrastructure:**
- Orchestra v2: `~/.claude/orchestra/` (WORKER-CLAUDE.md, tasks/, results/, signals/)
- 13 technical agents: `~/.claude/agents/` (backend-architect, code-reviewer, etc.)
- BMAD v6 installed at: `~/bemai-learning/_bmad/` (9 agents, 11 core skills, 4 phase workflows)
- Shared brain: NMEM_BRAIN=bemai (PostgreSQL 16 + pgvector)

**Prerequisites (verify before starting):**
- `~/bemai-learning/_bmad/bmm/agents/` exists with 9 agent files
- PostgreSQL running: `pg_isready`
- NeuralMemory v4.10+: `nmem --version`
- inotifywait: `which inotifywait` (install in Task 1 if missing)
- No naming conflicts: existing 13 agents in `~/.claude/agents/` don't clash with BMAD names

---

## Blocks

| Block | File | Tasks | Done When |
|-------|------|-------|-----------|
| 0 | [block-0-architecture-decision.md](./orchestra-bmad/block-0-architecture-decision.md) | 1-2 | ADR documented, Sonnet limits measured, WORKER-CLAUDE.md stub exists |
| 1 | [block-1-worker-infrastructure.md](./orchestra-bmad/block-1-worker-infrastructure.md) | 3-10 | 1 worker dispatched with persona + MCP verified, writes brain + results, signals done |
| 2 | [block-2-end-to-end.md](./orchestra-bmad/block-2-end-to-end.md) | 11-17 | Each phase tested independently + full Phase 1→4 on synthetic project |
| 3 | [block-3-robustness.md](./orchestra-bmad/block-3-robustness.md) | 18-25 | All recovery scenarios pass, full cycle on real feature succeeds |

## Task Summary

| Task | Block | Description |
|------|-------|-------------|
| 1 | 0 | Install inotifywait + verify prerequisites |
| 2 | 0 | Test Native Agent vs tmux dispatch + Sonnet context limits |
| 3 | 1 | Create 9 BMAD agent persona files |
| 4 | 1 | Update WORKER-CLAUDE.md for BMAD protocol |
| 5 | 1 | Create 17 task file templates (1 fully fleshed, 16 follow pattern) |
| 6 | 1 | Create signal monitor script (inotifywait) + auto-start |
| 7 | 1 | Create checkpoint system + consistency verification |
| 8 | 1 | Create health check + observability + orchestra.log |
| 9 | 1 | Create _bmad-output init + sprint-status template |
| 10 | 1 | Integration test: 1 worker e2e (MCP + permissions verified) |
| 11 | 2 | Create test fixtures + brain seeding (PREREQUISITE for all Block 2) |
| 12 | 2 | Test Phase 1+2 (Mai interactive + John PRD + Sally UX) |
| 13 | 2 | Test Phase 3 partial parallel (Winston → John → Readiness → Paige) |
| 14 | 2 | Test Phase 4 sprint cycle (1 story: create → dev → review) |
| 15 | 2 | Test Quick Flow (Barry: quick-spec → quick-dev) |
| 16 | 2 | Test checkpoint + resume (crash recovery) |
| 17 | 2 | Test full Phase 1→4 on synthetic project (Block 2 done criteria) |
| 18 | 3 | Test course correction + cooldown guard rail |
| 19 | 3 | Test error recovery (crash, hang, MCP fail, escalation ladder) |
| 20 | 3 | Test graceful shutdown + resume |
| 21 | 3 | Test rollback (Readiness Check FAIL) |
| 22 | 3 | Test brain idempotency + concurrent writes |
| 23 | 3 | Test brain scoping (cross-project isolation) |
| 24 | 3 | Test document ownership + scope enforcement |
| 25 | 3 | Full cycle test: Phase 1→4 on real feature (Block 3 done criteria) |

## Dependencies

```
Block 0 (architecture decision)
  └── Block 1 (worker infrastructure) — dispatch mechanism depends on Block 0
       └── Block 2 (end-to-end) — needs working workers
            └── Block 3 (robustness) — needs working e2e flow
```

Within Block 1: Tasks 3, 6, 7, 8, 9 are independent (parallel). Tasks 4, 5 depend on Task 3. Task 10 depends on all.
Within Block 2: Task 11 first (fixtures), then 12-16 parallel-capable, Task 17 last (full cycle).
