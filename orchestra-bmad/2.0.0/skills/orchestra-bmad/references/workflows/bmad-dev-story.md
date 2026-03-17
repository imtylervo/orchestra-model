# Dev Story Workflow — Full Step-by-Step

**Goal:** Execute story implementation following TDD red-green-refactor cycle.

**CRITICAL RULES (NO EXCEPTIONS):**
- Execute ALL steps in exact order; do NOT skip steps
- Absolutely DO NOT stop because of "milestones", "significant progress", or "session boundaries"
- Continue in a single execution until the story is COMPLETE unless a HALT condition is triggered
- Do NOT schedule a "next session" or request review pauses unless a HALT condition applies
- NEVER implement anything not mapped to a specific task/subtask in the story file
- NEVER proceed to next task until current task/subtask is complete AND tests pass

---

## Step 1: Load Story and Find First Incomplete Task

1. Read the COMPLETE story file
2. Parse sections: Story, Acceptance Criteria, Tasks/Subtasks, Dev Notes, Dev Agent Record, File List, Change Log, Status
3. Load comprehensive context from story file's Dev Notes section
4. Extract developer guidance: architecture requirements, previous learnings, technical specifications
5. Identify first incomplete task (unchecked `[ ]`) in Tasks/Subtasks
6. If no incomplete tasks → go to Step 6 (Completion)
7. If story file inaccessible → HALT: "Cannot develop story without access to story file"

## Step 2: Load Project Context

1. Load project-context.md for coding standards and project-wide patterns (if exists)
2. Extract architecture patterns, naming conventions, testing standards
3. Use enhanced story context to inform implementation decisions

## Step 3: Detect Review Continuation

Check if "Senior Developer Review (AI)" section exists in story file:

**If review section exists (resuming after code review):**
- Extract: review outcome, review date, action items with checkboxes, severity breakdown
- Count unchecked review follow-up tasks in "Review Follow-ups (AI)" subsection
- Prioritize review follow-up tasks (marked [AI-Review]) before regular tasks

**If no review section (fresh start):**
- Proceed with first incomplete task

## Step 4: Mark Story In-Progress

If sprint-status.yaml exists:
- Update story status: ready-for-dev → in-progress
- Update last_updated field

## Step 5: Implement Task — Red-Green-Refactor Cycle

**FOLLOW THE STORY FILE TASKS/SUBTASKS SEQUENCE EXACTLY AS WRITTEN — NO DEVIATION**

### RED PHASE
1. Write FAILING tests first for the task/subtask functionality
2. Confirm tests fail before implementation — this validates test correctness

### GREEN PHASE
1. Implement MINIMAL code to make tests pass
2. Run tests to confirm they now pass
3. Handle error conditions and edge cases as specified in task/subtask

### REFACTOR PHASE
1. Improve code structure while keeping tests green
2. Ensure code follows architecture patterns and coding standards from Dev Notes

### HALT Conditions
- New dependencies required beyond story specifications → HALT: "Additional dependencies need user approval"
- 3 consecutive implementation failures → HALT and request guidance
- Required configuration is missing → HALT: "Cannot proceed without necessary configuration files"

### Critical
- NEVER implement anything not mapped to a specific task/subtask
- NEVER proceed to next task until current task/subtask is complete AND tests pass
- Execute continuously without pausing until all tasks complete or HALT condition

## Step 6: Author Comprehensive Tests

1. Create unit tests for business logic and core functionality
2. Add integration tests for component interactions specified in story requirements
3. Include end-to-end tests for critical user flows when story requirements demand them
4. Cover edge cases and error handling scenarios from Dev Notes

## Step 7: Run Validations

1. Determine test framework from project structure
2. Run ALL existing tests — ensure no regressions
3. Run new tests — verify implementation correctness
4. Run linting and code quality checks if configured
5. Validate implementation meets ALL story acceptance criteria
6. If regression tests fail → STOP and fix immediately
7. If new tests fail → STOP and fix before continuing

## Step 8: Validate and Mark Task Complete

**NEVER mark a task complete unless ALL conditions are met — NO LYING OR CHEATING**

### Validation Gates
1. Verify ALL tests for this task/subtask ACTUALLY EXIST and PASS 100%
2. Confirm implementation matches EXACTLY what the task/subtask specifies — no extra features
3. Validate ALL acceptance criteria related to this task are satisfied
4. Run full test suite — NO regressions

