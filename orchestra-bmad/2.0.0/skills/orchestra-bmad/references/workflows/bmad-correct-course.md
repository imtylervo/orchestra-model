# Correct Course Workflow — Full Step-by-Step

**Goal:** Manage significant changes during sprint execution by analyzing impact across all project artifacts and producing a structured Sprint Change Proposal.

**Your Role:** Scrum Master navigating change management. Analyze the triggering issue, assess impact across PRD, epics, architecture, and UX artifacts, and produce an actionable Sprint Change Proposal with clear handoff.

**CRITICAL RULES (NO EXCEPTIONS):**
- Execute ALL 6 steps in exact order; do NOT skip
- HALT if PRD or Epics cannot be found — these are essential
- Work INTERACTIVELY with user — they make final decisions
- Be factual, not blame-oriented when analyzing issues
- Every proposal must include before/after and justification

---

## Step 1: Initialize Change Navigation

1. Load `**/project-context.md` for coding standards and project-wide patterns (if exists)
2. Load ALL available planning artifacts:

| Input | Pattern | Strategy |
|-------|---------|----------|
| PRD | `{{PLANNING_ARTIFACTS}}/*prd*.md` or sharded `*prd*/*.md` | FULL_LOAD |
| Epics | `{{PLANNING_ARTIFACTS}}/*epic*.md` or sharded `*epic*/*.md` | FULL_LOAD |
| Architecture | `{{PLANNING_ARTIFACTS}}/*architecture*.md` or sharded | FULL_LOAD |
| UX Design | `{{PLANNING_ARTIFACTS}}/*ux*.md` or sharded | FULL_LOAD |
| Tech Spec | `{{PLANNING_ARTIFACTS}}/*tech-spec*.md` | FULL_LOAD |

3. ASK: "What specific issue or change has been identified that requires navigation?"
4. WAIT for user response
5. ASK user for mode preference:
   - **Incremental** (recommended): Refine each edit collaboratively
   - **Batch**: Present all changes at once for review

### HALT Conditions
- If change trigger is unclear -> HALT: "Cannot navigate change without clear understanding of the triggering issue."
- If PRD and Epics unavailable -> HALT: "Need access to PRD and Epics to assess change impact."

---

## Step 2: Execute Change Analysis Checklist

### BAT BUOC: Work through ALL sections systematically

Record status for each item: `[x] Done`, `[N/A] Skip`, `[!] Action-needed`

### Section 1: Understand the Trigger and Context

- [ ] 1.1 Identify the triggering story (document story ID and description)
- [ ] 1.2 Define the core problem precisely. Categorize:
  - Technical limitation discovered during implementation
  - New requirement from stakeholders
  - Misunderstanding of original requirements
  - Strategic pivot or market change
  - Failed approach requiring different solution
- [ ] 1.3 Assess initial impact and gather supporting evidence

**HALT if**: Trigger unclear or no evidence provided.

### Section 2: Epic Impact Assessment

- [ ] 2.1 Can current epic still be completed as planned?
- [ ] 2.2 Determine required epic-level changes (modify scope, add epic, remove epic, redefine)
- [ ] 2.3 Review ALL remaining planned epics for required changes
- [ ] 2.4 Check if issue invalidates future epics or necessitates new ones
- [ ] 2.5 Consider if epic order or priority should change

### Section 3: Artifact Conflict and Impact Analysis

- [ ] 3.1 Check PRD for conflicts (core goals, requirements, MVP scope)
- [ ] 3.2 Review Architecture (components, patterns, tech stack, data models, APIs, integrations)
- [ ] 3.3 Examine UI/UX specs (components, flows, wireframes, interactions, accessibility)
- [ ] 3.4 Consider other artifacts (deployment, IaC, monitoring, testing, CI/CD)

### Section 4: Path Forward Evaluation

Evaluate each option with effort estimate and risk level (High/Medium/Low):

