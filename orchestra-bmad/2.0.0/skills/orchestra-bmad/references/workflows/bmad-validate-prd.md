# PRD Validation Workflow — 13 Validation Steps

**Goal:** Validate existing PRD against BMAD standards through comprehensive 13-dimension review.

**Your Role:** Validation Architect and Quality Assurance Specialist.

**CRITICAL RULES (BAT BUOC):**
- Execute ALL 13 validation steps in order — no skipping
- Steps 3-12 auto-proceed (no user input needed between checks)
- Read PRD completely — NEVER skim or summarize
- Document ALL findings in validation report with line numbers
- Save validation report next to the PRD file

**Output:** Validation report at `{{PRD_FOLDER}}/validation-report-{{DATE}}.md`

---

## BMAD PRD Standards Reference

The PRD is the top of the required funnel that feeds all subsequent product development work in the BMad Method.

### What is a BMAD PRD?

A dual-audience document serving:
1. **Human Product Managers and builders** — Vision, strategy, stakeholder communication
2. **LLM Downstream Consumption** — UX Design -> Architecture -> Epics -> Development AI Agents

Each successive document becomes more AI-tailored and granular.

### Core Philosophy: Information Density

**High Signal-to-Noise Ratio** — Every sentence must carry information weight. LLMs consume precise, dense content efficiently.

**Anti-Patterns (Eliminate These):**
- "The system will allow users to..." -> "Users can..."
- "It is important to note that..." -> State the fact directly
- "In order to..." -> "To..."
- Conversational filler and padding -> Direct, concise statements

**Goal:** Maximum information per word. Zero fluff.

### The Traceability Chain

**PRD starts the chain:**
```
Vision -> Success Criteria -> User Journeys -> Functional Requirements -> (future: User Stories)
```

**In the PRD, establish:**
- Vision -> Success Criteria alignment
- Success Criteria -> User Journey coverage
- User Journey -> Functional Requirement mapping
- All requirements traceable to user needs

**Why:** Each downstream artifact (UX, Architecture, Epics, Stories) must trace back to documented user needs and business objectives. This chain ensures we build the right thing.

### What Makes Great Functional Requirements?

**FRs are Capabilities, Not Implementation**

- Good FR: "Users can reset their password via email link"
- Bad FR: "System sends JWT via email and validates with database" (implementation leakage)
- Good FR: "Dashboard loads in under 2 seconds for 95th percentile"
- Bad FR: "Fast loading time" (subjective, unmeasurable)

**SMART Quality Criteria:**
- **Specific:** Clear, precisely defined capability
- **Measurable:** Quantifiable with test criteria
- **Attainable:** Realistic within constraints
- **Relevant:** Aligns with business objectives
- **Traceable:** Links to source (executive summary or user journey)

**FR Anti-Patterns:**

*Subjective Adjectives:*
- FORBIDDEN: "easy to use", "intuitive", "user-friendly", "fast", "responsive"
- USE: metrics — "completes task in under 3 clicks", "loads in under 2 seconds"

*Implementation Leakage:*
- FORBIDDEN: Technology names, specific libraries, implementation details
- USE: Focus on capability and measurable outcomes

*Vague Quantifiers:*
- FORBIDDEN: "multiple users", "several options", "various formats"
- USE: "up to 100 concurrent users", "3-5 options", "PDF, DOCX, TXT formats"

*Missing Test Criteria:*
- FORBIDDEN: "The system shall provide notifications"
- USE: "The system shall send email notifications within 30 seconds of trigger event"

### What Makes Great Non-Functional Requirements?

**NFRs Must Be Measurable**

Template: `"The system shall [metric] [condition] [measurement method]"`

Examples:
- "The system shall respond to API requests in under 200ms for 95th percentile as measured by APM monitoring"
- "The system shall maintain 99.9% uptime during business hours as measured by cloud provider SLA"
- "The system shall support 10,000 concurrent users as measured by load testing"

**NFR Anti-Patterns:**

*Unmeasurable Claims:*
- "The system shall be scalable" -> "The system shall handle 10x load growth through horizontal scaling"
- "High availability required" -> "99.9% uptime as measured by cloud provider SLA"

