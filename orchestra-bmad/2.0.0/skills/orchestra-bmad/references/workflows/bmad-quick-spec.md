# Quick Spec Workflow — Full Step-by-Step

**Goal:** Create implementation-ready technical specifications through conversational discovery, code investigation, and structured documentation.

**READY FOR DEVELOPMENT STANDARD:**

A specification is considered "Ready for Development" ONLY if it meets ALL of the following:
- **Actionable**: Every task has a clear file path and specific action
- **Logical**: Tasks are ordered by dependency (lowest level first)
- **Testable**: All ACs follow Given/When/Then and cover happy path and edge cases
- **Complete**: All investigation results inlined; no placeholders or "TBD"
- **Self-Contained**: A fresh agent can implement without reading workflow history

**Your Role:** Elite developer and spec engineer. Ask sharp questions, investigate existing code thoroughly, produce specs with ALL context a fresh dev agent needs.

**CRITICAL RULES (NO EXCEPTIONS):**
- Execute steps 1-4 in exact order; do NOT skip
- HALT at checkpoints and wait for user input
- NEVER generate spec before completing investigation (Step 2)
- Spec MUST meet Ready for Development standard before finalizing

---

## Step 1: Analyze Requirement Delta

### 1a: Check for Work in Progress

Before anything else, check if `{{IMPLEMENTATION_ARTIFACTS}}/tech-spec-wip.md` exists.

**If WIP file exists:**
- Read frontmatter: `title`, `slug`, `stepsCompleted`
- Calculate progress: `lastStep = max(stepsCompleted)`
- Present to user: "Found tech-spec in progress: **{title}** — Step {lastStep} of 4 complete. Continue? [Y/N]"
- WAIT for response
  - **Y**: Jump to the next incomplete step
  - **N**: Archive WIP file to `tech-spec-{slug}-archived-{{DATE}}.md` and start fresh

### 1b: Greet and Get Initial Request

"What are we building today?"

Get initial description. Don't ask detailed questions yet.

### 1c: Quick Orient Scan

Before asking questions, do a rapid scan:
- Check `{{IMPLEMENTATION_ARTIFACTS}}` and `{{PLANNING_ARTIFACTS}}` for planning documents
- Check for `**/project-context.md` — skim for patterns and conventions
- If user mentioned specific code/features, quick-scan relevant files
- Note: tech stack, obvious patterns, file locations

**This scan should take < 30 seconds. Just enough to ask smart questions.**

### 1d: Ask Informed Questions

Ask clarifying questions INFORMED by what you found:
- Reference specific code patterns found (e.g., "`AuthService` handles validation in controller — should new field follow that or move to dedicated validator?")
- Reference planning docs if relevant
- Adapt to user's skill level

### 1e: Capture Core Understanding

From the conversation, extract and confirm:
- **Title**: Clear, concise name
- **Slug**: URL-safe version (lowercase, hyphens)
- **Problem Statement**: What problem we're solving
- **Solution**: High-level approach (1-2 sentences)
- **In Scope / Out of Scope**

ASK user to confirm before proceeding.

### 1f: Initialize WIP File

Create `{{IMPLEMENTATION_ARTIFACTS}}/tech-spec-wip.md` with frontmatter:

```yaml
---
title: '{title}'
slug: '{slug}'
created: '{{DATE}}'
status: 'in-progress'
stepsCompleted: [1]
tech_stack: []
files_to_modify: []
code_patterns: []
test_patterns: []
---
```

Fill in Overview section with Problem Statement, Solution, and Scope.

---

## Step 2: Map Technical Constraints and Anchor Points

### BAT BUOC: Deep code investigation before generating spec

### 2a: Build on Step 1's Quick Scan

Review what was found. ASK: "Based on my quick look, I see [files/patterns]. Are there other files or directories I should investigate deeply?"

### 2b: Read and Analyze Code

For each file/directory:
- Read complete files
- Identify patterns, conventions, coding style
- Note dependencies and imports
- Find related test files

**If NO relevant code found (Clean Slate):**
- Identify target directory
- Scan parent directories for architectural context
- Identify standard utilities/boilerplate to use
- Document as "Confirmed Clean Slate"