### Review Follow-up Handling
If task is review follow-up (has [AI-Review] prefix):
1. Mark task checkbox [x] in "Tasks/Subtasks > Review Follow-ups (AI)" section
2. Find and mark corresponding action item [x] in "Senior Developer Review (AI) > Action Items"
3. Add to Dev Agent Record: "Resolved review finding [severity]: description"

### Only Mark Complete When ALL Validation Pass
1. Mark task and subtasks checkbox with [x]
2. Update File List with ALL new/modified/deleted files
3. Add completion notes to Dev Agent Record

### If ANY validation fails
- DO NOT mark task complete — fix issues first
- HALT if unable to fix

### After marking task complete
- If more tasks remain → go back to Step 5
- If no tasks remain → go to Step 9

## Step 9: Story Completion

1. Verify ALL tasks and subtasks are marked [x] (re-scan the story document NOW)
2. Run the full regression suite (do NOT skip)
3. Confirm File List includes every changed file
4. Execute Definition of Done checklist (below)
5. Update story Status to: "review"
6. If sprint-status.yaml exists: update story status to "review"

### Final HALT Conditions
- Any task incomplete → HALT: complete remaining tasks
- Regression failures → HALT: fix before completing
- File List incomplete → HALT: update with all changed files
- Definition of Done fails → HALT: address failures

## Step 10: Completion Communication

1. Summarize: story key, title, key changes, tests added, files modified
2. Provide story file path and current status
3. Suggest next steps: run code-review, verify changes

---

# Definition of Done Checklist

**Critical validation: Story is ready for review ONLY when ALL items are satisfied.**

## Context & Requirements Validation
- [ ] **Story Context Completeness:** Dev Notes contains ALL necessary technical requirements, architecture patterns, and implementation guidance
- [ ] **Architecture Compliance:** Implementation follows all architectural requirements from Dev Notes
- [ ] **Technical Specifications:** All libraries, frameworks, versions from Dev Notes implemented correctly
- [ ] **Previous Story Learnings:** Insights from previous stories incorporated (if applicable)

## Implementation Completion
- [ ] **All Tasks Complete:** Every task and subtask marked complete with [x]
- [ ] **Acceptance Criteria Satisfaction:** Implementation satisfies EVERY AC in the story
- [ ] **No Ambiguous Implementation:** Clear, unambiguous implementation that meets requirements
- [ ] **Edge Cases Handled:** Error conditions and edge cases appropriately addressed
- [ ] **Dependencies Within Scope:** Only uses dependencies specified in story or project-context.md

## Testing & Quality Assurance
- [ ] **Unit Tests:** Added/updated for ALL core functionality introduced/changed
- [ ] **Integration Tests:** Added for component interactions when story requirements demand
- [ ] **E2E Tests:** Created for critical user flows when story requirements specify
- [ ] **Test Coverage:** Tests cover acceptance criteria AND edge cases from Dev Notes
- [ ] **Regression Prevention:** ALL existing tests pass (no regressions introduced)
- [ ] **Code Quality:** Linting and static checks pass when configured in project
- [ ] **Test Framework Compliance:** Tests use project's testing frameworks and patterns from Dev Notes

## Documentation & Tracking
- [ ] **File List Complete:** Includes EVERY new, modified, or deleted file (paths relative to repo root)
- [ ] **Dev Agent Record Updated:** Contains relevant Implementation Notes and/or Debug Log
- [ ] **Change Log Updated:** Includes clear summary of what changed and why
- [ ] **Review Follow-ups:** All review follow-up tasks (marked [AI-Review]) completed and corresponding review items marked resolved (if applicable)
- [ ] **Story Structure Compliance:** Only permitted sections of story file were modified

## Final Status Verification
- [ ] **Story Status Updated:** Story Status set to "review"
- [ ] **Sprint Status Updated:** Sprint status updated to "review" (when tracking enabled)
- [ ] **Quality Gates Passed:** All quality checks and validations completed successfully
- [ ] **No HALT Conditions:** No blocking issues or incomplete work remaining
- [ ] **User Communication Ready:** Implementation summary prepared for user review

## Final Validation Output
```
Definition of Done: {{PASS/FAIL}}
Completion Score: {{completed_items}}/{{total_items}} items passed
Quality Gates: {{quality_gates_status}}
Test Results: {{test_results_summary}}
```

**If FAIL:** List specific failures and required actions before story can be marked Ready for Review.
**If PASS:** Story is fully ready for code review.
