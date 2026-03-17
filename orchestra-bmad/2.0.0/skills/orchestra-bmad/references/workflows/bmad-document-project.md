# Document Project Workflow — Full Step-by-Step

**Goal:** Document brownfield (existing) projects for AI context, creating comprehensive documentation that enables AI agents to understand, navigate, and extend the codebase.

**Your Role:** Project documentation specialist. Generate accurate, thorough documentation by analyzing actual project files — no guessing or fabrication.

**CRITICAL RULES (NO EXCEPTIONS):**
- Read actual source files — NEVER fabricate technical details
- Write documents to disk IMMEDIATELY after generation (write-as-you-go)
- Purge detailed findings from context after writing (keep only summaries)
- For deep/exhaustive scans: batch by subfolder, not arbitrary file count
- Large files (>5000 LOC): use judgment, focus on exports and key patterns
- All output goes to `{{PROJECT_KNOWLEDGE}}/` directory

---

## Step 1: Determine Workflow Mode

### 1.1 Check for Existing State

Look for `{{PROJECT_KNOWLEDGE}}/project-scan-report.json`:
- If exists and < 24 hours old: offer Resume / Start Fresh / Cancel
- If exists and >= 24 hours old: archive and start fresh
- If not exists: continue to mode selection

### 1.2 Check for Existing Documentation

Look for `{{PROJECT_KNOWLEDGE}}/index.md`:
- **If exists:** offer options:
  1. **Re-scan entire project** — update all documentation
  2. **Deep-dive specific area** — exhaustive analysis of one module/feature
  3. **Cancel** — keep existing docs
- **If not exists:** proceed with initial scan

### 1.3 Select Scan Level (for initial/re-scan only)

- **Quick:** Patterns, configs, manifests only — does NOT read source files
- **Deep:** Reads files in critical directories per project type
- **Exhaustive:** Reads ALL source files (excluding node_modules, dist, build)

Deep-dive mode automatically uses exhaustive scan.

---

## Step 2: Project Detection & Classification (BẮT BUỘC)

### 2.1 Detect Project Type

Scan for key file patterns to identify project type:

| Type | Key Indicators |
|------|---------------|
| Web | package.json, tsconfig.json, *.config.js |
| Mobile | app.json, expo, react-native, flutter |
| Backend | server files, API routes, Dockerfile |
| CLI | bin/, commander, oclif |
| Library | src/index.ts, exports, no app entry |
| Desktop | electron, tauri |

### 2.2 Detect Multi-Part Structure

Check if project has multiple parts (e.g., client + server + shared):
- Monorepo indicators (workspaces, lerna, nx)
- Separate package.json files in subdirectories
- Client/server/shared folder patterns

### 2.3 Confirm with User

Present detected classification. Ask user to confirm or correct.

### 2.4 Initialize State File

Create `{{PROJECT_KNOWLEDGE}}/project-scan-report.json` with:
- Workflow mode, scan level, project type
- Timestamps, completed steps tracking
- Resume instructions

---

## Step 3: Technology Stack Analysis

### 3.1 Identify All Technologies

From package files, configs, and source:
- Framework, language, database
- All major dependencies with versions
- Build tools, package managers
- Testing frameworks

### 3.2 Create Technology Decision Table

| Category | Technology | Version | Purpose |
|----------|-----------|---------|---------|
| Framework | Next.js | 14.x | Full-stack web |
| Database | PostgreSQL | 15 | Primary data store |
| ORM | Prisma | 5.x | Database access |

---

## Step 4: Codebase Scanning (BẮT BUỘC)

Based on project type and scan level, systematically scan:

### 4.1 Critical Directories

Scan directories identified by project type:
- API endpoints and routes
- Data models and schemas
- UI components (if applicable)
- Services and business logic
- Configuration files
- Authentication/security patterns

### 4.2 Entry Points

Identify and document:
- Application entry points
- API route handlers
- Background job entry points
- CLI command handlers

### 4.3 Integration Points

For multi-part projects:
- How parts communicate
- Shared data models
- API contracts between parts

### 4.4 Write-as-you-go (BẮT BUỘC)

After each major scan section:
1. Write findings to a document immediately
2. Validate the written document
3. Update state file
4. Purge detailed findings from context (keep 1-2 sentence summaries only)

---

## Step 5: Generate Source Tree Analysis

Create `{{PROJECT_KNOWLEDGE}}/source-tree-analysis.md`:
- Complete directory tree (no major omissions)
- Critical folders highlighted and described
- Entry points clearly marked
- Integration paths noted (for multi-part)
- File organization patterns explained

---

