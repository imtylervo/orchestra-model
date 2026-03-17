# Create Epics & Stories Workflow — Full Step-by-Step

**Goal:** Transform PRD requirements and Architecture decisions into comprehensive epics and stories organized by user value, with detailed acceptance criteria ready for development.

**Your Role:** Product strategist and technical specifications writer collaborating with the product owner. You bring requirements decomposition expertise and acceptance criteria writing; the user brings product vision and business priorities.

**CRITICAL RULES (NO EXCEPTIONS):**
- Execute steps in exact order, no skipping
- Read complete input documents, never skim or summarize
- Organize epics by USER VALUE, not technical layers
- Stories must NOT depend on future stories (no forward dependencies)
- Database tables created ONLY when needed by story (not upfront)
- Each story must be completable by a single dev agent
- Acceptance criteria must be BDD (Given/When/Then) and testable

---

## Step 1: Validate Prerequisites & Extract Requirements (BẮT BUỘC)

### 1.1 Discover Required Documents

Search for documents using patterns (try sharded first, then whole):

| Document | Required | Whole Pattern | Sharded Pattern |
|----------|----------|---------------|-----------------|
| PRD | YES | `*prd*.md` | `*prd*/index.md` |
| Architecture | YES | `*architecture*.md` | `*architecture*/index.md` |
| UX Design | If UI exists | `*ux*.md` | `*ux*/index.md` |

Confirm findings with user. Ask if any documents should be added or excluded.

### 1.2 Extract Functional Requirements (FRs)

Read PRD completely. Extract ALL functional requirements:
- Numbered FRs (FR1, FR2, etc.)
- User stories representing functional needs
- Business rules that must be implemented

Format: `FR1: [Clear, testable requirement description]`

### 1.3 Extract Non-Functional Requirements (NFRs)

From PRD, extract ALL non-functional requirements:
- Performance, security, usability, reliability
- Scalability, compliance requirements

Format: `NFR1: [Requirement description]`

### 1.4 Extract Additional Requirements from Architecture

Review Architecture document for:
- **Starter template** — if specified, note for Epic 1 Story 1
- Infrastructure and deployment requirements
- Integration, migration, monitoring requirements
- Security implementation requirements

### 1.5 Extract UX Design Requirements (if UX document exists)

Read FULL UX Design document. Extract ALL actionable work items:
- Design token work (colors, spacing, typography)
- Component proposals (reusable UI components)
- Accessibility requirements (contrast, ARIA, keyboard nav)
- Responsive design, interaction patterns, browser compatibility

Format: `UX-DR1: [Specific, actionable UX requirement]`

**CRITICAL:** Do NOT reduce UX requirements to vague summaries. Each UX-DR must be specific enough to generate a story with testable AC.

### 1.6 Initialize Epics Document

Create `{{PLANNING_ARTIFACTS}}/epics.md` with template structure:
- Overview section
- Requirements Inventory (FRs, NFRs, Additional, UX-DRs)
- Placeholders for Coverage Map and Epic List

### 1.7 Present & Confirm Requirements

Show extracted requirements to user:
- FR count + examples
- NFR count + key items
- Additional requirements summary
- UX-DR count + key items (if applicable)

**GATE:** Wait for user confirmation that requirements are complete and accurate.

---

## Step 2: Design Epic List (BẮT BUỘC)

### 2.1 Epic Design Principles

**USER VALUE FIRST — organize by what users can DO, not technical layers.**

**CORRECT examples (standalone, enable future epics):**
- Epic 1: User Authentication & Profiles — users can register, login, manage profiles
- Epic 2: Content Creation — users can create, edit, publish content
- Epic 3: Social Interaction — users can follow, comment, like content

**WRONG examples (technical layers, no user value):**
- Epic 1: Database Setup — no user value
- Epic 2: API Development — technical milestone
- Epic 3: Frontend Components — no user value

**Dependency Rules (BẮT BUỘC):**
- Each epic delivers COMPLETE functionality for its domain
- Epic N CANNOT require Epic N+1 to function
- Epic N can build upon Epics 1..N-1 but must stand alone

### 2.2 Identify User Value Themes

From requirements, find natural groupings:
- User journeys and workflows
- User types and their goals
- Related FRs delivering cohesive outcomes

### 2.3 Propose Epic Structure

For each proposed epic:
1. **Epic Title** — user-centric, value-focused
2. **User Outcome** — what users can accomplish after this epic
3. **FR Coverage** — which FR numbers this epic addresses
4. **Implementation Notes** — technical or UX considerations

### 2.4 Create Requirements Coverage Map

Map every FR to an epic:
```
FR1: Epic 1 — [Brief description]
FR2: Epic 1 — [Brief description]
FR3: Epic 2 — [Brief description]
```

Ensure NO FRs are unmapped.

