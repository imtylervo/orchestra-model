# PRD Creation Workflow — 8 Steps

**Goal:** Create a comprehensive BMAD-standard PRD from Product Brief and other input documents.

**Your Role:** Product Manager and PRD Architect — transform product vision into a structured, measurable, traceable PRD that serves both humans and LLMs.

**CRITICAL RULES (BAT BUOC):**
- Read ALL input documents completely before starting
- Every FR must follow "[Actor] can [capability]" format
- Every NFR must have: criterion, metric, measurement method, context
- Zero implementation leakage in requirements — specify WHAT, not HOW
- Maximum information density — no filler, no fluff, every sentence carries weight
- Maintain traceability chain: Vision -> Success Criteria -> User Journeys -> FRs

**Output:** `{{PLANNING_ARTIFACTS}}/prd.md` (or sharded into folder)

---

## BMAD PRD Quality Standards

### Information Density Anti-Patterns (FORBIDDEN)
- "The system will allow users to..." -> "Users can..."
- "It is important to note that..." -> State the fact directly
- "In order to..." -> "To..."
- "Due to the fact that" -> "because"
- Subjective adjectives in FRs: easy, fast, simple, intuitive, user-friendly
- Vague quantifiers: multiple, several, some, many, few, various

### FR Format: "[Actor] can [capability]"
- Good: "Users can reset their password via email link"
- Bad: "System sends JWT via email and validates with database" (implementation leakage)
- Good: "Dashboard loads in under 2 seconds for 95th percentile"
- Bad: "Fast loading time" (subjective, unmeasurable)

### NFR Template: All 4 required
1. **Criterion** — what quality attribute
2. **Metric** — measurable target
3. **Measurement method** — how to verify
4. **Context** — conditions and scope

---

## Step 1: Discovery & Context Loading (BAT BUOC)

### 1.1 Load Input Documents
1. Search for and load:
   - Product Brief (`*brief*.md`) — PRIMARY input
   - Research documents, competitive analysis
   - Project Context (`**/project-context.md`)
   - Existing documentation in `{{PLANNING_ARTIFACTS}}/` and `docs/`
2. For sharded folders: load ALL files via index.md first
3. **Confirm with user** what was found + ask for additional docs
4. Load ALL confirmed documents completely

### 1.2 Extract Key Information
From Product Brief and other docs, extract:
- **Vision** — what is this product?
- **Problem** — what problem does it solve?
- **Target users** — who is it for?
- **Key features** — what are the capabilities?
- **Goals** — what defines success?
- **Differentiators** — what makes it unique?
- **Constraints** — technical, business, regulatory

### 1.3 Classify Project
Determine from context:
- **Domain:** General, Healthcare, Fintech, GovTech, EdTech, etc.
- **Project Type:** web_app, api_backend, mobile_app, desktop_app, cli_tool, library_sdk, etc.
- **Complexity:** Low, Medium, High

**Validation Gate:** All input docs loaded, key information extracted, classification determined.

---

## Step 2: Domain & Project-Type Research

### 2.1 Domain-Specific Requirements

**If high-complexity domain:**

| Domain | Required Sections to Include |
|--------|------------------------------|
| Healthcare | Clinical Requirements, Regulatory Pathway (FDA/HIPAA), Safety, HIPAA Compliance |
| Fintech | Compliance Matrix (SOC2/PCI-DSS/GDPR), Security Architecture, Audit, Fraud Prevention |
| GovTech | Accessibility (WCAG 2.1 AA/508), Procurement Compliance, Security Clearance, Data Residency |
| Aerospace | Safety Certification (DO-178C), Simulation Validation, Export Compliance |
| Automotive | Safety Standards (ISO 26262), Functional Safety, Certification |
| LegalTech | Ethics Compliance, Data Retention, Confidentiality |

**If low-complexity domain:** Note as general/standard, no special sections needed.

### 2.2 Project-Type Requirements

