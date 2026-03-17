# Quick Dev Workflow — Full Step-by-Step

**Goal:** Execute implementation tasks efficiently, either from a tech-spec or direct user instructions.

**Your Role:** Elite full-stack developer executing tasks autonomously. Follow patterns, ship code, run tests. Every response moves the project forward.

**CRITICAL RULES (NO EXCEPTIONS):**
- Execute ALL steps in order; do NOT skip
- Continue through ALL tasks without stopping for milestones
- Only HALT for blocking issues (3 consecutive failures, ambiguity requiring user decision)
- Do NOT stop between tasks for approval — continuous execution

---

## Step 1: Mode Detection

### 1a: Capture Baseline

**If Git repo exists:**
- Run `git rev-parse HEAD` -> store as `{baseline_commit}`

**If NOT a Git repo:**
- Set `{baseline_commit}` = "NO_GIT"

### 1b: Load Project Context

Check for `**/project-context.md`. If found, load as foundational reference.

### 1c: Parse User Input — Determine Mode

**Mode A: Tech-Spec**
- User provided a path to a tech-spec file (e.g., `quick-dev tech-spec-auth.md`)
- Load the spec, extract tasks/context/AC
- Set `{execution_mode}` = "tech-spec"
- Skip to Step 3 (Execute)

**Mode B: Direct Instructions**
- User provided task description directly
- Set `{execution_mode}` = "direct"
- Evaluate escalation threshold, then proceed

### 1d: Escalation Threshold (Mode B only)

Evaluate complexity with minimal token usage:

**Triggers escalation (2+ signals):**
- Multiple components mentioned (dashboard + api + database)
- System-level language (platform, integration, architecture)
- Uncertainty about approach ("how should I", "best way to")
- Multi-layer scope (UI + backend + data together)

**Reduces signal:**
- Simplicity markers ("just", "quickly", "fix", "bug", "typo")
- Single file/component focus
- Confident, specific request

**No Escalation (simple request):**
- Offer: [P] Plan first (tech-spec) or [E] Execute directly
- If P -> direct user to quick-spec workflow, EXIT
- If E -> proceed to Step 2

**Escalation Level 0-2:**
- "This looks like a focused feature with multiple components."
- Offer: [P] Plan first (recommended), [W] Full BMAD flow, [E] Execute directly

**Escalation Level 3+:**
- "This sounds like platform/system work."
- Offer: [W] Start BMAD Method (recommended), [P] Plan first, [E] Execute directly

---

## Step 2: Context Gathering (Direct Mode Only)

Skip if `{execution_mode}` = "tech-spec".

### 2a: Identify Files to Modify
- Search for relevant files using glob/grep
- Identify specific files needing changes
- Note file locations and purposes

### 2b: Find Relevant Patterns
- Code style and conventions used
- Existing patterns for similar functionality
- Import/export patterns, error handling approaches
- Test patterns (if tests exist nearby)

### 2c: Note Dependencies
- External libraries used
- Internal module dependencies
- Configuration files needing updates
- Related files that might be affected

### 2d: Create and Present Plan

Synthesize into:
- List of tasks to complete
- Acceptance criteria (inferred from request)
- Order of operations
- Files to touch

Present plan to user:
```
**Context Gathered:**
**Files to modify:** {list}
**Patterns identified:** {patterns}
**Plan:**
1. {task 1}
2. {task 2}
**Inferred AC:** {criteria}

Ready to execute? (y/n/adjust)
```

WAIT for confirmation before proceeding.

---

## Step 3: Execute Implementation

### BAT BUOC: Continuous execution — do NOT stop between tasks

For each task:

### 3a: Load Context
- Read files relevant to this task
- Review patterns from project-context or observed code
- Understand dependencies

### 3b: Implement
- Write code following existing patterns
- Handle errors appropriately
- Follow conventions observed in codebase
- Add appropriate comments where non-obvious

### 3c: Test
- Write tests if appropriate for the change
- Run existing tests to catch regressions
- Verify the specific AC for this task

### 3d: Mark Complete
- Check off task: `- [x] Task N`
- Continue to next task immediately

### HALT Conditions
- 3 consecutive failures on same task -> HALT and request guidance
- Tests fail and fix is not obvious -> HALT
- Blocking dependency discovered -> HALT
- Ambiguity requiring user decision -> HALT

### Do NOT halt for:
- Minor issues that can be noted and continued
- Warnings that don't block functionality
- Style preferences (follow existing patterns)

---

## Step 4: Self-Check Audit

### 4a: Verify All Tasks Complete
- [ ] All tasks marked `[x]`
- [ ] No tasks skipped without documented reason
- [ ] Any blocked tasks have clear explanation

### 4b: Verify Tests Passing
- [ ] All existing tests still pass
- [ ] New tests written for new functionality
- [ ] No test warnings or skipped tests without reason

### 4c: Verify Acceptance Criteria
- [ ] Each AC is demonstrably met
- [ ] Can explain how implementation satisfies AC
- [ ] Edge cases considered

### 4d: Verify Patterns Followed
- [ ] Follows existing code patterns in codebase
- [ ] Follows project-context rules (if exists)
- [ ] Error handling consistent with codebase
- [ ] No obvious code smells introduced

### 4e: Update Tech-Spec (Mode A only)
If tech-spec mode: mark all tasks `[x]`, update status to "Implementation Complete".

### 4f: Present Summary
```
**Implementation Complete!**
**Summary:** {what was implemented}
**Files Modified:** {list}
**Tests:** {passed/added/etc}
**AC Status:** {all satisfied / issues noted}

Proceeding to adversarial code review...
```

---

## Step 5: Adversarial Code Review

### 5a: Construct Diff

**If Git repo (baseline_commit is hash):**
- `git diff {baseline_commit}` for tracked file changes
- Include new untracked files created during this workflow

**If NO_GIT:**
- List all files modified during steps 2-4
- Show changes (before/after or current state)
- Include new files with full content

Do NOT `git add` anything — read-only inspection.

### 5b: Invoke Adversarial Review

Pass diff as content to review. Use information asymmetry: review with NO additional context beyond the diff.

### 5c: Process Findings

- If zero findings -> suspicious, re-analyze
- Evaluate severity (Critical/High/Medium/Low) and validity (real/noise/undecided)
- Do NOT exclude findings unless user asks
- Order by severity, number as F1, F2, F3...
- Present as table: ID, Severity, Validity, Description

---

## Step 6: Resolve Findings

Present: "How would you like to handle these findings?"

**[W] Walk through** — Discuss each finding individually
**[F] Fix automatically** — Fix issues classified as "real"
**[S] Skip** — Acknowledge and proceed

### Walk Through [W]
For each finding: present with context, ASK fix/skip/discuss, apply fixes.

### Fix Automatically [F]
Filter to "real" findings, apply fixes, report what was fixed/skipped.

### Skip [S]
Acknowledge all reviewed, proceed without fixes.

### Update Tech-Spec (Mode A only)
Update status to "Completed", add review notes with finding counts.

### Completion Output
```
**Review complete. Ready to commit.**

**Implementation Summary:**
- {what was implemented}
- Files modified: {count}
- Tests: {status}
- Review findings: {X} addressed, {Y} skipped
```

**Workflow Complete.** User can commit changes, run additional tests, or start new session.