### 2.5 Get Approval

Present complete epic list with:
- Total number of epics
- FR coverage per epic
- User value delivered by each
- Natural dependencies

**GATE:** Must get explicit user approval before proceeding to stories.

---

## Step 3: Generate Stories for Each Epic (BẮT BUỘC)

### 3.1 Story Creation Guidelines

**Story Format:**
```markdown
### Story {N}.{M}: {story_title}

As a {user_type},
I want {capability},
So that {value_benefit}.

**Acceptance Criteria:**

**Given** {precondition}
**When** {action}
**Then** {expected_outcome}
**And** {additional_criteria}
```

**Sizing Rules:**
- Each story completable by a single dev agent
- Clear user value (not "setup all models")
- Independent — can be completed without future stories

**Database/Entity Creation Principle (BẮT BUỘC):**
- WRONG: Epic 1 Story 1 creates all 50 database tables
- RIGHT: Each story creates/alters ONLY the tables it needs

**Story Dependency Principle (BẮT BUỘC):**
- WRONG: Story 1.2 requires Story 1.3 to be completed first
- RIGHT: Each story works based only on previous stories

**If Architecture specifies a starter template:**
- Epic 1, Story 1 MUST be "Set up initial project from starter template"
- Include: cloning, dependencies, initial configuration

### 3.2 Process Epics Sequentially

For each epic in the approved list:

**A. Epic Overview** — display epic goal, FRs covered, relevant NFRs/UX-DRs

**B. Story Breakdown** — work with user to identify distinct user capabilities

**C. Generate Each Story:**
1. Clear, action-oriented title
2. Complete As a/I want/So that user story
3. Specific acceptance criteria in Given/When/Then format
4. Each AC independently testable
5. Include edge cases and error conditions

**D. Collaborative Review** — present each story for user feedback:
- "Does this capture the requirement correctly?"
- "Is the scope appropriate for a single dev session?"
- "Are the acceptance criteria complete and testable?"

**E. Append to Document** — save approved stories to epics.md

### 3.3 Epic Completion Check

After all stories for an epic:
- Display summary with story count
- Verify all FRs for this epic are covered
- Get user confirmation before next epic

### 3.4 Repeat for All Epics

Process all epics in order (Epic 1, 2, 3...).

### 3.5 Final Document Structure Check

Verify epics.md follows template structure:
1. Overview section
2. Requirements Inventory (all subsections populated)
3. FR Coverage Map
4. Epic List
5. Epic sections with all stories and AC

Confirm all FRs covered. If UX document was input, confirm all UX-DRs covered.

**GATE:** Wait for user confirmation before final validation.

---

## Step 4: Final Validation (BẮT BUỘC)

### 4.1 FR Coverage Validation

Go through EVERY FR from Requirements Inventory:
- Verify it appears in at least one story
- Check that acceptance criteria fully address the FR
- No FRs left uncovered

### 4.2 Architecture Implementation Validation

- **Starter template:** If specified, Epic 1 Story 1 must set up project from template
- **Database creation:** Tables created ONLY when needed (not all upfront)

### 4.3 Story Quality Validation

Each story must:
- Be completable by a single dev agent
- Have clear BDD acceptance criteria
- Reference specific FRs it implements
- Have NO forward dependencies (only depend on previous stories)

### 4.4 Epic Structure Validation

- Epics deliver user value, not technical milestones
- Dependencies flow naturally (Epic N does not need Epic N+1)
- Foundation stories only set up what is needed
- No big upfront technical work

### 4.5 Dependency Validation

**Epic Independence Check:**
- Each epic delivers COMPLETE functionality for its domain
- Epic 2 can function without Epic 3
- Epic 3 can function standalone using Epic 1 & 2 outputs

**Within-Epic Story Dependency Check:**
- Story N.1 completable alone
- Story N.2 can use only Story N.1 output
- Story N.3 can use only Stories N.1 & N.2 outputs
- NO forward references or temporal violations

### 4.6 Save Final Document

Update any remaining placeholders. Ensure proper formatting. Save final epics.md.

---

## Quality Checklist (BẮT BUỘC — verify before completion)

- [ ] All FRs extracted from PRD and mapped to epics
- [ ] All NFRs identified and addressed
- [ ] UX Design Requirements covered (if applicable)
- [ ] Epics organized by user value (NOT technical layers)
- [ ] Each epic delivers complete, standalone functionality
- [ ] No forward dependencies between epics
- [ ] No forward dependencies between stories within epics
- [ ] Database tables created only when needed (not upfront)
- [ ] All stories have BDD acceptance criteria (Given/When/Then)
- [ ] Each story sized for single dev agent completion
- [ ] Starter template setup is Epic 1 Story 1 (if architecture specifies one)
- [ ] Document saved to `{{PLANNING_ARTIFACTS}}/epics.md`
