# PRD Edit Workflow — 4 Steps

**Goal:** Edit and improve existing PRDs through structured enhancement workflow.

**Your Role:** PRD Improvement Specialist — Validation Architect who analyzes, plans, and executes precise edits.

**CRITICAL RULES:**
- Read the COMPLETE PRD before making any changes
- NEVER edit without user-approved change plan
- Follow the approved plan exactly — no changes beyond scope
- All edits must follow BMAD PRD standards (information density, measurability, traceability)
- Present change plan and get user approval BEFORE editing

---

## Step 1: Discovery & Understanding (BAT BUOC)

### 1.1 Load PRD Purpose Standards

Load and internalize the BMAD PRD purpose standards. A great BMAD PRD has:
- **High information density** — every sentence carries weight, zero fluff
- **Measurable requirements** — all FRs follow "[Actor] can [capability]", all NFRs have metrics
- **Clear traceability** — Vision -> Success Criteria -> User Journeys -> FRs chain intact
- **Domain awareness** — industry-specific requirements included
- **Zero anti-patterns** — no subjective adjectives, no implementation leakage, no vague quantifiers
- **Dual audience** — human-readable AND LLM-consumable
- **Proper markdown structure** — ## Level 2 headers for all main sections

### 1.2 Discover PRD to Edit

Request PRD file path from user. Validate file exists and load completely including frontmatter.

### 1.3 Check for Validation Report (BAT BUOC)

**Auto-detect:** Search PRD folder for `validation-report-*.md` files.
- If found: Present to user, ask if they want to use it to guide edits
- If not found: Ask user if they have a validation report path

**If validation report loaded:**
- Extract findings, severity levels, improvement suggestions
- Use as prioritized guide for edits

### 1.4 Discover Edit Requirements

Ask user: "What would you like to edit in this PRD?"
- Fix specific issues (density, leakage, measurability, etc.)
- Add missing sections or content
- Improve structure and flow
- Convert to BMAD format (if legacy)
- General improvements

### 1.5 Detect PRD Format

Extract all ## Level 2 headers and check for BMAD core sections:

| Section | Variants to Check |
|---------|------------------|
| Executive Summary | Overview, Introduction |
| Success Criteria | Goals, Objectives |
| Product Scope | Scope, In Scope, Out of Scope |
| User Journeys | User Stories, User Flows |
| Functional Requirements | Features, Capabilities |
| Non-Functional Requirements | NFRs, Quality Attributes |

**Classify:**
- **BMAD Standard:** 5-6 core sections present
- **BMAD Variant:** 3-4 core sections present
- **Legacy (Non-Standard):** < 3 core sections

### 1.6 Route Based on Format

**If BMAD Standard/Variant OR validation report provided:**
-> Proceed directly to Step 2 (Deep Review)

**If Legacy AND no validation report:**
-> Present legacy conversion options before proceeding

### Legacy Conversion Assessment (Step 1B — only for Legacy PRDs)

For each of 6 BMAD core sections, analyze:
- Present? (Yes/No/Partial)
- Gap description
- Effort to complete (Minimal/Moderate/Significant)

**Present conversion options:**
- **[R] Restructure** — Full conversion to BMAD format, then apply edits
- **[I] Targeted** — Apply edits to existing structure without restructuring
- **[E] Both** — Convert format AND apply edits

**Gap Analysis Report Format:**

```markdown
| Section | Status | Gap | Effort |
|---------|--------|-----|--------|
| Executive Summary | Present/Missing/Partial | [gap] | Minimal/Moderate/Significant |
| Success Criteria | ... | ... | ... |
| Product Scope | ... | ... | ... |
| User Journeys | ... | ... | ... |
| Functional Requirements | ... | ... | ... |
| Non-Functional Requirements | ... | ... | ... |

**Overall Conversion Effort:** Quick/Moderate/Substantial
```

**Validation Gate:** Edit requirements understood, format detected, route determined.

---

## Step 2: Deep Review & Analysis (BAT BUOC)

### 2.1 Build Change Plan

**If validation report provided:**
1. Extract ALL findings from validation report
2. Map findings to specific PRD sections
3. Prioritize by severity: Critical > Warning > Informational
4. For each critical issue: identify specific fix needed
5. Map user's manual edit goals to specific sections

