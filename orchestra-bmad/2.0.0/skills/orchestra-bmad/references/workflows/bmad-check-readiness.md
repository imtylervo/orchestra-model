# Implementation Readiness Check — Full Step-by-Step

**Goal:** Validate that PRD, Architecture, Epics and Stories are complete and aligned before Phase 4 implementation starts.

**Your Role:** Expert Product Manager and Scrum Master, renowned for requirements traceability and spotting gaps in planning. Your success is measured by finding failures others missed.

**CRITICAL RULES (NO EXCEPTIONS):**
- Execute steps in exact order, no skipping
- Read complete files, never skim or summarize
- Be direct — do not soften findings
- Provide specific examples for every problem found
- This is READ-ONLY — do NOT modify any project files
- Document ALL violations with evidence and remediation guidance

---

## Step 1: Document Discovery (BẮT BUỘC)

### 1.1 Search and Inventory All Documents

Search for each type using patterns:

| Type | Whole | Sharded |
|------|-------|---------|
| PRD | `*prd*.md` | `*prd*/index.md` + related |
| Architecture | `*architecture*.md` | `*architecture*/index.md` + related |
| Epics & Stories | `*epic*.md` | `*epic*/index.md` + related |
| UX Design | `*ux*.md` | `*ux*/index.md` + related |

### 1.2 Handle Issues

- **Duplicates (whole + sharded):** Flag as CRITICAL — must resolve before proceeding
- **Missing documents:** Flag as WARNING — will impact assessment completeness
- **Sharded files:** Group together, verify all parts present

### 1.3 Output: Document Inventory

List all found files with paths and sizes. Flag all issues.

**GATE:** Confirm file inventory with user. Resolve duplicates before proceeding.

---

## Step 2: PRD Analysis — Extract ALL Requirements (BẮT BUỘC)

### 2.1 Load PRD Completely

- Whole file: load entirely
- Sharded: load ALL files in folder — no skipping

### 2.2 Extract Functional Requirements (FRs)

Find numbered FRs, user stories, business rules, features with AC.
Format as: `FR1: [text]`, `FR2: [text]`, ... `Total FRs: [count]`

### 2.3 Extract Non-Functional Requirements (NFRs)

Performance, security, usability, reliability, scalability, compliance.

### 2.4 Extract Additional Requirements

Constraints, assumptions, technical requirements not labeled FR/NFR, integration requirements.

### 2.5 PRD Completeness Assessment

Initial assessment of PRD clarity and completeness.

---

## Step 3: Epic Coverage Validation (BẮT BUỘC)

### 3.1 Load Epics Document Completely

Load all epics and stories content (whole or sharded).

### 3.2 Create FR Coverage Matrix

| FR# | PRD Requirement | Epic Coverage | Status |
|-----|----------------|---------------|--------|
| FR1 | [text] | Epic X Story Y | Covered |
| FR2 | [text] | **NOT FOUND** | MISSING |

### 3.3 Document Missing Coverage

For each missing FR:
- **Impact:** why this is critical
- **Recommendation:** which epic should include this

### 3.4 Coverage Statistics

- Total PRD FRs: [count]
- FRs covered in epics: [count]
- Coverage percentage: [%]

---

## Step 4: UX Alignment

### 4.1 Search for UX Documentation

Search patterns: `*ux*.md` (whole), `*ux*/index.md` (sharded), UI-related terms in other docs.

### 4.2 If UX Document Exists

**A. UX <-> PRD Alignment:**
- UX requirements reflected in PRD?
- User journeys in UX match PRD use cases?
- UX requirements not covered in PRD?

**B. UX <-> Architecture Alignment:**
- Architecture supports UX requirements?
- Performance needs met (responsiveness, load times)?
- UI components supported by architecture?

### 4.3 If No UX Document

Assess if UX/UI is implied:
- Does PRD mention user interface?
- Are there web/mobile components implied?
- Is this a user-facing application?

**If UX implied but missing:** Add WARNING — UX documentation should exist for any user-facing application. Do not assume UX is not needed.

### 4.4 Flag UX Gaps

- Screens/flows without story coverage
- Stories referencing UX that does not exist
- Inconsistencies between UX spec and story requirements

### 4.5 Output: UX Alignment Assessment

```markdown
### UX Document Status
[Found/Not Found]

### Alignment Issues
[List any misalignments between UX, PRD, and Architecture]

### Warnings
[Any warnings about missing UX or architectural gaps]
```

---

## Step 5: Epic Quality Review (BẮT BUỘC)

### 5.1 Best Practices Validation Framework

Validate epics and stories against create-epics-and-stories standards. Any deviation is flagged as a defect.

### 5.2 User Value Focus Check

For each epic:
- **Epic Title:** Is it user-centric (what user can do)?
- **Epic Goal:** Does it describe user outcome?
- **Value Proposition:** Can users benefit from this epic alone?

**Red flags (violations):**
- "Setup Database" or "Create Models" — no user value
- "API Development" — technical milestone, not user value
- "Infrastructure Setup" — not user-facing
- "Authentication System" — borderline (reframe as user value)

Do NOT accept "technical milestones" as epics. Technical epics with no user value are **Critical violations**.

### 5.3 Epic Independence Validation (BẮT BUỘC)

Test epic independence sequentially:
- **Epic 1:** Must stand alone completely
- **Epic 2:** Can function using only Epic 1 output
- **Epic 3:** Can function using Epic 1 & 2 outputs
- **Rule:** Epic N CANNOT require Epic N+1 to work