| Type | Required Sections | Skip Sections |
|------|------------------|---------------|
| api_backend | Endpoint Specs, Auth Model, Data Schemas, API Versioning | UX/UI, visual design |
| web_app | User Journeys, UX/UI, Responsive Design | (none) |
| mobile_app | Platform Reqs, Device Permissions, Offline Mode | Desktop-specific |
| cli_tool | Command Structure, Output Formats, Config Schema | Visual Design, Touch |
| library_sdk | API Surface, Usage Examples, Integration Guide | UX/UI, deployment |
| saas_b2b | Tenant Model, RBAC Matrix, Subscription Tiers | (none) |

### 2.3 Present Findings to User
Report domain classification, project type, and what special sections will be included. Get user confirmation.

**Validation Gate:** Domain and project type confirmed, required sections identified.

---

## Step 3: Executive Summary & Success Criteria (BAT BUOC)

### 3.1 Write Executive Summary

Collaborate with user to create:
- **Product Vision** — 2-3 sentences capturing the product's purpose and value
- **Problem Statement** — clear articulation of the problem being solved
- **Target Users** — specific user types with brief descriptions
- **Key Differentiators** — what makes this product unique
- **High-Level Approach** — how the product solves the problem

**Density check:** Every sentence must carry information weight. No filler.

### 3.2 Define Success Criteria

For each success criterion, ensure SMART quality:
- **Specific** — clear, unambiguous
- **Measurable** — quantifiable metric
- **Attainable** — realistic
- **Relevant** — aligned with vision
- **Traceable** — links to business objective

Example format:
```markdown
**SC-001:** Achieve {metric} within {timeframe} as measured by {method}
```

### 3.3 Begin Traceability Chain
Map each success criterion to the vision statement. This chain will extend through all subsequent steps.

**Validation Gate:** Executive summary captures vision clearly, all success criteria are SMART.

---

## Step 4: Product Scope & User Journeys (BAT BUOC)

### 4.1 Define Product Scope

**In-Scope (MVP):**
- List specific features and capabilities for first release
- Be explicit — no ambiguity about what's included

**Out-of-Scope:**
- List features explicitly excluded from MVP
- Note which might be addressed in future phases

**Future Phases (optional):**
- Growth phase features
- Vision phase features

### 4.2 Create User Journeys

For each user type identified in Executive Summary:

```markdown
### [User Type] Journey: [Journey Name]

**Context:** [When/where this journey occurs]
**Goal:** [What user wants to accomplish]

**Journey Steps:**
1. [Step with user action and system response]
2. [Step with decision point]
3. [Step with success outcome]

**Success Outcome:** [What success looks like]
**Alternative Paths:** [Error cases, edge cases]
```

**Requirements:**
- Cover ALL user types
- Include primary and secondary journeys
- Document error/edge case paths
- Each journey must connect to success criteria

### 4.3 Extend Traceability Chain
Map: Success Criteria -> User Journeys (which journeys support which criteria?)

**Validation Gate:** Scope clearly defined, all user types have journeys, traceability maintained.

---

## Step 5: Functional Requirements (BAT BUOC)

### 5.1 Extract FRs from User Journeys

For each user journey, derive functional requirements. Every FR must:
- Follow "[Actor] can [capability]" format
- Be testable and measurable
- Contain NO subjective adjectives (easy, fast, simple, intuitive)
- Contain NO vague quantifiers (multiple, several, some, many)
- Contain NO implementation details (React, PostgreSQL, AWS, etc.)
- Trace back to a user journey

### 5.2 FR Format

```markdown
**FR-001:** [Actor] can [capability]
- **Source:** [User Journey reference]
- **Priority:** [Must/Should/Could]
- **Acceptance Criteria:** [Testable condition]
```

### 5.3 Validation Checks (BAT BUOC)

Run these checks on EVERY FR:

**Format check:** Does it follow "[Actor] can [capability]"?
**Subjective adjective scan:** easy, fast, simple, intuitive, user-friendly, responsive, quick, efficient
**Vague quantifier scan:** multiple, several, some, many, few, various, number of
**Implementation leakage scan:** Technology names, library names, data structures
**Traceability check:** Does it trace to a user journey?

### 5.4 Extend Traceability Chain
Map: User Journeys -> FRs (which FRs support which journeys?)
Flag any orphan FRs (no traceable source).

**Validation Gate:** All FRs follow BMAD format, zero anti-patterns, full traceability.

---