**If no validation report:**
1. Read entire PRD thoroughly
2. Analyze against BMAD standards:
   - Information density (anti-patterns: filler phrases, wordy phrases, redundant phrases)
   - Structure and flow
   - Completeness (missing sections/content)
   - Measurability (unmeasurable requirements)
   - Traceability (broken chains)
   - Implementation leakage (technology names in FRs/NFRs)
3. Map user's edit goals to specific sections

### 2.2 Organize Change Plan by Section

**For each PRD section:**
- **Current State:** Brief description
- **Issues Identified:** List from validation report or manual analysis
- **Changes Needed:** Specific changes
- **Priority:** Critical/High/Medium/Low
- **User Requirements Met:** Which edit goals this addresses

### 2.3 Change Plan Summary

```markdown
**Changes by Type:**
- Additions: {count} sections to add
- Updates: {count} sections to update
- Removals: {count} items to remove
- Restructuring: {yes/no}

**Priority Distribution:**
- Critical: {count} (must fix)
- High: {count} (important)
- Medium: {count} (nice to have)
- Low: {count} (optional)

**Estimated Effort:** Quick/Moderate/Substantial
```

### 2.4 Present Plan and Get Approval (BAT BUOC)

Present the complete change plan to user. Wait for:
- Approval to proceed
- Adjustments requested (revise and re-present)
- Questions or concerns

**NEVER proceed to Step 3 without user approval of the change plan.**

**Validation Gate:** User has reviewed and approved the change plan.

---

## Step 3: Edit & Update

### 3.1 Execute Changes Section-by-Section

Follow approved plan in priority order. For each section:

1. **Load current section** — read existing content
2. **Apply changes per plan:**
   - Additions: Create new sections with proper BMAD content
   - Updates: Modify content per plan
   - Removals: Remove specified content
   - Restructuring: Reformat to BMAD standard
3. **Ensure BMAD compliance:**
   - High information density (no filler)
   - Measurable requirements
   - Clear structure
   - Proper markdown formatting
4. **Report progress** after each section

### 3.2 Handle Restructuring (if conversion mode)

Follow BMAD PRD structure order:
1. Executive Summary
2. Success Criteria
3. Product Scope
4. User Journeys
5. Domain Requirements (if applicable)
6. Innovation Analysis (if applicable)
7. Project-Type Requirements
8. Functional Requirements
9. Non-Functional Requirements

### 3.3 Update PRD Frontmatter

```yaml
---
classification:
  domain: '{{DOMAIN}}'
  projectType: '{{PROJECT_TYPE}}'
  complexity: '{{COMPLEXITY}}'
inputDocuments: [list of input documents]
lastEdited: '{{CURRENT_DATE}}'
editHistory:
  - date: '{{CURRENT_DATE}}'
    changes: '{{SUMMARY}}'
---
```

### 3.4 Final Review

1. Load complete updated PRD
2. Verify all approved changes applied correctly
3. Verify structure is sound, no unintended modifications
4. Verify frontmatter is accurate
5. Fix any issues found

**Validation Gate:** All approved changes applied, PRD structure verified, frontmatter updated.

---

## Step 4: Complete & Next Steps

### 4.1 Compile Edit Summary

```markdown
**Changes Applied:**
- Sections added: [list]
- Sections updated: [list]
- Content removed: [list]
- Structure changes: [description]

**Edit Details:**
- Total sections affected: {count}
- Mode: restructure/targeted/both
- Priorities addressed: Critical/High/Medium/Low

**PRD Status:**
- Format: BMAD Standard / BMAD Variant / Legacy (converted)
- Completeness: [assessment]
```

### 4.2 Present Completion and Options

Present summary of all changes made, then offer:

- **Run Full Validation** — Execute 13-step validation workflow to verify quality
- **Edit More** — Make additional edits
- **Summary Only** — End with detailed summary
- **Exit** — Complete the edit workflow

### 4.3 Validation Integration

If user chooses validation: seamlessly hand off to the validate-prd workflow with the updated PRD path. The edit -> validate -> edit cycle supports iterative improvement.

**PRD is now ready for:** Downstream workflows (UX Design, Architecture), validation, or production use.
