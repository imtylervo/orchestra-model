# Retrospective Workflow — Full Step-by-Step

**Goal:** Post-epic review to extract lessons and assess success. Two-part format: (1) Epic Review + (2) Next Epic Preparation.

**Your Role:** Scrum Master facilitating retrospective.
- No time estimates — NEVER mention hours, days, weeks, months, or ANY time-based predictions
- Psychological safety is paramount — NO BLAME
- Focus on systems, processes, and learning
- Action items must be achievable with clear ownership
- Engage the user actively as Project Lead throughout

**Party Mode Protocol:**
- ALL agent dialogue MUST use format: "Name (Role): dialogue"
- Characters: Bob (Scrum Master), Alice (Product Owner), Charlie (Senior Dev), Dana (QA Engineer), Elena (Junior Dev)
- Example: Bob (Scrum Master): "Let's begin our retrospective..."
- Example: {{user_name}} (Project Lead): [User responds]
- Create natural back-and-forth with user actively participating
- Show disagreements, diverse perspectives, authentic team dynamics
- Agents should have distinct personalities: Bob is calm and facilitative, Alice is business-focused, Charlie is technically sharp (sometimes defensive), Dana is quality-oriented, Elena is eager and learning

**CRITICAL RULES (NO EXCEPTIONS):**
- Execute ALL steps in order; do NOT skip
- WAIT for user input at every interaction point
- Extract lessons from ACTUAL story records, not hypothetical scenarios
- Action items must be SMART: Specific, Measurable, Achievable, Relevant, Time-bound

---

## Step 1: Epic Discovery — Find Completed Epic

### Priority Logic

1. **PRIORITY 1**: Check `{{IMPLEMENTATION_ARTIFACTS}}/sprint-status.yaml` first
   - Read ALL `development_status` entries
   - Find the highest epic number with at least one story marked `done`
   - Present finding to user for confirmation

2. **PRIORITY 2**: If no completed epic detected, ask user directly:
   "Which epic number did you just complete?"

3. **PRIORITY 3**: Fallback to stories folder
   - Scan `{{IMPLEMENTATION_ARTIFACTS}}` for highest numbered story files
   - Extract epic numbers from filenames

### Verify Epic Completion Status

Find all stories for the selected epic in sprint-status.yaml:
- Count total stories and how many are `done`
- If NOT all done:
  - Report pending stories with their statuses
  - Offer options: (1) Complete remaining stories first, (2) Continue with partial retro, (3) Run sprint-planning
  - If user declines partial retro -> HALT

---

## Step 2: Load Project Documents

Load input files for comprehensive analysis:

| Input | Pattern | Strategy |
|-------|---------|----------|
| Epics | `{{PLANNING_ARTIFACTS}}/*epic*.md` | Load specific epic for {{epic_number}} |
| Previous Retro | `{{IMPLEMENTATION_ARTIFACTS}}/**/epic-{{prev_epic_num}}-retro-*.md` | Load if exists |
| Architecture | `{{PLANNING_ARTIFACTS}}/*architecture*.md` | Full load |
| PRD | `{{PLANNING_ARTIFACTS}}/*prd*.md` | Full load |
| Project Context | `**/project-context.md` | Load if exists |

---

## Step 3: Deep Story Analysis — Extract Lessons from Implementation

### BAT BUOC: Read EVERY story file for this epic

For each story in the epic, read the complete story file from `{{IMPLEMENTATION_ARTIFACTS}}/{{epic_num}}-{{story_num}}-*.md`

Extract and analyze from each story:

**Dev Notes and Struggles:**
- Where developers struggled or made mistakes
- Unexpected complexity or gotchas discovered
- Technical decisions that didn't work out
- Where estimates were way off

**Review Feedback Patterns:**
- Recurring feedback themes across stories
- Which types of issues came up repeatedly
- Quality concerns or architectural misalignments
- Praise or exemplary work

**Lessons Learned:**
- Explicit lessons documented during development
- "Aha moments" or breakthroughs
- What would be done differently

**Technical Debt Incurred:**
- Shortcuts taken and why
- Debt items affecting next epic
- Severity and priority of debt items

**Testing and Quality Insights:**
- Testing challenges or surprises
- Bug patterns or regression issues
- Test coverage gaps

### Synthesize Patterns Across All Stories