**Forbidden pattern — forward dependencies:**
- "Epic 2 requires Epic 3 features to function"
- Stories in Epic 2 referencing Epic 3 components
- Circular dependencies between epics

Forward dependencies break the build-sequentially guarantee. Flag every instance.

### 5.4 Story Sizing Validation

Check each story:
- **Clear User Value:** Does the story deliver something meaningful?
- **Independent:** Can it be completed without future stories?
- **Appropriately Sized:** Not too large (epic-sized) or too small (task-level)

**Common violations:**
- "Setup all models" — not a USER story
- "Create login UI (depends on Story 1.3)" — forward dependency within epic

### 5.5 Acceptance Criteria Review

For each story's ACs:
- **Given/When/Then Format:** Proper BDD structure?
- **Testable:** Each AC can be verified independently?
- **Complete:** Covers all scenarios including errors?
- **Specific:** Clear expected outcomes, not vague

**Issues to find:**
- Vague criteria like "user can login" (not specific enough for TDD)
- Missing error conditions
- Incomplete happy path
- Non-measurable outcomes

### 5.6 Dependency Analysis (BẮT BUỘC)

**Within-Epic Dependencies:**
Map story dependencies within each epic:
- Story 1.1 must be completable alone
- Story 1.2 can use Story 1.1 output
- Story 1.3 can use Story 1.1 & 1.2 outputs

**Critical violations:**
- Forward references: "This story depends on Story 1.4"
- Temporal violations: "Wait for future story to work"
- Stories referencing features not yet implemented in sequence

**Database/Entity Creation Timing:**
- **Wrong:** Epic 1 Story 1 creates all tables upfront
- **Right:** Each story creates only the tables it needs
- **Check:** Are tables created only when first needed?

### 5.7 Starter Template Requirement

Check if Architecture specifies starter template:
- If YES: Epic 1 Story 1 must be "Set up initial project from starter template"
- Verify story includes cloning, dependencies, initial configuration

### 5.8 Best Practices Compliance Checklist

For each epic, verify ALL items:
- [ ] Epic delivers user value (not technical milestone)
- [ ] Epic can function independently (no forward deps)
- [ ] Stories appropriately sized
- [ ] No forward dependencies between stories
- [ ] Database tables created when needed (not upfront)
- [ ] Clear acceptance criteria (BDD, testable)
- [ ] Traceability to FRs maintained

### 5.9 Severity-Based Violation Documentation

**Critical Violations:**
- Technical epics with no user value
- Forward dependencies breaking independence
- Epic-sized stories that cannot be completed independently

**Major Issues:**
- Vague acceptance criteria insufficient for TDD
- Stories requiring future stories to function
- Database creation timing violations (all-upfront pattern)

**Minor Concerns:**
- Formatting inconsistencies
- Minor structure deviations
- Documentation gaps

Document every violation with specific examples and clear remediation guidance.

---

## Step 6: Final Assessment (BẮT BUỘC)

### 6.1 Compile All Findings

Review findings from all previous steps.

### 6.2 Determine Verdict

**READY** — All requirements covered, stories aligned with architecture, AC ready for TDD. Minor issues only (< 3 low-severity).

**NEEDS WORK** — Mostly aligned but notable gaps exist. 3-5 medium-severity issues that should be addressed but will not block implementation.

**NOT READY** — Critical gaps that MUST be addressed before Phase 4:
- Architecture <-> Stories mismatch (e.g., different API protocols)
- Multiple FRs without epic coverage
- AC too vague for TDD
- Circular or forward dependencies
- Technical epics without user value
- Major undeclared cross-epic dependencies

### 6.3 Generate Readiness Report

```markdown
## Implementation Readiness Report

**Date:** [date]
**Project:** [project_name]

### Verdict: [READY/NEEDS WORK/NOT READY]

### Critical Issues (Must Fix)
1. [Issue with evidence and recommendation]

### Major Issues (Should Fix)
1. [Issue with evidence and recommendation]

### Minor Issues (Nice to Fix)
1. [Issue with evidence and recommendation]

### Coverage Statistics
- FR Coverage: X/Y (Z%)
- Architecture Components with Stories: X/Y
- Stories with TDD-Ready AC: X/Y

### Epic Quality Summary
- Epics with user value: X/Y
- Forward dependency violations: [count]
- Best practices compliance: X/7 per epic average

### Recommended Next Steps
1. [Specific action]
2. [Specific action]
```

### 6.4 Save Report

Save readiness report to `{{PLANNING_ARTIFACTS}}/implementation-readiness-report.md`.

---

## Quality Checklist (BẮT BUỘC — verify before completion)

- [ ] All documents discovered and inventoried
- [ ] PRD read completely — ALL FRs and NFRs extracted
- [ ] FR coverage matrix created with specific epic/story mapping
- [ ] Missing FRs documented with impact and recommendation
- [ ] UX alignment assessed (or warning issued if implied but missing)
- [ ] Every epic validated for user value (no technical milestones accepted)
- [ ] Epic independence validated (no forward dependencies)
- [ ] Every story checked for forward dependencies
- [ ] Database creation timing validated (not all-upfront)
- [ ] Acceptance criteria reviewed for BDD format and testability
- [ ] Architecture alignment cross-checked
- [ ] All violations documented with severity, evidence, and remediation
- [ ] Final verdict determined with evidence
- [ ] Readiness report saved