*Missing Context:*
- "Response time under 1 second" -> "API response time under 1 second for 95th percentile under normal load"

### Domain-Specific Requirements

Auto-detect and enforce based on project context. Certain industries have mandatory requirements:

- **Healthcare:** HIPAA Privacy & Security Rules, PHI encryption, audit logging, MFA
- **Fintech:** PCI-DSS Level 1, AML/KYC compliance, SOX controls, financial audit trails
- **GovTech:** NIST framework, Section 508 accessibility (WCAG 2.1 AA), FedRAMP, data residency
- **E-Commerce:** PCI-DSS for payments, inventory accuracy, tax calculation by jurisdiction

Missing these requirements in the PRD means they'll be missed in architecture and implementation, creating expensive rework. During PRD creation there is a step to cover this — during validation we want to make sure it was covered.

### Required Document Sections

1. **Executive Summary** — Vision, differentiator, target users
2. **Success Criteria** — Measurable outcomes (SMART)
3. **Product Scope** — MVP, Growth, Vision phases
4. **User Journeys** — Comprehensive coverage
5. **Domain Requirements** — Industry-specific compliance (if applicable)
6. **Innovation Analysis** — Competitive differentiation (if applicable)
7. **Project-Type Requirements** — Platform-specific needs
8. **Functional Requirements** — Capability contract (FRs)
9. **Non-Functional Requirements** — Quality attributes (NFRs)

**Formatting for Dual Consumption:**
- For Humans: Clear professional language, logical flow, easy stakeholder review
- For LLMs: ## Level 2 headers for all main sections, consistent structure, precise testable language, high information density

### Downstream Impact

**How the PRD Feeds Next Artifacts:**

**UX Design:** User journeys -> interaction flows; FRs -> design requirements; Success criteria -> UX metrics

**Architecture:** FRs -> system capabilities; NFRs -> architecture decisions; Domain requirements -> compliance architecture; Project-type requirements -> platform choices

**Epics & Stories (created after architecture):** FRs -> user stories (1 FR could map to 1-3 stories); Acceptance criteria -> story acceptance tests; Priority -> sprint sequencing; Traceability -> stories map back to vision

**Development AI Agents:** Precise requirements -> implementation clarity; Test criteria -> automated test generation; Domain requirements -> compliance enforcement; Measurable NFRs -> performance targets

### Summary Checklist

- **High Information Density** — Every sentence carries weight, zero fluff
- **Measurable Requirements** — All FRs and NFRs are testable with specific criteria
- **Clear Traceability** — Each requirement links to user need and business objective
- **Domain Awareness** — Industry-specific requirements auto-detected and included
- **Zero Anti-Patterns** — No subjective adjectives, implementation leakage, or vague quantifiers
- **Dual Audience Optimized** — Human-readable AND LLM-consumable
- **Markdown Format** — Professional, clean, accessible to all stakeholders

**Remember:** The PRD is the foundation. Quality here ripples through every subsequent phase. A dense, precise, well-traced PRD makes UX design, architecture, epic breakdown, and AI development dramatically more effective.

---

## Step 1: Discovery — Load PRD and Context (BAT BUOC)

1. **Discover PRD to validate:**
   - If path provided: use it
   - If not: search `{{PLANNING_ARTIFACTS}}` for `*prd*.md` (including sharded `*prd*/*.md`)
   - If multiple found: list options for user
   - If none found: ask user for path
2. **Load PRD completely** including frontmatter
3. **Extract frontmatter:** `inputDocuments`, `classification` (domain, projectType)
4. **Load all input documents** from frontmatter (Product Brief, research docs, etc.)
5. **Ask user** for additional reference documents
6. **Initialize validation report** with frontmatter:
   ```yaml
   ---
   validationTarget: '{{PRD_PATH}}'
   validationDate: '{{CURRENT_DATE}}'
   inputDocuments: [list]
   validationStatus: IN_PROGRESS
   ---
   ```
7. Report setup to user: PRD loaded, input docs loaded, report initialized

**Validation Gate:** PRD loaded, all input docs loaded, report initialized, user confirmed.

