# Create Architecture Workflow — Full Step-by-Step

**Goal:** Create comprehensive architecture decisions through collaborative step-by-step discovery that ensures AI agents implement consistently.

**Your Role:** Architectural facilitator collaborating with a peer. You bring structured thinking and architectural knowledge; the user brings domain expertise and product vision. Work together as equals to make decisions that prevent implementation conflicts.

**CRITICAL RULES (NO EXCEPTIONS):**
- Execute steps in exact order, no skipping
- Read complete input documents, never skim or summarize
- Collaborative discovery — facilitate, do NOT generate content without user input
- Search the web to verify current technology versions — NEVER trust hardcoded versions
- NO time estimates — AI development speed has fundamentally changed
- Save progress to `{{PLANNING_ARTIFACTS}}/architecture.md` as you go

---

## Step 1: Initialization & Document Discovery (BẮT BUỘC)

### 1.1 Check for Existing Architecture

Search for existing `*architecture*.md` in `{{PLANNING_ARTIFACTS}}`:
- If exists with progress: present continuation options (Resume / Start Over)
- If not exists: proceed with fresh workflow

### 1.2 Discover Input Documents

Search for all available planning artifacts:
- **PRD** (`*prd*.md` or `*prd*/index.md`) — **REQUIRED, halt if missing**
- **UX Design** (`*ux*.md` or `*ux*/index.md`) — optional
- **Product Brief** (`*brief*.md`) — optional
- **Research Documents** (`*research*.md`) — optional
- **Project Context** (`**/project-context.md`) — optional, bias toward its rules if found

For sharded documents: load ALL files using index.md as guide. No partial reads.

### 1.3 Validate & Report

Report discovery results to user:
```
Documents Found:
- PRD: [count] files loaded / "None found - REQUIRED"
- UX Design: [count] files / "None found"
- Research: [count] files / "None found"
- Project Context: [count] rules found
```

Confirm with user before proceeding. Ask if additional documents should be included.

### 1.4 Initialize Architecture Document

Create `{{PLANNING_ARTIFACTS}}/architecture.md` with frontmatter:
```yaml
---
stepsCompleted: [1]
inputDocuments: [list of loaded files]
workflowType: 'architecture'
project_name: '{{PROJECT_NAME}}'
date: '{{DATE}}'
---
# Architecture Decision Document
```

**GATE:** Wait for user confirmation before proceeding.

---

## Step 2: Project Context Analysis (BẮT BUỘC)

### 2.1 Analyze Requirements for Architecture

**From PRD:** Extract and analyze:
- Functional Requirements (FRs) — count, categorize, architectural implications
- Non-Functional Requirements (NFRs) — performance, security, compliance
- Technical constraints and dependencies

**From Epics/Stories (if available):**
- Map epic structure to architectural components
- Identify cross-cutting concerns spanning multiple epics

**From UX Design (if available):**
- Component complexity (simple forms vs rich interactions)
- Real-time update needs, animation requirements
- Accessibility standards, responsive breakpoints
- Offline capability, performance expectations

### 2.2 Assess Project Scale

Calculate complexity indicators:
- Real-time features | Multi-tenancy | Regulatory compliance
- Integration complexity | User interaction complexity | Data volume

### 2.3 Present Analysis

Reflect understanding back to user for validation:
- Key architectural aspects from FRs
- Critical NFRs that will shape architecture
- Scale indicators (low/medium/high/enterprise)
- Primary technical domain (web/mobile/api/full-stack)
- Cross-cutting concerns identified

### 2.4 Save to Document

Append `## Project Context Analysis` section with:
- Requirements Overview (FRs, NFRs)
- Scale & Complexity assessment
- Technical Constraints & Dependencies
- Cross-Cutting Concerns

Update frontmatter: `stepsCompleted: [1, 2]`

**GATE:** Wait for user confirmation before proceeding.

---

## Step 3: Starter Template Evaluation

### 3.1 Check Existing Technical Preferences

