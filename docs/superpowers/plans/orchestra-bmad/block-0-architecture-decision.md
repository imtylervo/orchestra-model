# Block 0: Architecture Decision

> **Done when:** ADR documented, Sonnet limits measured, WORKER-CLAUDE.md stub created for testing.

**Parent plan:** [../2026-03-16-orchestra-bmad.md](../2026-03-16-orchestra-bmad.md)

---

## Task 1: Install inotifywait + Verify Prerequisites

- [ ] **Step 1: Install inotify-tools**

```bash
sudo apt-get install -y inotify-tools
```

- [ ] **Step 2: Verify all prerequisites**

```bash
# inotifywait
which inotifywait
# Expected: /usr/bin/inotifywait

# BMAD source files
ls ~/bemai-learning/_bmad/bmm/agents/*.md | wc -l
# Expected: 8+ files

# PostgreSQL
pg_isready
# Expected: accepting connections

# NeuralMemory
nmem --version
# Expected: 4.10.0+

# No agent name conflicts
ls ~/.claude/agents/ | grep -E "mary|john-pm|winston|bob-sm|amelia|sally|quinn|barry-quick|paige"
# Expected: no matches (names not taken)
```

- [ ] **Step 3: Verify WORKER-CLAUDE.md exists** (needed for Task 2 tests)

```bash
test -f ~/.claude/orchestra/WORKER-CLAUDE.md && echo "OK" || {
  echo "MISSING — creating stub"
  mkdir -p ~/.claude/orchestra
  cat > ~/.claude/orchestra/WORKER-CLAUDE.md << 'STUB'
# Worker Protocol — Orchestra System
1. Đọc task file được chỉ định
2. Đọc agent persona file → follow persona
3. nmem_recall brain để lấy context
4. Làm task trong scope được giao
5. nmem_remember decisions quan trọng
6. Ghi results + touch signal file
STUB
}
```

---

## Task 2: Test Native Agent vs tmux Dispatch

Spec section "Open Architecture Decision" defines pass/fail thresholds.

**Files:**
- Create: `~/.claude/orchestra/tests/dispatch-test-task.md`
- Create: `~/.claude/orchestra/tests/test-native-agent.md`
- Create: `~/.claude/orchestra/tests/test-tmux-dispatch.md`
- Create: `~/.claude/orchestra/ADR-001-dispatch-mechanism.md`

- [ ] **Step 1: Create test task file**

```bash
mkdir -p ~/.claude/orchestra/tests
```

Write `~/.claude/orchestra/tests/dispatch-test-task.md`:
```markdown
# Test Task: Dispatch Mechanism Comparison

## Identity
Đọc và follow persona từ: ~/bemai-learning/_bmad/bmm/agents/pm.md

## Phase
Test: Architecture Decision

## Project
orchestra-bmad-test

## Task
1. Output: "ADOPTED: John PM — PRD, epics, stories, requirements"
2. nmem_recall("orchestra-bmad-test: dispatch comparison")
3. Write a 3-sentence summary of what a PRD contains
4. nmem_remember(type="fact", tags=["orchestra-bmad-test", "dispatch-test"], content="Dispatch test OK by John PM", priority=5, trust_score=0.5)
5. Write results to ~/.claude/orchestra/results/test.md
6. touch ~/.claude/orchestra/signals/test.done

## Scope
CHỉ tạo/sửa: ~/.claude/orchestra/results/test.md

## Persona Confirmation
Dòng đầu tiên output: "ADOPTED: [Agent Name] — [Core Skills]"
```

- [ ] **Step 2: Test Native Agent tool**

```
Agent tool prompt: "Đọc file ~/.claude/orchestra/tests/dispatch-test-task.md và thực hiện task trong đó. Follow WORKER-CLAUDE.md protocol tại ~/.claude/orchestra/WORKER-CLAUDE.md"
```

**Pass/fail thresholds** (from spec):

| Criterion | Pass | Fail |
|-----------|------|------|
| Brain access | nmem_recall + nmem_remember succeed, data persists | No MCP tools or data lost |
| Persona loading | Output confirms correct name + skills | Ignores persona or wrong name |
| Performance | < 2x slower than tmux | > 2x slower |
| Context isolation | Mai's history NOT in worker | Worker sees Mai's messages |

Record timing + results in `tests/test-native-agent.md`.

- [ ] **Step 3: Clean up**

```bash
rm -f ~/.claude/orchestra/signals/test.done ~/.claude/orchestra/results/test.md
```

- [ ] **Step 4: Test tmux dispatch**

```bash
# Verify pane exists first
tmux list-panes -t claude -F '#{pane_id}' | head -3

# Dispatch (adjust pane ID as needed)
tmux send-keys -t %2 "claude --dangerously-skip-permissions -p 'Đọc file ~/.claude/orchestra/tests/dispatch-test-task.md và thực hiện task trong đó. Follow WORKER-CLAUDE.md protocol tại ~/.claude/orchestra/WORKER-CLAUDE.md'" Enter
```

Record same criteria in `tests/test-tmux-dispatch.md`.

- [ ] **Step 5: Measure Sonnet context limits**

Concrete procedure:
1. Create a task file that loads: persona (~2K) + task instructions (~1K) + `nmem_recall` (~5K) + a large source file (~50K)
2. Dispatch worker with this task (same mechanism as Step 2 or 4)
3. Task: "Read all input, then summarize the first and last functions in the source file"
4. Check results: did worker correctly reference both first AND last functions?

```bash
# Create a ~50K test source file
python3 -c "
for i in range(200):
    print(f'def function_{i}(x): return x + {i}')
    print(f'    \"\"\"Function {i} docs.\"\"\"')
    print()
" > /tmp/test-large-source.py
wc -c /tmp/test-large-source.py  # ~50K
```

Pass: Worker correctly identifies function_0 AND function_199. Total input ~61K tokens within 200K Sonnet limit.
Fail: Worker misses function_199 (lost in context) or hallucinates function names.

- [ ] **Step 6: Write ADR**

Write `~/.claude/orchestra/ADR-001-dispatch-mechanism.md`:
```markdown
# ADR-001: Dispatch Mechanism

## Status: Accepted

## Context
Orchestra-BMAD needs worker dispatch with persona loading, brain access, context isolation.

## Decision
[Native Agent / tmux] — because:
- Brain access: [results]
- Persona: [results]
- Performance: [results]
- Isolation: [results]

If Native Agent passes 4/4 → use Native Agent (simpler, no tmux scripts needed).
If any criterion fails → use tmux (proven, fully isolated processes).

## Consequences
- [What this means for Block 1+ implementation]
```

- [ ] **Step 7: Commit**

```bash
cd ~/claudecode
git add docs/superpowers/plans/orchestra-bmad/block-0-architecture-decision.md
# Note: ~/.claude/ files (ADR, tests) are outside repo — tracked in orchestra dir
git commit -m "feat(orchestra-bmad): ADR-001 dispatch mechanism + Sonnet limits measured"
```