---

## Step 2: Format Detection

1. **Extract all ## Level 2 headers** from PRD
2. **Check for 6 BMAD core sections:**

| Section | Accept Variants |
|---------|----------------|
| Executive Summary | Overview, Introduction |
| Success Criteria | Goals, Objectives |
| Product Scope | Scope, In Scope, Out of Scope |
| User Journeys | User Stories, User Flows |
| Functional Requirements | Features, Capabilities |
| Non-Functional Requirements | NFRs, Quality Attributes |

3. **Classify format:**
   - **BMAD Standard:** 5-6 core sections present
   - **BMAD Variant:** 3-4 core sections present
   - **Non-Standard:** < 3 core sections
4. **Report to validation report:**
   ```markdown
   ## Format Detection
   **Format Classification:** [classification]
   **Core Sections Present:** [count]/6
   [List each section: Present/Missing]
   ```
5. **Route:**
   - BMAD Standard/Variant -> auto-proceed to Step 3
   - Non-Standard -> offer Parity Check (Step 2B) or Validate As-Is

---

## Step 2B: Document Parity Check (Non-Standard PRDs only)

Analyze gaps to BMAD PRD parity across 6 core sections:

**For each section, assess:**
- Status: Present / Missing / Incomplete
- Gap: What's missing or incomplete
- Effort: Minimal / Moderate / Significant

**Sections to check:**
1. **Executive Summary** — vision/overview, problem statement, target users
2. **Success Criteria** — measurable goals, clear success definition
3. **Product Scope** — in-scope items, out-of-scope items, boundaries
4. **User Journeys** — user types/personas, user flows documented
5. **Functional Requirements** — features/capabilities listed and structured
6. **Non-Functional Requirements** — quality attributes, performance/security defined

**Report format:**
```markdown
## Parity Analysis (Non-Standard PRD)

| Section | Status | Gap | Effort |
|---------|--------|-----|--------|
| Executive Summary | [status] | [gap] | [effort] |
| ... | ... | ... | ... |

**Overall Parity Effort:** Quick / Moderate / Substantial
**Recommendation:** [based on analysis]
```

**User chooses:** Continue validation / Exit and review report

---

## Step 3: Information Density Validation (BAT BUOC — Auto-proceed)

Scan PRD for density anti-patterns. Count violations with line numbers.

### Anti-Pattern Detection Lists

**Conversational Filler Phrases:**
- "The system will allow users to..."
- "It is important to note that..."
- "In order to", "For the purpose of", "With regard to"

**Wordy Phrases (with replacements):**
- "Due to the fact that" -> "because"
- "In the event of" -> "if"
- "At this point in time" -> "now"
- "In a manner that" -> "how"

**Redundant Phrases:**
- "Future plans" -> "plans"
- "Past history" -> "history"
- "Absolutely essential" -> "essential"
- "Completely finish" -> "finish"

### Severity Thresholds
- **Critical:** Total > 10 | **Warning:** 5-10 | **Pass:** < 5

### Report Format
```markdown
## Information Density Validation

**Conversational Filler:** {count} occurrences [examples with line numbers]
**Wordy Phrases:** {count} occurrences [examples with line numbers]
**Redundant Phrases:** {count} occurrences [examples with line numbers]
**Total Violations:** {total}
**Severity:** [Critical/Warning/Pass]
**Recommendation:** [severity-appropriate message]
```

---

## Step 4: Product Brief Coverage (Auto-proceed)

**If Product Brief exists in input documents:**

1. Extract key brief content: vision, users, problem, features, goals, differentiators
2. Map each to PRD sections
3. Classify: Fully Covered / Partially Covered / Not Found / Intentionally Excluded
4. Assess gap severity: Critical / Moderate / Informational

**If no Product Brief:** Report "N/A — No Product Brief provided" and skip.

### Report Format
```markdown
## Product Brief Coverage

**Product Brief:** {brief_file_name}
**Vision Statement:** [Fully/Partially/Not Found/Excluded]
**Target Users:** [coverage]
**Problem Statement:** [coverage]
**Key Features:** [coverage]
**Goals/Objectives:** [coverage]
**Differentiators:** [coverage]

**Overall Coverage:** [assessment]
**Critical Gaps:** {count} | **Moderate Gaps:** {count}
```

