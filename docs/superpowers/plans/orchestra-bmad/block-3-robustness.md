# Block 3: Robustness

> **Done when:** All recovery scenarios pass, full cycle on real feature succeeds.

**Parent plan:** [../2026-03-16-orchestra-bmad.md](../2026-03-16-orchestra-bmad.md)
**Depends on:** Block 2 (working e2e flow)

---

## Task 18: Test Course Correction + Cooldown

- [ ] **Step 1: Start Phase 4 with story in-progress**
- [ ] **Step 2: Simulate Tyler requirement change** ("thêm field priority cho tasks")
- [ ] **Step 3: Dispatch course correction (John)**

Pass: Updated stories reflect new requirement. Sprint-status updated.

- [ ] **Step 4: Verify affected in-progress story stopped + re-dispatched**

Pass: Amelia's in-progress work stopped. New story file includes priority field.

- [ ] **Step 5: Verify course_corrections counter = 1**

```bash
~/orchestra-checkpoint.sh read | grep "course_corrections"
# Expected: 1
```

- [ ] **Step 6: Test guard rails**

a) Max 3 corrections → warn Tyler:
```
Simulate 3 corrections. On 3rd: Mai outputs "Sprint đang thrash, cần stabilize requirements"
```

b) Cooldown — min 1 story completed between corrections (except critical blockers):
```
Attempt correction with 0 stories completed since last correction.
Pass: Correction blocked unless tagged as critical.
```

---

## Task 19: Test Error Recovery

- [ ] **Step 1: Worker crash (kill tmux pane / kill Agent)**

```bash
# Kill worker mid-task
tmux kill-pane -t %2
```

Verify:
- Auto-retry spawns new worker within 30s
- Same task re-dispatched
- After 2 failed retries → fallback to sequential mode

Pass: Worker auto-retried. After 2 failures, falls back.

- [ ] **Step 2: Worker hang (no signal within timeout)**

Start worker, but make it hang (e.g., task with infinite loop or very long operation).

Verify:
- Signal monitor detects timeout at correct threshold (Phase 4 dev: 30min for real, use shorter for test)
- Mai kills hung worker + re-dispatches

Pass: Timeout detected. Worker killed. New worker dispatched.

- [ ] **Step 3: MCP plugin failure (REG-004)**

Dispatch worker where nmem tools are unavailable (simulate by env issue).

Pass: Worker reports "no nmem tools". Mai kills + re-spawns with plugin verification.

- [ ] **Step 4: Test escalation ladder**

Force all retries to fail:
```
Auto-retry (2x) → sequential fallback (1 worker) → Mai direct (no worker) → escalate to Tyler
```

Pass: Each level triggered in order. Tyler sees escalation message.

---

## Task 20: Test Graceful Shutdown + Resume

- [ ] **Step 1: Start Phase 4 with 2 workers running**

- [ ] **Step 2: Trigger shutdown**

```bash
touch ~/.claude/orchestra/signals/shutdown
```

- [ ] **Step 3: Verify workers wrap up** (max 60s)

Workers check `signals/shutdown` before each major step → write partial results + brain → exit.

Pass: Both workers exit within 60s. Partial results exist in `results/`. Brain has session summary.

- [ ] **Step 4: Verify checkpoint saved**

```bash
~/orchestra-checkpoint.sh read
# Expected: current state snapshot with both workers' last known status
```

- [ ] **Step 5: Resume**

```bash
rm ~/.claude/orchestra/signals/shutdown
# Run resume protocol (from checkpoint)
```

Pass: Resume picks up from last checkpoint. Unfinished tasks re-dispatched. Completed work not repeated.

- [ ] **Step 6: Verify state consistency after resume**

```bash
~/orchestra-checkpoint.sh verify ~/test-project
```

Check hierarchy: checkpoint > sprint-status > files > brain. All agree.

---

## Task 21: Test Rollback — Readiness Check FAIL

- [ ] **Step 1: Set up Phase 3 with intentionally misaligned architecture/stories**

Architecture says "REST API" but stories say "GraphQL" → deliberate contradiction.