## Step 6: Non-Functional Requirements

### 6.1 Define NFRs

For each quality attribute, create NFRs with ALL 4 template elements:

```markdown
**NFR-001:** [Quality Attribute]
- **Criterion:** [What is being measured]
- **Metric:** [Specific measurable target]
- **Measurement Method:** [How to verify]
- **Context:** [Conditions, scope, who it affects]
```

### 6.2 Common NFR Categories

- **Performance:** Response times, throughput, latency
- **Scalability:** Concurrent users, data volume, growth capacity
- **Availability:** Uptime targets, recovery time
- **Security:** Authentication, authorization, encryption, compliance
- **Reliability:** Error rates, data integrity, failover
- **Usability:** Accessibility level (WCAG), learning curve metrics
- **Maintainability:** Code coverage, deployment frequency

### 6.3 NFR Anti-Pattern Check

- "The system shall be scalable" -> "Handle 10x load growth through horizontal scaling"
- "High availability" -> "99.9% uptime as measured by cloud provider SLA"
- "Response time under 1 second" -> "API response time under 1s for 95th percentile under normal load"

**Validation Gate:** All NFRs have all 4 template elements, no unmeasurable claims.

---

## Step 7: Domain & Project-Type Sections

### 7.1 Domain Requirements (if high-complexity domain)

Write domain-specific sections identified in Step 2. Each must contain:
- Regulatory requirements with specific standards referenced
- Compliance measures and verification methods
- Safety/security requirements specific to domain

### 7.2 Project-Type Requirements

Write project-type-specific sections identified in Step 2:
- Required sections for this project type (e.g., Endpoint Specs for API, Platform Reqs for mobile)
- Exclude sections not relevant (e.g., UX/UI for API backend)

### 7.3 Innovation Analysis (if applicable)

If the product has novel/differentiating features:
- Competitive differentiation analysis
- Innovation approach and risk assessment
- Market positioning

**Validation Gate:** Domain-specific sections complete, project-type sections included.

---

## Step 8: Assembly & Final Validation (BAT BUOC)

### 8.1 Assemble PRD Document

Write complete PRD with proper structure:

```markdown
---
classification:
  domain: '{{DOMAIN}}'
  projectType: '{{PROJECT_TYPE}}'
  complexity: '{{COMPLEXITY}}'
inputDocuments: [list]
date: '{{CURRENT_DATE}}'
---

# {{PROJECT_NAME}} — Product Requirements Document

## Executive Summary
[From Step 3]

## Success Criteria
[From Step 3]

## Product Scope
[From Step 4]

## User Journeys
[From Step 4]

## Domain Requirements (if applicable)
[From Step 7]

## Innovation Analysis (if applicable)
[From Step 7]

## Project-Type Requirements
[From Step 7]

## Functional Requirements
[From Step 5]

## Non-Functional Requirements
[From Step 6]
```

### 8.2 Final Quality Checks (BAT BUOC)

Run all validation checks on assembled document:

1. **Information Density:** Scan for filler phrases, wordy phrases, redundant phrases
2. **FR Format:** All follow "[Actor] can [capability]"
3. **FR Anti-Patterns:** No subjective adjectives, vague quantifiers, implementation leakage
4. **NFR Completeness:** All have criterion + metric + method + context
5. **Traceability:** Vision -> Criteria -> Journeys -> FRs chain intact, no orphans
6. **Completeness:** All required sections present, no template variables remaining
7. **Domain Compliance:** All required domain sections present (if high-complexity)
8. **Project-Type Compliance:** Required sections present, excluded sections absent
9. **Markdown Structure:** Proper ## headers, consistent formatting

### 8.3 Present PRD and Next Steps

Report:
- PRD location and size
- Quality check results
- Any remaining issues

**Suggest next steps:**
- **Run Validation** — Execute full 13-step validation workflow
- **Create UX Design** — Start UX design specification from this PRD
- **Create Architecture** — Start solution architecture from this PRD
- **Review with Stakeholders** — Share for human review

**PRD is the foundation. Quality here ripples through every subsequent phase. A dense, precise, well-traced PRD makes UX design, architecture, epic breakdown, and AI development dramatically more effective.**