---

## Step 5: Measurability Validation (BAT BUOC — Auto-proceed)

### Functional Requirements (FRs)

Extract all FRs and check each for:

**Format compliance:** Must follow "[Actor] can [capability]" pattern with clear actor and testable capability.

**Subjective adjectives (FORBIDDEN in FRs):**
easy, fast, simple, intuitive, user-friendly, responsive, quick, efficient (without metrics)

**Vague quantifiers (FORBIDDEN in FRs):**
multiple, several, some, many, few, various, number of

**Implementation details (FORBIDDEN unless capability-relevant):**
React, Vue, Angular, PostgreSQL, MongoDB, AWS, Docker, Kubernetes, Redux, etc.
Exception: "API consumers can access..." — API is capability-relevant.

### Non-Functional Requirements (NFRs)

Check each NFR for:
- **Specific metrics:** measurable criterion (e.g., "response time < 200ms", NOT "fast response")
- **Template compliance (all 4 required):** criterion, metric, measurement method, context

### Severity Thresholds
- **Critical:** Total > 10 | **Warning:** 5-10 | **Pass:** < 5

### Report Format
```markdown
## Measurability Validation

### Functional Requirements
**Total FRs Analyzed:** {count}
**Format Violations:** {count} [examples with line numbers]
**Subjective Adjectives Found:** {count} [examples with line numbers]
**Vague Quantifiers Found:** {count} [examples with line numbers]
**Implementation Leakage:** {count} [examples with line numbers]
**FR Violations Total:** {total}

### Non-Functional Requirements
**Total NFRs Analyzed:** {count}
**Missing Metrics:** {count} [examples with line numbers]
**Incomplete Template:** {count} [examples with line numbers]
**Missing Context:** {count} [examples with line numbers]
**NFR Violations Total:** {total}

**Total Violations:** {total} | **Severity:** [Critical/Warning/Pass]
```

---

## Step 6: Traceability Validation (BAT BUOC — Auto-proceed)

Validate the chain: Executive Summary -> Success Criteria -> User Journeys -> Functional Requirements.

### Chain Validation

1. **Executive Summary -> Success Criteria:** Does vision align with defined success?
2. **Success Criteria -> User Journeys:** Are success criteria supported by user journeys?
3. **User Journeys -> FRs:** Does each FR trace back to a user journey?
4. **Scope -> FRs:** Do MVP scope FRs align with in-scope items?

### Orphan Detection

- FRs not traceable to any user journey or business objective
- Success criteria not supported by user journeys
- User journeys without supporting FRs

### Severity Thresholds
- **Critical:** Orphan FRs exist | **Warning:** Chain gaps, no orphans | **Pass:** All chains intact

### Report Format
```markdown
## Traceability Validation

### Chain Validation
**Executive Summary -> Success Criteria:** [Intact/Gaps Identified]
**Success Criteria -> User Journeys:** [Intact/Gaps Identified]
**User Journeys -> Functional Requirements:** [Intact/Gaps Identified]
**Scope -> FR Alignment:** [Intact/Misaligned]

### Orphan Elements
**Orphan FRs:** {count} [list with FR numbers]
**Unsupported Success Criteria:** {count}
**User Journeys Without FRs:** {count}

**Total Issues:** {total} | **Severity:** [Critical/Warning/Pass]
```

---

## Step 7: Implementation Leakage Validation (Auto-proceed)

Scan FRs and NFRs for implementation details. Requirements specify WHAT, not HOW.

### Technology Terms to Scan

| Category | Terms |
|----------|-------|
| **Frontend** | React, Vue, Angular, Svelte, Solid, Next.js, Nuxt |
| **Backend** | Express, Django, Rails, Spring, Laravel, FastAPI |
| **Databases** | PostgreSQL, MySQL, MongoDB, Redis, DynamoDB, Cassandra |
| **Cloud** | AWS, GCP, Azure, Cloudflare, Vercel, Netlify |
| **Infrastructure** | Docker, Kubernetes, Terraform, Ansible |
| **Libraries** | Redux, Zustand, axios, fetch, lodash, jQuery |
| **Data Formats** | JSON, XML, YAML, CSV (unless capability-relevant) |