- **Common Struggles**: Issues in 2+ stories (e.g., "3 of 5 stories had API auth issues")
- **Recurring Review Feedback**: Themes across reviews
- **Breakthrough Moments**: Key discoveries, innovations worth repeating
- **Velocity Patterns**: Trends in completion speed
- **Team Collaboration Highlights**: Moments of excellent collaboration, effective pair/mob programming, problem-solving sessions worth repeating

---

## Step 4: Load and Integrate Previous Retrospective

If previous epic ({{epic_number}} - 1) has a retrospective:

1. Read the previous retro document
2. Extract: action items, lessons learned, process improvements, technical debt flagged
3. **Cross-reference with current epic execution:**
   - For each previous action item: mark as Completed / In Progress / Not Addressed
   - For each previous lesson: check if team applied it
   - For each process change: assess if it helped
   - For each debt item: check if addressed

If no previous retro exists or this is Epic 1:
- Note this is the first retrospective

---

## Step 5: Preview Next Epic

Calculate next epic number = {{epic_number}} + 1

If next epic exists in planning artifacts:
1. Load and analyze:
   - Epic title and objectives
   - Planned stories and complexity
   - Dependencies on current epic's work
   - New technical requirements
   - Potential risks

2. Identify dependencies on completed work
3. Note preparation gaps (technical setup, knowledge, refactoring)
4. Check technical prerequisites

If next epic NOT found:
- Note "no next epic defined" and proceed with retro

---

## Step 6: Initialize Retrospective Discussion

Present epic summary with metrics:

**Delivery Metrics:**
- Completed: {{completed_stories}}/{{total_stories}} stories
- Velocity and duration information

**Quality and Technical:**
- Blockers encountered
- Technical debt items
- Test coverage info

**Business Outcomes:**
- Goals achieved
- Success criteria status

If next epic exists, show preview with dependencies and preparation needed.

ASK user: "Any questions before we dive in?"
WAIT for user response.

---

## Step 7: Epic Review Discussion — What Went Well, What Didn't

### BAT BUOC: Interactive discussion with user

**Phase 1: Successes**
- Present top successes surfaced from story analysis
- ASK: "What stood out to you as going well in this epic?"
- WAIT for user response
- Build on their input

**Phase 2: Challenges**
- Transition to challenges with care (psychological safety)
- Present patterns found in story analysis
- ASK: "Where did you see the biggest challenges?"
- WAIT for user response
- Focus on systemic understanding, NOT blame

**Phase 3: Pattern Discussion**
- Present cross-story patterns from Step 3
- ASK user to validate or add their observations
- WAIT for response

**Phase 4: Previous Retro Follow-Through** (if applicable)
- Review action items from previous retro
- Present completion status
- ASK: "Looking at what we committed to last time — what's your reaction?"
- WAIT for response

**Summary:**
Present synthesized themes:
- **Successes**: Top success themes
- **Challenges**: Top challenge themes
- **Key Insights**: Most important learnings
ASK: "Does that capture it? Anything important we missed?"

---

## Step 8: Next Epic Preparation Discussion

Skip if no next epic exists.

Facilitate discussion covering:
- Dependencies on completed work — are prerequisites solid?
- Technical setup and infrastructure needs
- Knowledge gaps to fill
- Refactoring or debt reduction needed
- Testing infrastructure requirements

### BAT BUOC: Get user input on preparation strategy

ASK: "The team is surfacing concerns. What's your sense of readiness?"
WAIT for response.

Categorize preparation tasks:
1. **CRITICAL** (Must complete before epic starts)
2. **PARALLEL** (Can happen during early stories)
3. **NICE-TO-HAVE** (Would help but not blocking)

ASK user to validate preparation plan.

---

## Step 9: Synthesize Action Items

### BAT BUOC: All action items must be SMART

Create specific action items with:
- Clear description
- Assigned owner
- Timeline/deadline
- Success criteria
- Category (process, technical, documentation, team)

**Structure output into sections:**

**Process Improvements:**
- Numbered action items with owners and deadlines

**Technical Debt:**
- Prioritized debt items with owners and effort estimates

**Documentation Needs:**
- Documentation action items

**Team Agreements:**
- Commitments for working differently

**Next Epic Preparation Tasks:**
- Technical setup tasks
- Knowledge development tasks
- Cleanup/refactoring tasks

**Critical Path:**
- Blockers that MUST be resolved before next epic

### Significant Change Detection

Check if retrospective discoveries require epic updates (10 triggers):
- Architectural assumptions proven wrong during implementation
- Major scope changes or descoping that affects next epic
- Technical approach needs fundamental change
- Dependencies discovered that next epic doesn't account for
- User needs significantly different than originally understood
- Performance/scalability concerns that affect next epic design
- Security or compliance issues discovered that change approach
- Integration assumptions proven incorrect
- Team capacity or skill gaps more severe than planned
- Technical debt level unsustainable without intervention

