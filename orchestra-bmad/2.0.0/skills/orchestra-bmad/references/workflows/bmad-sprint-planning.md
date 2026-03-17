# Sprint Planning Workflow — Full Step-by-Step

**Goal:** Generate sprint status tracking from epics, detecting current story statuses and building a complete sprint-status.yaml file.

**Your Role:** Scrum Master generating and maintaining sprint tracking. Parse epic files, detect story statuses, and produce a structured sprint-status.yaml.

**CRITICAL RULES (NO EXCEPTIONS):**
- Execute ALL steps in exact order; do NOT skip steps
- Parse ALL epic files thoroughly — incomplete parsing = broken tracking
- NEVER downgrade an existing story status (e.g., don't change `done` to `ready-for-dev`)
- Generated YAML must be valid syntax — validate before writing

---

## Step 1: Locate and Load Epic Files

### BAT BUOC: Find ALL epics

1. Search for epic files in `{{PLANNING_ARTIFACTS}}`:
   - **Whole document**: `*epic*.md`, `epics.md`, `bmm-epics.md`
   - **Sharded version**: `epics/index.md` or `*epic*/index.md`
2. If sharded version found:
   - Read `index.md` for document structure
   - Read ALL epic section files listed (e.g., `epic-1.md`, `epic-2.md`, etc.)
   - Process all epics from combined content
3. Priority: If both whole and sharded exist, use whole document
4. **Fuzzy matching**: Accept variations like `epics.md`, `bmm-epics.md`, `user-stories.md`
5. Load `**/project-context.md` if it exists for project-wide patterns

### HALT Conditions
- If NO epic files found -> HALT: "No epic files found in {{PLANNING_ARTIFACTS}}. Create epics first."

---

## Step 2: Parse Epics and Extract All Work Items

For each epic file found, extract:

1. **Epic numbers** from headers like `## Epic 1:` or `## Epic 2:`
2. **Story IDs and titles** from patterns like `### Story 1.1: User Authentication`
3. **Convert story format** using these rules:
   - Original: `### Story 1.1: User Authentication`
   - Replace period with dash: `1-1`
   - Convert title to kebab-case: `user-authentication`
   - Final key: `1-1-user-authentication`

Build complete inventory of ALL epics and stories from ALL epic files.

### Validation
- [ ] Every epic header found and numbered
- [ ] Every story extracted with correct ID conversion
- [ ] No duplicate keys

---

## Step 3: Build Sprint Status Structure

For each epic, create entries in this order:

1. **Epic entry** — Key: `epic-{num}`, Default status: `backlog`
2. **Story entries** — Key: `{epic}-{story}-{title}`, Default status: `backlog`
3. **Retrospective entry** — Key: `epic-{num}-retrospective`, Default status: `optional`

**Example:**
```yaml
development_status:
  epic-1: backlog
  1-1-user-authentication: backlog
  1-2-account-management: backlog
  epic-1-retrospective: optional
```

---

## Step 4: Apply Intelligent Status Detection

### BAT BUOC: Check existing story files

For each story, detect current status:

1. **Story file detection**: Check `{{IMPLEMENTATION_ARTIFACTS}}/{story-key}.md`
   - If exists -> upgrade status to at least `ready-for-dev`
2. **Preservation rule**: If existing `sprint-status.yaml` exists with more advanced status, PRESERVE it
   - NEVER downgrade status

### Status Flow Reference

**Epic:** `backlog` -> `in-progress` -> `done`

**Story:** `backlog` -> `ready-for-dev` -> `in-progress` -> `review` -> `done`

**Retrospective:** `optional` <-> `done`

### Status Transitions
- Epic: backlog -> in-progress (automatically when first story created)
- Epic: in-progress -> done (manually when all stories reach done)
- Story: backlog -> ready-for-dev (story file created)
- Story: ready-for-dev -> in-progress (developer actively working)
- Story: in-progress -> review (ready for code review)
- Story: review -> done (story completed)

---

## Step 5: Generate Sprint Status File

### BAT BUOC: Write valid YAML

Create or update `{{IMPLEMENTATION_ARTIFACTS}}/sprint-status.yaml`:

```yaml
# generated: {{DATE}}
# last_updated: {{DATE}}
# project: {{PROJECT_NAME}}
# project_key: {{PROJECT_KEY}}
# tracking_system: file-system
# story_location: {{IMPLEMENTATION_ARTIFACTS}}

# STATUS DEFINITIONS:
# ==================
# Epic Status:
#   - backlog: Epic not yet started
#   - in-progress: Epic actively being worked on
#   - done: All stories in epic completed
#
# Story Status:
#   - backlog: Story only exists in epic file
#   - ready-for-dev: Story file created in stories folder
#   - in-progress: Developer actively working on implementation
#   - review: Ready for code review
#   - done: Story completed
#
# Retrospective Status:
#   - optional: Can be completed but not required
#   - done: Retrospective has been completed
#
# WORKFLOW NOTES:
# ===============
# - Epic transitions to 'in-progress' automatically when first story is created
# - Stories can be worked in parallel if team capacity allows
# - SM typically creates next story after previous one is 'done' to incorporate learnings
# - Dev moves story to 'review', then runs code-review

generated: {{DATE}}
last_updated: {{DATE}}
project: {{PROJECT_NAME}}
project_key: {{PROJECT_KEY}}
tracking_system: file-system
story_location: {{IMPLEMENTATION_ARTIFACTS}}

development_status:
  # All epics, stories, and retrospectives in order
```

**CRITICAL:** Metadata appears TWICE — once as comments (#) for documentation, once as YAML key:value fields for parsing.

Ensure all items are ordered: epic, its stories, its retrospective, next epic...

---

## Step 6: Validate and Report

### Validation Checklist

- [ ] Every epic in epic files appears in sprint-status.yaml
- [ ] Every story in epic files appears in sprint-status.yaml
- [ ] Every epic has a corresponding retrospective entry
- [ ] No items in sprint-status.yaml that don't exist in epic files
- [ ] All status values are legal (match state machine definitions)
- [ ] File is valid YAML syntax
- [ ] Items ordered correctly: epic -> stories -> retrospective -> next epic

### Parsing Verification

Compare epic files against generated sprint-status.yaml:
```
Epic Files Contains:                Sprint Status Contains:
  Epic 1                              epic-1: [status]
    Story 1.1: User Auth                1-1-user-auth: [status]
    Story 1.2: Account Mgmt            1-2-account-mgmt: [status]
                                        epic-1-retrospective: [status]
  Epic 2                              epic-2: [status]
    Story 2.1: Feature X               2-1-feature-x: [status]
                                        epic-2-retrospective: [status]
```

### Count Totals and Report

- Total epics: {{epic_count}}
- Total stories: {{story_count}}
- Epics in-progress: {{in_progress_count}}
- Stories done: {{done_count}}

**Next Steps:**
1. Review the generated sprint-status.yaml
2. Use this file to track development progress
3. Agents will update statuses as they work
4. Re-run this workflow to refresh auto-detected statuses

---

## Guidelines

1. **Epic Activation**: Mark epic as `in-progress` when starting work on its first story
2. **Sequential Default**: Stories are typically worked in order, but parallel work is supported
3. **Parallel Work Supported**: Multiple stories can be `in-progress` if team capacity allows
4. **Review Before Done**: Stories should pass through `review` before `done`
5. **Learning Transfer**: SM typically creates next story after previous one is `done` to incorporate learnings