### Capability vs Leakage Distinction
- **Acceptable:** "API consumers can access data via REST endpoints" — describes capability
- **Violation:** "React components fetch data using Redux" — prescribes implementation

### Severity Thresholds
- **Critical:** > 5 | **Warning:** 2-5 | **Pass:** < 2

### Report Format
```markdown
## Implementation Leakage Validation

**Frontend:** {count} | **Backend:** {count} | **Databases:** {count}
**Cloud:** {count} | **Infrastructure:** {count} | **Libraries:** {count}
[For each violation: term, line number, capability-relevant or leakage]

**Total Violations:** {total} | **Severity:** [Critical/Warning/Pass]
**Note:** Capability-relevant terms (API, REST, GraphQL) acceptable when describing WHAT, not HOW.
```

---

## Step 8: Domain Compliance Validation (Auto-proceed)

Conditional validation based on domain. Extract `classification.domain` from PRD frontmatter.

### Domain Classification

**Low complexity (skip detailed checks):** General, consumer apps, content websites, standard business tools

**High complexity (require special sections):**

| Domain | Signals | Complexity | Key Concerns | Special Sections |
|--------|---------|------------|--------------|------------------|
| **Healthcare** | medical, diagnostic, clinical, FDA, patient, HIPAA, pharma | high | FDA approval; Clinical validation; HIPAA compliance; Patient safety; Medical device classification; Liability | clinical_requirements, regulatory_pathway, validation_methodology, safety_measures |
| **Fintech** | payment, banking, trading, investment, crypto, KYC, AML, fintech | high | Regional compliance; Security standards; Audit requirements; Fraud prevention; Data protection | compliance_matrix, security_architecture, audit_requirements, fraud_prevention |
| **GovTech** | government, federal, civic, public sector, citizen, municipal, voting | high | Procurement rules; Security clearance; Accessibility (508); FedRAMP; Privacy; Transparency | procurement_compliance, security_clearance, accessibility_standards, transparency_requirements |
| **EdTech** | education, learning, student, teacher, curriculum, assessment, K-12, LMS | medium | Student privacy (COPPA/FERPA); Accessibility; Content moderation; Age verification; Curriculum standards | privacy_compliance, content_guidelines, accessibility_features, curriculum_alignment |
| **Aerospace** | aircraft, spacecraft, aviation, drone, satellite, flight, radar | high | Safety certification; DO-178C compliance; Performance validation; Simulation accuracy; Export controls | safety_certification, simulation_validation, performance_requirements, export_compliance |
| **Automotive** | vehicle, car, autonomous, ADAS, automotive, driving, EV | high | Safety standards; ISO 26262; V2X communication; Real-time requirements; Certification | safety_standards, functional_safety, communication_protocols, certification_requirements |
| **Scientific** | research, algorithm, simulation, modeling, computational, data science, ML, AI | medium | Reproducibility; Validation methodology; Peer review; Performance; Accuracy; Computational resources | validation_methodology, accuracy_metrics, reproducibility_plan, computational_requirements |
| **LegalTech** | legal, law, contract, compliance, litigation, patent, attorney | high | Legal ethics; Bar regulations; Data retention; Attorney-client privilege; Court system integration | ethics_compliance, data_retention, confidentiality_measures, court_integration |
| **InsureTech** | insurance, claims, underwriting, actuarial, policy, risk, premium | high | Insurance regulations; Actuarial standards; Data privacy; Fraud detection; State compliance | regulatory_requirements, risk_modeling, fraud_detection, reporting_compliance |
| **Energy** | energy, utility, grid, solar, wind, power, electricity | high | Grid compliance; NERC standards; Environmental regulations; Safety requirements; Real-time operations | grid_compliance, safety_protocols, environmental_compliance, operational_requirements |
| **Process Control** | industrial automation, process control, PLC, SCADA, DCS, HMI, OT, control system | high | Functional safety; OT cybersecurity; Real-time control requirements; Legacy system integration; Process safety and hazard analysis | functional_safety, ot_security, process_requirements, engineering_authority |
| **Building Automation** | building automation, BAS, BMS, HVAC, smart building, lighting control, fire alarm, life safety | high | Life safety codes; Building energy standards; Multi-trade coordination; Commissioning and operational performance; Indoor environmental quality | life_safety, energy_compliance, commissioning_requirements, engineering_authority |