- [ ] **Step 2: Run Readiness Check → expect CONCERNS or FAIL**

Pass: Winston detects contradiction. Output = CONCERNS or FAIL (not PASS).

- [ ] **Step 3: If CONCERNS → fix + re-check (max 2)**

Pass: Fixed stories + re-check = PASS within 2 attempts.

- [ ] **Step 4: If FAIL → rollback**

```bash
git checkout phase-2-complete  # tag from Phase 2
```

Pass: Documents revert. Brain memories from failed attempt PERSIST (lessons learned, not deleted).

- [ ] **Step 5: Re-dispatch Phase 3**

Workers recall brain → see failed attempt's lessons → avoid same mistake.

Pass: New Phase 3 passes readiness on first attempt.

---

## Task 22: Test Brain Idempotency + Concurrent Writes

- [ ] **Step 1: Dispatch task that writes brain memories**

- [ ] **Step 2: Re-dispatch same task (simulate retry)**

Pass: Worker uses `nmem_edit` (not `nmem_remember`) for existing memories. No duplicates.

```
nmem_recall("test-project: [topic]")
# Expected: 1 result, not 2
```

- [ ] **Step 3: Test concurrent brain writes**

Dispatch 2 workers simultaneously, both writing to brain with different tags.

Pass: Both memories saved. No corruption. PostgreSQL MVCC handles concurrency.

```
nmem_recall("test-project: worker-1 decision") → 1 result
nmem_recall("test-project: worker-2 decision") → 1 result
```

---

## Task 23: Test Brain Scoping (Cross-project Isolation)

- [ ] **Step 1: Run workers on project-A with tagged memories**

```
tags=["project-A", "phase-2", "feature"]
```

- [ ] **Step 2: Run workers on project-B with tagged memories**

```
tags=["project-B", "phase-2", "feature"]
```

- [ ] **Step 3: Verify isolation**

```
nmem_recall("project-A Phase 2: features") → only project-A memories
nmem_recall("project-B Phase 2: features") → only project-B memories
```

Pass: No cross-contamination. Tag convention sufficient for isolation.

---

## Task 24: Test Document Ownership + Scope Enforcement

- [ ] **Step 1: Dispatch worker with strict scope** (e.g., only modify PRD.md)

- [ ] **Step 2: Check if worker modified files outside scope**

```bash
git diff --name-only
# Expected: only PRD.md (or files within scope)
```

- [ ] **Step 3: Test scope violation detection**

Dispatch worker that intentionally writes to out-of-scope file.
Mai checks `git diff --name-only` vs task scope.

Pass: Mai detects violation. Results rejected. Worker re-dispatched with warning.

---

## Task 25: Full Cycle Test — Phase 1→4 on Real Feature

**Block 3 done criteria + framework validation.**

- [ ] **Step 1: Pick real feature** (e.g., add health check endpoint to bemai-learning)

- [ ] **Step 2: Phase 1** — Mai as Mary (brainstorm + product brief)
- [ ] **Step 3: Phase 2** — John PRD + Sally UX (partial parallel)
- [ ] **Step 4: Phase 3** — Winston arch → John stories → Readiness → Paige
- [ ] **Step 5: Phase 4** — Sprint: Bob plan → per-story (Bob create → Amelia dev → Review)
- [ ] **Step 6: Quinn E2E tests** per epic
- [ ] **Step 7: Bob retrospective** per epic

- [ ] **Step 8: Verify all quality gates**

- Phase gate commits exist in git log
- Checkpoint saved at every phase transition
- Brain has complete audit trail (all 4 phases)
- Sprint-status.yaml accurate
- All tests pass
- Document chain intact (each output references prior inputs)

- [ ] **Step 9: Tag + commit**

```bash
git tag orchestra-bmad-v1.0-validated
git commit -m "test(orchestra-bmad): full cycle Phase 1→4 validated on real feature"
```

- [ ] **Step 10: Clean up test brain memories**

```
Delete test memories tagged with test project names to keep brain clean.
```