- [ ] 4.1 **Option 1: Direct Adjustment** — Modify/add stories within existing plan
- [ ] 4.2 **Option 2: Potential Rollback** — Revert completed work to simplify resolution
- [ ] 4.3 **Option 3: PRD MVP Review** — Reduce scope or modify goals
- [ ] 4.4 **Select recommended path** with clear rationale considering:
  - Implementation effort and timeline impact
  - Technical risk and complexity
  - Impact on team morale and momentum
  - Long-term sustainability and maintainability
  - Stakeholder expectations and business value

---

## Step 3: Draft Specific Change Proposals

### BAT BUOC: Create explicit edit proposals for each affected artifact

**For Story changes:**
```
Story: [STORY-KEY] Story Title
Section: Acceptance Criteria

OLD:
- Original acceptance criteria text

NEW:
- Updated acceptance criteria text

Rationale: Why this change is needed
```

**For PRD modifications:**
- Specify exact sections to update
- Show current content and proposed changes
- Explain impact on MVP scope

**For Architecture changes:**
- Identify affected components, patterns, technology choices
- Describe diagram updates needed
- Note ripple effects on other components

**For UI/UX specification updates:**
- Reference specific screens or components
- Show wireframe or flow changes needed
- Connect to user experience impact

### Mode Handling

**Incremental mode**: Present each edit proposal individually
- ASK: "Review and refine this change? Approve [a], Edit [e], Skip [s]"
- Iterate based on feedback

**Batch mode**: Collect all proposals and present together at end of step

---

## Step 4: Generate Sprint Change Proposal

Compile comprehensive document with these sections:

### Section 1: Issue Summary
- Clear problem statement
- Context about when/how discovered
- Evidence or examples

### Section 2: Impact Analysis
- Epic Impact: Which epics affected and how
- Story Impact: Current and future stories requiring changes
- Artifact Conflicts: PRD, Architecture, UI/UX docs needing updates
- Technical Impact: Code, infrastructure, deployment implications

### Section 3: Recommended Approach
- Present chosen path (Direct Adjustment / Potential Rollback / MVP Review)
- Clear rationale for recommendation
- Effort estimate, risk assessment

### Section 4: Detailed Change Proposals
- All refined edit proposals from Step 3
- Grouped by artifact type (Stories, PRD, Architecture, UI/UX)
- Each includes before/after and justification

### Section 5: Implementation Handoff
- Categorize change scope:
  - **Minor**: Direct implementation by dev team
  - **Moderate**: Backlog reorganization needed (PO/SM)
  - **Major**: Fundamental replan required (PM/Architect)
- Specify handoff recipients and responsibilities
- Define success criteria

Write document to: `{{PLANNING_ARTIFACTS}}/sprint-change-proposal-{{DATE}}.md`

ASK: "Review complete proposal. Continue [c] or Edit [e]?"

---

## Step 5: Finalize and Route for Implementation

### BAT BUOC: Get explicit user approval

ASK: "Do you approve this Sprint Change Proposal for implementation? (yes/no/revise)"

**If no/revise:**
- Gather specific feedback
- Return to Step 3 (edit proposals) or Step 4 (proposal structure)

**If yes:**
- Finalize Sprint Change Proposal document
- Determine scope classification (Minor/Moderate/Major)
- Route appropriately:
  - **Minor** -> Development team for direct implementation
  - **Moderate** -> Product Owner / Scrum Master for backlog reorganization
  - **Major** -> Product Manager / Solution Architect for fundamental replan

### Update sprint-status.yaml

If epics were added/removed/renumbered:
- Add new epic entries with status `backlog`
- Remove corresponding entries for removed epics
- Update epic IDs and story references for renumbered epics
- Update story entries within affected epics

---

## Step 6: Workflow Completion

Summarize workflow execution:
- Issue addressed: {{change_trigger}}
- Change scope: {{scope_classification}}
- Artifacts modified: {{list_of_artifacts}}
- Routed to: {{handoff_recipients}}

Confirm all deliverables produced:
- [ ] Sprint Change Proposal document
- [ ] Specific edit proposals with before/after
- [ ] Implementation handoff plan
- [ ] sprint-status.yaml updated (if applicable)

Report: "Correct Course workflow complete!"
Remind user of success criteria and next steps.