### Severity Thresholds
- **Critical:** Missing regulatory sections | **Warning:** Incomplete sections | **Pass:** All present
- Low complexity: report "N/A — no special compliance requirements"

### Report Format
```markdown
## Domain Compliance Validation

**Domain:** {domain} | **Complexity:** [Low/High]

[If high complexity]
| Requirement | Status | Notes |
|-------------|--------|-------|
| {Requirement} | [Met/Partial/Missing] | {Notes} |

**Required Sections Present:** {count}/{total}
**Severity:** [Critical/Warning/Pass]
```

---

## Step 9: Project-Type Compliance Validation (Auto-proceed)

Validate required/excluded sections by project type. Extract `classification.projectType` from frontmatter.

### Project Type Mappings

| Type | Detection Signals | Key Questions | Required Sections | Skip Sections |
|------|------------------|---------------|-------------------|---------------|
| api_backend | API, REST, GraphQL, backend, service, endpoints | Endpoints needed? Authentication method? Data formats? Rate limits? Versioning? SDK needed? | endpoint_specs, auth_model, data_schemas, error_codes, rate_limits, api_docs | ux_ui, visual_design, user_journeys |
| web_app | website, webapp, browser, SPA, PWA | SPA or MPA? Browser support? SEO needed? Real-time? Accessibility? | browser_matrix, responsive_design, performance_targets, seo_strategy, accessibility_level | native_features, cli_commands |
| mobile_app | iOS, Android, app, mobile, iPhone, iPad | Native or cross-platform? Offline needed? Push notifications? Device features? Store compliance? | platform_reqs, device_permissions, offline_mode, push_strategy, store_compliance | desktop_features, cli_commands |
| desktop_app | desktop, Windows, Mac, Linux, native | Cross-platform? Auto-update? System integration? Offline? | platform_support, system_integration, update_strategy, offline_capabilities | web_seo, mobile_features |
| saas_b2b | SaaS, B2B, platform, dashboard, teams, enterprise | Multi-tenant? Permission model? Subscription tiers? Integrations? Compliance? | tenant_model, rbac_matrix, subscription_tiers, integration_list, compliance_reqs | cli_interface, mobile_first |
| developer_tool | SDK, library, package, npm, pip, framework | Language support? Package managers? IDE integration? Documentation? Examples? | language_matrix, installation_methods, api_surface, code_examples, migration_guide | visual_design, store_compliance |
| cli_tool | CLI, command, terminal, bash, script | Interactive or scriptable? Output formats? Config method? Shell completion? | command_structure, output_formats, config_schema, scripting_support | visual_design, ux_principles, touch_interactions |
| game | game, player, gameplay, level, character | REDIRECT TO USE THE BMad Method Game Module Agent and Workflows - HALT | game-brief, GDD | most_sections |
| iot_embedded | IoT, embedded, device, sensor, hardware | Hardware specs? Connectivity? Power constraints? Security? OTA updates? | hardware_reqs, connectivity_protocol, power_profile, security_model, update_mechanism | visual_ui, browser_support |
| blockchain_web3 | blockchain, crypto, DeFi, NFT, smart contract | Chain selection? Wallet integration? Gas optimization? Security audit? | chain_specs, wallet_support, smart_contracts, security_audit, gas_optimization | traditional_auth, centralized_db |

If no projectType found -> assume "web_app" and note in findings.

### Report Format
```markdown
## Project-Type Compliance Validation

**Project Type:** {projectType}

### Required Sections
**{Section}:** [Present/Missing/Incomplete]

### Excluded Sections (Should Not Be Present)
**{Section}:** [Absent/Present (violation)]

**Compliance Score:** {present}/{total} required, {violations} excluded present
**Severity:** [Critical if required missing, Warning if incomplete, Pass if complete]
```