Review project-context.md (if exists) for:
- Language/framework preferences
- Tools & libraries already decided
- Platform preferences

### 3.2 Discover User Technical Preferences

Discuss with user:
- Languages (TypeScript, Python, Go, Rust, etc.)
- Frameworks (React, Vue, Next.js, etc.)
- Databases (PostgreSQL, MongoDB, etc.)
- Cloud/deployment preferences
- Third-party integrations planned

### 3.3 Identify Primary Technology Domain

Based on context and preferences:
- **Web application** → Next.js, Vite, Remix, SvelteKit
- **Mobile app** → React Native, Expo, Flutter
- **API/Backend** → NestJS, Express, Fastify
- **Full-stack** → T3, RedwoodJS, Next.js
- **CLI/Desktop** → Oclif, Electron, Tauri

### 3.4 Research Current Starters (BẮT BUỘC — web search)

Search the web for current, maintained starters:
```
"{{primary_technology}} starter template CLI create command latest"
"{{primary_technology}} production-ready starter best practices"
```

For each viable option, investigate and document:
- Technology decisions included (language config, styling, testing, build)
- Architectural patterns established
- Maintenance status and community support
- Exact CLI commands for initialization

### 3.5 Present Options & Decide

Present starter analysis adapted to user skill level. Document:
- Selected starter and rationale
- Initialization command
- Architectural decisions provided by starter
- Note: Project initialization should be first implementation story

### 3.6 Save to Document

Append `## Starter Template Evaluation` section.
Update frontmatter: `stepsCompleted: [1, 2, 3]`

**GATE:** Wait for user confirmation before proceeding.

---

## Step 4: Core Architectural Decisions (BẮT BUỘC)

### 4.1 Identify Remaining Decisions

Review what is already decided by:
- Starter template choices
- User technical preferences
- Project context rules

Categorize remaining decisions:
- **Critical** — must decide before implementation
- **Important** — shape architecture significantly
- **Nice-to-Have** — can defer if needed

### 4.2 Facilitate Decisions by Category

For each category, facilitate collaborative decision making. Verify versions via web search.

**Category 1: Data Architecture**
- Database choice, data modeling, validation, migrations, caching

**Category 2: Authentication & Security**
- Auth method, authorization patterns, API security, encryption

**Category 3: API & Communication**
- API design (REST/GraphQL), error handling, rate limiting, service communication

**Category 4: Frontend Architecture (if applicable)**
- State management, component architecture, routing, performance

**Category 5: Infrastructure & Deployment**
- Hosting, CI/CD, environment config, monitoring, scaling

### 4.3 Record Each Decision

For each decision, record:
- Category | Decision | Version (if applicable)
- Rationale | Affected components
- Whether provided by starter template

### 4.4 Check Cascading Implications

After each major decision, identify related decisions it triggers.

### 4.5 Save to Document

Append `## Core Architectural Decisions` section with:
- Decision Priority Analysis
- Decisions by category with versions and rationale
- Decision Impact Analysis (implementation sequence, cross-component deps)

Update frontmatter: `stepsCompleted: [1, 2, 3, 4]`

**GATE:** Wait for user confirmation before proceeding.

---

## Step 5: Implementation Patterns & Consistency Rules

### 5.1 Identify Potential Conflict Points

Where AI agents could make different choices:

**Naming Conflicts:**
- Database: table/column naming (snake_case vs camelCase)
- API: endpoint naming, route params, query params
- Code: components, files, functions, variables

**Structural Conflicts:**
- Test locations (co-located vs separate)
- Component organization (by feature vs by type)
- Config file organization

**Format Conflicts:**
- API response wrappers, error structures
- Date/time formats, JSON field naming
- Success/error response structures

**Communication Conflicts:**
- Event naming, payload structures
- State update patterns, logging formats

**Process Conflicts:**
- Loading state handling, error recovery
- Retry patterns, validation timing

### 5.2 Facilitate Pattern Decisions

For each conflict category:
- Present the conflict point with concrete examples
- Show options with trade-offs
- Get user decision
- Record with examples