### 2c: Document Technical Context

Capture and confirm with user:
- **Tech Stack**: Languages, frameworks, libraries
- **Code Patterns**: Architecture patterns, naming conventions, file structure
- **Files to Modify/Create**: Specific files needing changes or new files
- **Test Patterns**: How tests are structured, frameworks used

### 2d: Update WIP File

Update frontmatter with `stepsCompleted: [1, 2]` and technical context.
Fill in Context for Development section: Codebase Patterns, Files to Reference, Technical Decisions.

---

## Step 3: Generate Implementation Plan

### 3a: Load Current State

Read WIP file completely. Extract Overview and Context for Development.

### 3b: Task Breakdown

Generate specific implementation tasks:
- Each task = discrete, completable unit of work
- Ordered logically (dependencies first)
- Include specific files to modify
- Be explicit about what changes to make

```markdown
- [ ] Task N: Clear action description
  - File: `path/to/file.ext`
  - Action: Specific change to make
  - Notes: Implementation details
```

### 3c: Acceptance Criteria

Create testable ACs in Given/When/Then format:

```markdown
- [ ] AC N: Given [precondition], when [action], then [expected result]
```

Cover: happy path, error handling, edge cases, integration points.

### 3d: Additional Context

- **Dependencies**: External libraries, other tasks, API/data dependencies
- **Testing Strategy**: Unit tests, integration tests, manual testing steps
- **Notes**: High-risk items, known limitations, future considerations

### 3e: Write Complete Spec

Update WIP file with all content. No placeholder text remaining.
Update `stepsCompleted: [1, 2, 3]` and `status: 'review'`.

Proceed directly to Step 4.

---

## Step 4: Review and Finalize

### 4a: Present Complete Spec

Display full spec to user with summary:
- {task_count} tasks to implement
- {ac_count} acceptance criteria to verify
- {files_count} files to modify

ASK: "Review your spec. [C] Continue [E] Edit [Q] Questions"
WAIT for response.

### 4b: Handle Review Feedback

**If Edit**: Make requested edits, re-present affected sections, loop until satisfied.

**If spec doesn't meet Ready for Development standard**: Point out missing/weak sections, propose improvements.

**If Questions**: Answer and clarify, make edits if needed.

### 4c: Finalize the Spec

### BAT BUOC: Spec must meet Ready for Development standard

When user confirms and spec meets standard:

1. Update frontmatter: `status: 'ready-for-dev'`, `stepsCompleted: [1, 2, 3, 4]`
2. Rename WIP file to: `{{IMPLEMENTATION_ARTIFACTS}}/tech-spec-{slug}.md`

### 4d: Adversarial Review (Recommended)

If available, invoke adversarial review on the finalized spec:
- Pass spec content for review with NO additional context (information asymmetry)
- Process findings: evaluate severity and validity
- Present numbered findings (F1, F2, F3...) ordered by severity
- Zero findings = suspicious, re-analyze

### 4e: Present Final Options

```
Tech-Spec Complete! Saved to: {finalFile}

Next Steps:
[R] Adversarial Review — critique the spec (recommended)
[B] Begin Development — start implementing now
[D] Done — exit workflow

For best results, implement in a FRESH CONTEXT:
  quick-dev {finalFile}
```

---

## Tech-Spec Template

```markdown
---
title: '{title}'
slug: '{slug}'
created: '{{DATE}}'
status: 'in-progress'
stepsCompleted: []
tech_stack: []
files_to_modify: []
code_patterns: []
test_patterns: []
---

# Tech-Spec: {title}

**Created:** {{DATE}}

## Overview

### Problem Statement
{problem_statement}

### Solution
{solution}

### Scope
**In Scope:** {in_scope}
**Out of Scope:** {out_of_scope}

## Context for Development

### Codebase Patterns
{codebase_patterns}

### Files to Reference
| File | Purpose |
| ---- | ------- |

### Technical Decisions
{technical_decisions}

## Implementation Plan

### Tasks
{tasks}

### Acceptance Criteria
{acceptance_criteria}

## Additional Context

### Dependencies
{dependencies}

### Testing Strategy
{testing_strategy}

### Notes
{notes}
```