---

## Step 10: SMART Requirements Validation (Auto-proceed)

Score each FR on SMART criteria using 1-5 scale.

### Scoring Definitions

| Criterion | 5 (Excellent) | 3 (Acceptable) | 1 (Poor) |
|-----------|--------------|-----------------|----------|
| **Specific** | Clear, unambiguous, well-defined | Somewhat clear | Vague, ambiguous |
| **Measurable** | Quantifiable, testable | Partially measurable | Not measurable, subjective |
| **Attainable** | Realistic, achievable | Probably achievable | Unrealistic, infeasible |
| **Relevant** | Aligned with user needs/business | Connection unclear | Not aligned |
| **Traceable** | Traces to journey/objective | Partially traceable | Orphan requirement |

### Quality Metrics
- Percentage of FRs with all scores >= 3 (acceptable)
- Percentage of FRs with all scores >= 4 (good)
- Average score across all FRs
- Flag any FR with score < 3 in any category — provide improvement suggestion

### Severity Thresholds
- **Critical:** > 30% flagged | **Warning:** 10-30% flagged | **Pass:** < 10% flagged

### Report Format
```markdown
## SMART Requirements Validation

**Total FRs:** {count}
**All scores >= 3:** {pct}% | **All scores >= 4:** {pct}% | **Average:** {avg}/5.0

| FR # | Specific | Measurable | Attainable | Relevant | Traceable | Avg | Flag |
|------|----------|------------|------------|----------|-----------|-----|------|
| FR-001 | {s} | {m} | {a} | {r} | {t} | {avg} | {X if any <3} |

**Legend:** 1=Poor, 3=Acceptable, 5=Excellent | Flag: X = any dimension < 3

### Improvement Suggestions
[For each flagged FR: specific suggestion]

**Severity:** [Critical/Warning/Pass]
```

---

## Step 11: Holistic Quality Assessment (Auto-proceed)

Assess the PRD as a cohesive document. Evaluates the WHOLE, not individual components.

### Document Flow & Coherence
Narrative flow, section transitions, consistency, readability, organization.

### Dual Audience Effectiveness

**For Humans:**
- Executive-friendly: vision/goals understandable quickly?
- Developer clarity: clear requirements to build from?
- Designer clarity: user needs and flows understood?
- Stakeholder decision-making: informed decisions possible?

**For LLMs:**
- Machine-readable structure for LLM consumption?
- UX readiness: can generate UX designs?
- Architecture readiness: can generate architecture?
- Epic/Story readiness: can break into epics/stories?

### BMAD PRD Principles (7 total)
1. Information density — every sentence carries weight
2. Measurability — requirements testable
3. Traceability — requirements trace to sources
4. Domain awareness — domain considerations included
5. Zero anti-patterns — no filler or wordiness
6. Dual audience — works for humans and LLMs
7. Markdown format — proper structure

### Overall Quality Rating
- **5/5 Excellent:** Exemplary, production-ready
- **4/5 Good:** Strong, minor improvements
- **3/5 Adequate:** Acceptable, needs refinement
- **2/5 Needs Work:** Significant gaps
- **1/5 Problematic:** Major flaws, substantial revision needed

### Top 3 Improvements
Identify the 3 most impactful improvements to make this a great PRD.

### Report Format
```markdown
## Holistic Quality Assessment

### Document Flow: [Excellent/Good/Adequate/Needs Work/Problematic]
**Strengths:** {list} | **Weaknesses:** {list}

### Dual Audience Effectiveness
**For Humans:** Executive / Developer / Designer / Stakeholder [assessments]
**For LLMs:** Structure / UX / Architecture / Epic readiness [assessments]
**Dual Audience Score:** {score}/5

### BMAD Principles
| Principle | Status | Notes |
|-----------|--------|-------|
| Information Density | [Met/Partial/Not Met] | {notes} |
| Measurability | [Met/Partial/Not Met] | {notes} |
| Traceability | [Met/Partial/Not Met] | {notes} |
| Domain Awareness | [Met/Partial/Not Met] | {notes} |
| Zero Anti-Patterns | [Met/Partial/Not Met] | {notes} |
| Dual Audience | [Met/Partial/Not Met] | {notes} |
| Markdown Format | [Met/Partial/Not Met] | {notes} |

**Principles Met:** {count}/7

### Overall: {rating}/5 - {label}

### Top 3 Improvements
1. **{Improvement}** — {rationale}
2. **{Improvement}** — {rationale}
3. **{Improvement}** — {rationale}
```