## Step 6: Generate Project Overview

Create `{{PROJECT_KNOWLEDGE}}/project-overview.md`:
- Project purpose and scope
- Technology stack summary
- Architecture pattern overview
- Key features and capabilities
- Development status

---

## Step 7: Generate Architecture Documentation

Create `{{PROJECT_KNOWLEDGE}}/architecture.md` (or per-part for multi-part):
- Technology stack section (comprehensive)
- Architecture pattern explanation
- Data architecture (if applicable)
- API design documentation (if applicable)
- Component structure (if applicable)
- Source tree (annotated)
- Testing strategy
- Deployment architecture (if config found)

---

## Step 8: Generate Development Guide

Create `{{PROJECT_KNOWLEDGE}}/development-guide.md` (or per-part):
- Prerequisites
- Installation steps
- Environment setup
- Local run commands
- Build process
- Test commands and approach
- Deployment process (if applicable)
- CI/CD pipeline details (if found)

---

## Step 9: Generate Additional Documents (as needed)

Based on what was found during scanning:
- `component-inventory.md` — if UI components exist
- `api-contracts.md` — if APIs documented
- `data-models.md` — if data models found
- `deployment-guide.md` — if deployment config found
- `integration-architecture.md` — if multi-part project
- `project-parts.json` — if multi-part project

---

## Step 10: Generate Master Index

Create `{{PROJECT_KNOWLEDGE}}/index.md`:
- Project structure summary
- Quick reference section
- Links to ALL generated documents
- Links to existing docs (if found)
- Getting started section
- AI-assisted development guidance

---

## Step 11: Deep-Dive Documentation (if deep-dive mode)

### 11.1 Select Target Area

Present options based on project structure:
- API route groups
- Feature modules
- UI component areas
- Services/business logic
- Custom folder or file path

### 11.2 Exhaustive File Analysis (BẮT BUỘC)

For EVERY file in target area:
- Read complete file contents (ALL lines)
- Extract all exports with full signatures
- Extract all imports/dependencies
- Identify purpose from comments and code
- Extract function signatures with types
- Note TODOs, FIXMEs, comments
- Identify patterns (hooks, services, etc.)
- Capture risks, verification steps, suggested tests

### 11.3 Relationship Analysis

- Build dependency graph (files as nodes, imports as edges)
- Trace data flow through the system
- Identify integration points (APIs, state, events, DB)
- Find entry points and leaf nodes

### 11.4 Find Related Code

Search OUTSIDE scanned area for:
- Similar patterns and implementations
- Reusable utilities
- Reference implementations
- Design patterns used elsewhere

### 11.5 Generate Deep-Dive Document

Create `{{PROJECT_KNOWLEDGE}}/deep-dive-{{target_name}}.md`:
- Complete file inventory with all exports
- Dependency graph and data flow
- Integration points and API contracts
- Testing analysis and coverage
- Related code and reuse opportunities
- Implementation guidance and modification instructions
- Contributor notes, risks, verification steps

### 11.6 Update Master Index

Add deep-dive link to `{{PROJECT_KNOWLEDGE}}/index.md`.

### 11.7 Offer Continuation

Ask user: deep-dive another area or finish?

---

## Step 12: Final Validation

### 12.1 Content Quality Check

- [ ] Technical information accurate and specific
- [ ] No generic placeholders or TODO items remain
- [ ] File paths and directory references correct
- [ ] Technology names and versions accurate
- [ ] Terminology consistent across all documents

### 12.2 Completeness Check

- [ ] index.md generated with all links
- [ ] project-overview.md generated
- [ ] source-tree-analysis.md generated
- [ ] architecture.md generated
- [ ] development-guide.md generated
- [ ] All applicable optional docs generated
- [ ] Deep-dive docs generated (if deep-dive mode)

### 12.3 Brownfield PRD Readiness

Documentation must provide enough context for AI to:
- [ ] Understand existing system architecture
- [ ] Identify integration points for new features
- [ ] Know reusable components for leveraging
- [ ] Understand data models for schema extension
- [ ] Follow code conventions for consistency

---

## Quality Checklist (BẮT BUỘC — verify before completion)

- [ ] All critical directories scanned based on project type
- [ ] Technology stack fully identified with versions
- [ ] Write-as-you-go architecture followed (no context accumulation)
- [ ] State file valid and can enable resumption
- [ ] All documents written to `{{PROJECT_KNOWLEDGE}}/`
- [ ] Master index links to all generated docs
- [ ] Documentation immediately usable for brownfield PRD workflow
- [ ] Deep-dive docs comprehensive and implementation-ready (if applicable)