### 5.3 Save to Document

Append `## Implementation Patterns & Consistency Rules` section with:
- All pattern categories with concrete examples
- Enforcement guidelines ("All AI Agents MUST...")
- Good examples and anti-patterns

Update frontmatter: `stepsCompleted: [1, 2, 3, 4, 5]`

**GATE:** Wait for user confirmation before proceeding.

---

## Step 6: Project Structure & Boundaries

### 6.1 Map Requirements to Components

**From Epics:** "Epic: {{epic_name}} → Lives in {{module/directory}}"
**From FRs:** "FR Category: {{name}} → Lives in {{module/directory}}"

### 6.2 Define Complete Directory Structure

Based on tech stack and patterns, create complete project tree:
- Root configuration files
- Source code organization (entry points, features, shared utils)
- Test organization (unit, integration, e2e)
- Build and distribution directories

### 6.3 Define Integration Boundaries

- API boundaries (external endpoints, internal services)
- Component boundaries (frontend, state, services)
- Data boundaries (schema, caching, external data)

### 6.4 Map Requirements to Structure

Explicit mapping: Epic/Feature → specific directories and files.
Cross-cutting concerns → shared locations.

### 6.5 Save to Document

Append `## Project Structure & Boundaries` section with:
- Complete directory tree
- Architectural boundaries
- Requirements-to-structure mapping
- Integration points and data flow

Update frontmatter: `stepsCompleted: [1, 2, 3, 4, 5, 6]`

**GATE:** Wait for user confirmation before proceeding.

---

## Step 7: Architecture Validation (BẮT BUỘC)

### 7.1 Coherence Validation

- Do all technology choices work together without conflicts?
- Are all versions compatible?
- Do patterns align with technology choices?
- Does project structure support all decisions?

### 7.2 Requirements Coverage Validation

- Does every epic/FR have architectural support?
- Are NFRs (performance, security, scalability) addressed?
- Are cross-cutting concerns handled?

### 7.3 Implementation Readiness Validation

- Are all critical decisions documented with versions?
- Are patterns comprehensive enough for AI agents?
- Are consistency rules clear and enforceable?
- Is the project structure complete and specific?

### 7.4 Gap Analysis

Identify and document gaps by priority:
- **Critical:** Missing decisions blocking implementation
- **Important:** Areas needing more detail
- **Nice-to-Have:** Additional patterns or docs

For critical issues: facilitate resolution with user before proceeding.

### 7.5 Save Validation Results

Append `## Architecture Validation Results` section with:
- Coherence, Coverage, and Readiness validation results
- Gap analysis findings
- Architecture Completeness Checklist (all items checked)
- Overall Readiness Assessment with confidence level
- Implementation Handoff guidelines for AI agents

Update frontmatter: `stepsCompleted: [1, 2, 3, 4, 5, 6, 7]`

**GATE:** Wait for user confirmation before proceeding.

---

## Step 8: Completion & Handoff

### 8.1 Celebrate Completion

Summarize what was achieved collaboratively.

### 8.2 Finalize Document

Update frontmatter:
```yaml
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
status: 'complete'
completedAt: '{{DATE}}'
```

### 8.3 Provide Next Steps

Recommended next actions:
1. Create Epics & Stories (if not done)
2. Check Implementation Readiness
3. Generate Project Context (if not done)
4. Begin Phase 4 Implementation

---

## Quality Checklist (BẮT BUỘC — verify before completion)

- [ ] PRD fully analyzed, all FRs and NFRs extracted
- [ ] Technology versions verified via web search (not hardcoded)
- [ ] All critical decisions documented with rationale
- [ ] Implementation patterns cover all potential AI agent conflict points
- [ ] Complete project directory structure defined (not generic placeholders)
- [ ] All requirements mapped to specific architectural components
- [ ] Architecture validated for coherence, coverage, and readiness
- [ ] Document saved to `{{PLANNING_ARTIFACTS}}/architecture.md`