---

## Step 12: Completeness Validation (Auto-proceed)

Final gate check before presenting findings.

### Checks
1. **Template variables:** Scan for {variable}, {{variable}}, [placeholder], TBD, TODO — list with line numbers
2. **Content completeness:** Each section has required content:

| Section | Required Content |
|---------|-----------------|
| Executive Summary | Vision statement, problem, target users |
| Success Criteria | Measurable goals with metrics |
| Product Scope | In-scope AND out-of-scope items |
| User Journeys | User types identified, flows documented |
| Functional Requirements | FRs with proper format |
| Non-Functional Requirements | NFRs with metrics and criteria |

3. **Section-specific:** Success criteria measurable? Journeys cover all users? FRs cover MVP scope? NFRs have criteria?
4. **Frontmatter:** stepsCompleted, classification (domain, projectType), inputDocuments, date

### Severity Thresholds
- **Critical:** Template variables exist OR critical sections missing | **Warning:** Minor gaps | **Pass:** Complete

### Report Format
```markdown
## Completeness Validation

**Template Variables Found:** {count} [list with line numbers]

### Content Completeness
**Executive Summary:** [Complete/Incomplete/Missing]
**Success Criteria:** [Complete/Incomplete/Missing]
**Product Scope:** [Complete/Incomplete/Missing]
**User Journeys:** [Complete/Incomplete/Missing]
**Functional Requirements:** [Complete/Incomplete/Missing]
**Non-Functional Requirements:** [Complete/Incomplete/Missing]

### Frontmatter: {complete}/4 fields present
**Overall Completeness:** {pct}% | **Severity:** [Critical/Warning/Pass]
```

---

## Step 13: Report Complete — Final Assessment (BAT BUOC)

### Compile All Findings
Aggregate from steps 2-12. Build quick results table with severity per dimension.

### Quick Results Table

| Dimension | Severity |
|-----------|----------|
| Format | [classification] |
| Information Density | [Critical/Warning/Pass] |
| Brief Coverage | [assessment or N/A] |
| Measurability | [Critical/Warning/Pass] |
| Traceability | [Critical/Warning/Pass] |
| Implementation Leakage | [Critical/Warning/Pass] |
| Domain Compliance | [status] |
| Project-Type Compliance | [score] |
| SMART Quality | [percentage] |
| Holistic Quality | [rating/5] |
| Completeness | [percentage] |

### Verdict
- **PASS:** All critical checks pass, minor warnings acceptable
- **CONCERNS:** Some issues found but PRD is usable
- **FAIL:** Critical gaps that must be addressed before downstream work

### Final Report Structure
```markdown
## PRD Validation Report

### Overall Verdict: [PASS/CONCERNS/FAIL]
### Holistic Quality: {rating}/5

### Critical Issues (Must Fix)
1. [Issue + evidence + recommendation]

### Warnings (Should Fix)
1. [Issue + evidence + recommendation]

### Strengths
1. [Positive finding]

### Top 3 Improvements
1-3. [From Step 11]

### Validation Scores
[One line per dimension: name + severity]
```

### Update Report Frontmatter
```yaml
---
validationStatus: COMPLETE
holisticQualityRating: '{rating}'
overallStatus: '{PASS/CONCERNS/FAIL}'
---
```

### Present Options to User
- **Review Detailed Findings** — Walk through report section by section
- **Use Edit Workflow** — Use validation report to guide systematic improvements
- **Fix Simple Items** — Immediate fixes for anti-patterns, leakage, missing headers
- **Exit** — Save report and suggest next steps
