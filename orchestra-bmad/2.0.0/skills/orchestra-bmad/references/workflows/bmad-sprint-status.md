# Sprint Status Workflow — Full Step-by-Step

**Goal:** Summarize sprint status, surface risks, and recommend the next workflow action.

**Your Role:** Scrum Master providing clear, actionable sprint visibility. No time estimates — focus on status, risks, and next steps.

**CRITICAL RULES (NO EXCEPTIONS):**
- Execute steps in exact order, no skipping
- NEVER fabricate status data — read directly from sprint-status.yaml
- All status values must match known valid statuses
- Provide actionable recommendations based on actual state

---

## Step 0: Determine Execution Mode

Set mode based on caller input:
- **interactive** (default): Full interactive flow with user
- **data**: Return structured data only (for other workflows)
- **validate**: Validate sprint-status.yaml structure only

If mode = data -> jump to Step 5 (Data Mode)
If mode = validate -> jump to Step 6 (Validate Mode)
Otherwise -> continue to Step 1

---

## Step 1: Locate Sprint Status File

1. Try `{{IMPLEMENTATION_ARTIFACTS}}/sprint-status.yaml`
2. If file not found:
   - Report: "sprint-status.yaml not found. Run sprint-planning workflow to generate it."
   - HALT

---

## Step 2: Read and Parse Sprint Status

### BAT BUOC: Parse ALL entries correctly

1. Read the FULL file: `{{IMPLEMENTATION_ARTIFACTS}}/sprint-status.yaml`
2. Parse metadata fields: `generated`, `last_updated`, `project`, `project_key`, `tracking_system`, `story_location`
3. Parse `development_status` map. Classify keys:
   - **Epics**: keys starting with `epic-` (and NOT ending with `-retrospective`)
   - **Retrospectives**: keys ending with `-retrospective`
   - **Stories**: everything else (e.g., `1-2-login-form`)

### Legacy Status Mapping
- Story status `drafted` -> `ready-for-dev`
- Epic status `contexted` -> `in-progress`

### Count Statuses
- **Stories**: backlog, ready-for-dev, in-progress, review, done
- **Epics**: backlog, in-progress, done
- **Retrospectives**: optional, done

### Validate All Statuses
Valid story statuses: `backlog`, `ready-for-dev`, `in-progress`, `review`, `done` (legacy: `drafted`)
Valid epic statuses: `backlog`, `in-progress`, `done` (legacy: `contexted`)
Valid retrospective statuses: `optional`, `done`

If any status is unrecognized:
- Report which entries have invalid statuses
- Ask user for corrections (e.g., "1=in-progress, 2=backlog")
- Update sprint-status.yaml with corrections if provided

---

## Step 3: Detect Risks

Analyze parsed data for these risk conditions:

- [ ] Any story has status `review` -> suggest running code-review workflow
- [ ] Any story `in-progress` AND no stories `ready-for-dev` -> recommend staying focused on active story
- [ ] All epics `backlog` AND no stories `ready-for-dev` -> prompt create-story workflow
- [ ] `last_updated` more than 7 days old (or missing, fall back to `generated`) -> warn "sprint-status.yaml may be stale"
- [ ] Orphaned story (story key doesn't match any epic pattern) -> warn "orphaned story detected"
- [ ] In-progress epic with no associated stories -> warn "in-progress epic has no stories"

---

## Step 4: Select Next Action Recommendation

### BAT BUOC: Follow priority order exactly

Sort stories by epic number then story number (e.g., 1-1 before 1-2 before 2-1).

Pick the next recommended workflow:

1. If any story status == `in-progress` -> recommend **dev-story** for first in-progress story
2. Else if any story status == `review` -> recommend **code-review** for first review story
3. Else if any story status == `ready-for-dev` -> recommend **dev-story** for first ready story
4. Else if any story status == `backlog` -> recommend **create-story** for first backlog story
5. Else if any retrospective status == `optional` -> recommend **retrospective**
6. Else -> All done! Congratulate the user.

Store: `next_story_id`, `next_workflow_id`

---

## Step 4b: Display Summary (Interactive Mode)

Present:

```
## Sprint Status

- Project: {{project}} ({{project_key}})
- Tracking: {{tracking_system}}
- Status file: {{sprint_status_file}}

**Stories:** backlog {{count_backlog}}, ready-for-dev {{count_ready}}, in-progress {{count_in_progress}}, review {{count_review}}, done {{count_done}}

**Epics:** backlog {{epic_backlog}}, in-progress {{epic_in_progress}}, done {{epic_done}}

**Next Recommendation:** {{next_workflow_id}} ({{next_story_id}})

**Risks:**
{{risk_list}}
```

### Offer Actions

1. Run recommended workflow now
2. Show all stories grouped by status
3. Show raw sprint-status.yaml
4. Exit

---

## Step 5: Data Mode Output

For programmatic callers — parse and return structured data:

```
next_workflow_id = {{next_workflow_id}}
next_story_id = {{next_story_id}}
count_backlog = {{count_backlog}}
count_ready = {{count_ready}}
count_in_progress = {{count_in_progress}}
count_review = {{count_review}}
count_done = {{count_done}}
epic_backlog = {{epic_backlog}}
epic_in_progress = {{epic_in_progress}}
epic_done = {{epic_done}}
risks = {{risks}}
```

Return to caller.

---

## Step 6: Validate Mode

1. Check that sprint-status.yaml exists
   - If missing -> return `is_valid = false`, error: "sprint-status.yaml missing", suggestion: "Run sprint-planning to create it"

2. Read and parse the file

3. Validate required metadata fields exist: `generated`, `project`, `project_key`, `tracking_system`, `story_location`
   - If any missing -> return `is_valid = false`, list missing fields

4. Verify `development_status` section exists with at least one entry
   - If missing/empty -> return `is_valid = false`

5. Validate all status values against known valid statuses
   - If invalid found -> return `is_valid = false`, list invalid entries

6. If all pass -> return `is_valid = true`, message: "sprint-status.yaml valid"