If significant changes detected:
- Flag as "SIGNIFICANT DISCOVERY ALERT"
- List wrong assumptions vs actual reality
- Recommend: review and update next epic definition
- ASK user how to handle

---

## Step 10: Critical Readiness Exploration

### BAT BUOC: Interactive deep dive before closing

Before closing the retrospective, conduct a final readiness check to ensure Epic {{epic_number}} is truly complete — not just "stories done" but production-ready.

Explore these areas through natural team conversation:

**Testing & Quality State:**
- ASK user: "Tell me about the testing for this epic. What verification has been done?"
- WAIT for response
- Dana (QA Engineer) adds additional testing context
- Assess: Is the epic production-ready from a quality perspective?
- If concerns → capture specific testing work still needed, add to critical path

**Deployment & Release Status:**
- ASK user: "What's the deployment status? Live in production, scheduled, or pending?"
- WAIT for response
- If not yet deployed → factor into next epic timing
- Clarify deployment timeline and dependencies

**Stakeholder Acceptance:**
- ASK user: "Have stakeholders seen and accepted the deliverables?"
- WAIT for response
- Alice (Product Owner) reinforces importance: "I've seen 'done' epics get rejected and force rework"
- If acceptance incomplete → consider adding to critical path

**Technical Health & Stability:**
- ASK user: "How does the codebase feel after this epic? Stable and maintainable, or fragile?"
- WAIT for response
- Charlie (Senior Dev) helps articulate technical concerns
- If stability concerns → identify specific work needed, estimate effort

**Unresolved Blockers:**
- ASK user: "Any unresolved blockers or technical issues we're carrying forward?"
- WAIT for response
- If blockers identified → assign ownership, add to critical path with priority and deadline

### Synthesize Readiness Assessment

Present structured assessment:
- Testing & Quality: status + action needed (if any)
- Deployment: status + scheduled date (if pending)
- Stakeholder Acceptance: status + action needed (if incomplete)
- Technical Health: status + action needed (if concerns)
- Unresolved Blockers: status + must-resolve list (if any)

ASK user to confirm or correct the assessment.

Conclude: Epic is either "fully complete and clear to proceed" or "complete from a story perspective, but has N critical items before next epic."

---

## Step 11: Generate Retrospective Document

### BAT BUOC: Write complete retro document

Save to: `{{IMPLEMENTATION_ARTIFACTS}}/epic-{{epic_number}}-retro-{{DATE}}.md`

Document must include:
1. Epic summary and metrics
2. What went well (with specific examples)
3. What didn't go well (with root causes)
4. Key insights and patterns
5. Previous retro follow-through status (if applicable)
6. Action items (SMART format)
7. Next epic preparation plan
8. Critical path items
9. Team agreements
10. Readiness assessment (from Step 10)
11. Significant discoveries and epic update recommendations (if any)

### Update Sprint Status

Update `sprint-status.yaml`:
- Set `epic-{{epic_number}}-retrospective` status to `done`
- Update `last_updated` timestamp

---

## Step 12: Final Summary and Handoff

Present final summary to user:

**Epic Review:**
- Epic {{epic_number}}: {{epic_title}} reviewed
- Retrospective Status: completed
- Retrospective saved: `{{IMPLEMENTATION_ARTIFACTS}}/epic-{{epic_number}}-retro-{{DATE}}.md`

**Commitments Made:**
- Action Items: {{action_count}}
- Preparation Tasks: {{prep_task_count}}
- Critical Path Items: {{critical_count}}

**Next Steps:**
1. Review retrospective summary document
2. Execute preparation sprint — complete critical path items + preparation tasks
3. Review action items in next standup — ensure ownership is clear, track progress
4. If significant discoveries detected: schedule epic planning review session before starting next epic. Do NOT start next epic until review is complete.
5. If no significant discoveries: begin next epic when preparation is complete — start creating stories with SM agent's `create-story`

**Team Performance:**
Summarize: stories delivered, velocity, key insights surfaced, significant discoveries count. Affirm team is well-positioned for next epic success.

If significant discoveries > 0: add reminder that epic update is required before starting next epic.

### Report Completion

Summarize:
- Retro document location
- Total action items count
- Critical path items count
- Next recommended step (prepare for next epic or plan next work)
