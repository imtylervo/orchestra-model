---
name: branching-matrix-analysis
description: Systematic matrix thinking for EVERYTHING — before any important decision, recommendation, answer, or action, identify all relevant domains, enumerate sibling concepts per domain, verify coverage, check cross-domain interactions. Use for specs, designs, brainstorming, debugging, planning, problem-solving, or ANY task requiring thoroughness.
---

# Branching Matrix Analysis

A systematic thinking method for gaining COMPLETE OVERVIEW + THOROUGH DETAIL before making any decision, statement, or action.

**NOT just for code.** Applies to EVERYTHING: brainstorm, problem-finding, solution proposals, planning, answering questions, debug, design, review.

## When to use

- **BEFORE** making a recommendation, decision, or important conclusion
- After reviewing a spec/design, before concluding "complete"
- When finding 1 gap/issue → need to find sibling gaps/issues
- Designing a new system → verify no missing concerns
- Brainstorming → ensure all angles explored
- Debugging → ensure no hidden root causes overlooked
- Anytime thoroughness is required

## Core Principle

> Before saying or doing anything important → think in matrix form:
> domains → siblings → verify → cross-domain → then output.

## Process

### Step 1: Identify the main DOMAINS of the deliverable

Every deliverable (spec, design, plan) sits at the intersection of multiple domains. List all relevant domains.

**Example — Framework design:**
```
Domains:
  1. Core system (BMAD methodology)
  2. Platform (Claude Code capabilities)
  3. End User Experience
  4. Fault tolerance (checkpoint, recovery)
  5. Performance (latency, throughput, limits)
  6. Security (permissions, isolation, data)
  7. Operations (monitoring, maintenance, updates)
```

**Example — API design:**
```
Domains:
  1. Functional (endpoints, data models)
  2. Non-functional (performance, rate limits)
  3. Security (auth, authorization, input validation)
  4. Client experience (SDK, docs, errors)
  5. Operations (monitoring, versioning, deprecation)
  6. Integration (dependencies, third-party)
```

### Step 2: For each domain, ENUMERATE sibling concepts

Do not guess — research domain knowledge to list comprehensively.

**Example — Domain "Fault tolerance":**
```
Fault tolerance:
  ├── Checkpoint (save state)
  ├── Rollback (revert to good state)
  ├── Idempotency (re-run safely)
  ├── State consistency (sources agree)
  ├── Graceful shutdown (orderly stop)
  ├── Observability (know what's happening)
  ├── Health checks (system alive?)
  ├── Circuit breaker (stop cascading failure)
  ├── Retry with backoff (transient errors)
  └── Data integrity (no corruption)
```

### Step 3: Verify each concept in the deliverable

For each concept, check:
- Present in spec? → OK
- Not present but relevant? → GAP — add it
- Not present and not relevant? → Skip, note reason

### Step 4: Cross-domain interaction check

Some gaps only appear at the INTERSECTION of 2+ domains.

**Example:**
```
Core system × Platform = "Do BMAD workflows actually run on Claude Code?"
Core system × UX = "Does the user understand BMAD phases?"
Platform × Fault tolerance = "If Claude Code crashes, does the checkpoint persist?"
```

Create an NxN matrix, check each intersection.

## Anti-patterns

- **Linear thinking**: Checking each section sequentially → miss cross-cutting concerns
- **Ad-hoc thinking**: Check as you go → lack systematic coverage
- **Single-domain focus**: Only check functional requirements → miss UX, operations, security
- **Surface-level check**: "Checkpoint mentioned" ≠ "Checkpoint design complete" → must trace sub-branches

## Template output

```markdown
## Branching Matrix Analysis: [Deliverable Name]

### Domains identified
1. [Domain A]
2. [Domain B]
...

### Per-domain gap check

#### Domain A: [Name]
| Concept | In spec? | Relevant? | Gap? | Action |
|---------|----------|-----------|------|--------|
| Concept 1 | Yes | Yes | No | — |
| Concept 2 | No | Yes | YES | Add section on... |
| Concept 3 | No | No | No | Not applicable because... |

#### Domain B: [Name]
...

### Cross-domain interactions
| Domain A × Domain B | Gap? | Notes |
|---------------------|------|-------|
| Core × Platform | YES | Need to verify X works on Y |
| Core × UX | YES | User doesn't understand X |
...

### Summary
- Total gaps found: N
- Critical: X
- Important: Y
- Nice-to-have: Z
```

## Depth Calibration

Not every task needs a full 10-domain matrix:

| Task scope | Domains | Cross-domain | Time |
|------------|---------|--------------|------|
| Small (bug fix, config change) | 3-4 relevant | Top 3 intersections | 2-3 min |
| Medium (feature, API) | 5-7 | Top 10 intersections | 10-15 min |
| Large (framework, system design) | 8-10+ | Full NxN matrix | 30-60 min |

Calibrate based on: impact of missing something × cost of checking.

## High-Yield Patterns (learned from usage)

**Domains commonly overlooked:**
- Cost (token spend, budget, billing)
- Operations (deployment, backup, upgrades)
- Security (isolation, secrets, audit)
- Testing (framework validation, not just product tests)

**Cross-domain intersections that always have gaps:**
- Anything × Security (permissions, secrets, isolation)
- Anything × Cost (resource consumption, budget impact)
- Fault tolerance × Operations (backup vs checkpoint, disaster recovery drills)
- UX × Technical domains (user doesn't understand technical state)

**Content Condensing × ANY domain:**
- Reduction >80% → GUARANTEED content loss. Must audit each item removed
- Structured steps → bullet points = lost granularity + discipline
- Checklists → prose = lost verification rigor
- **Rule: when condensing, must list EVERY step/item removed and justify WHY safe to remove**

**Check HIGH-YIELD pairs FIRST** — high gap probability, saves time.

## Domain Templates (ready-made, expanding)

### Framework / System Design
1. Core system (methodology, patterns)
2. Platform (runtime capabilities, limits)
3. End User Experience
4. Fault tolerance (checkpoint, recovery, rollback)
5. Performance (latency, throughput)
6. Security (isolation, secrets, audit)
7. Operations (deploy, backup, upgrades)
8. Cost (tokens, billing, budget)
9. Scalability (growth, multi-user)
10. Testing (validation, fixtures, metrics)

### API Design
1. Functional (endpoints, data models, business logic)
2. Non-functional (performance, rate limits, SLA)
3. Security (auth, authorization, input validation)
4. Client experience (SDK, docs, error messages)
5. Operations (monitoring, versioning, deprecation)
6. Integration (dependencies, third-party, webhooks)

### Product Decision
1. User value (problem solved, benefit delivered)
2. Feasibility (technical, resource, timeline)
3. Market (competition, timing, positioning)
4. Cost (build cost, maintenance cost, opportunity cost)
5. Risk (technical risk, market risk, legal risk)
6. Team (skills available, hiring needs, knowledge gaps)

### Bug Investigation
1. Code (logic error, race condition, edge case)
2. Data (corrupt, missing, unexpected format)
3. Infrastructure (network, disk, memory, CPU)
4. User behavior (unexpected input, workflow, timing)
5. Dependencies (library bug, API change, version mismatch)
6. Environment (config diff, OS, permissions)

### Plugin Packaging / Content Migration
1. Content fidelity (condensed = original? steps lost? checklists lost?)
2. Source traceability (each condensed section traceable to source file?)
3. Path correctness (all refs resolve within package)
4. Self-containment (no external dependencies break package)
5. Install experience (1-command install, verify works)
6. Upgrade path (version compat, migration)
7. Conflict resolution (existing files vs package files)

### Content Condensing / Summarization
1. Step-level fidelity (original has N steps → condensed keeps all N or merges?)
2. Checklist preservation (original has checklist items → condensed keeps or drops?)
3. Validation dimensions (original validates many angles → condensed mentions all?)
4. Decision logic (original has if/else branching → condensed keeps logic or flattens?)
5. Quality thresholds (original has specific thresholds → condensed specifies or generalizes?)
6. Tool/dependency integration (original invokes sub-components → condensed mentions or drops?)
7. Configuration (original has per-instance config → condensed hardcodes or parameterizes?)
8. Templates vs instructions (original has templates → condensed bundles or skips?)

*(Add new templates after each use)*

## Improvement Roadmap

### Phase 1: Capture lessons (after each use)
- Note which domains were useful, which could be skipped
- Note which cross-domain found new gaps
- Update high-yield patterns

### Phase 2: Build domain library (after 3-5 uses)
- Add domain templates for new task types
- Each template with pre-built sibling concepts
- Reduce enumeration time from 10 min → 2 min

### Phase 3: Pattern recognition (after 10 uses)
- Track which domains always have gaps across projects
- Build "skip list" for low-yield intersections
- Build "must-check" list for high-yield intersections

### Phase 4: Auto-trigger + integration
- Auto-detect when matrix is needed (no prompt required)
- Integrate with brainstorming: brainstorm done → auto-matrix
- Integrate with spec review: spec done → auto-matrix
- Auto-calibrate depth based on task complexity

## Usage Log

| Date | Task | Domains | Gaps Found | Lessons |
|------|------|---------|------------|---------|
| 2026-03-16 | Orchestra-BMAD Framework Design | 10 | ~150 (per-domain + cross-domain) | Cost, Operations, Security always missing. Cross-domain × Security = always gap. Full matrix takes ~60 min but worth it for framework design |
| 2026-03-17 | Orchestra-BMAD Implementation Plan | 10 | 47 (12 critical, 18 important, 17 nice-to-have) | Plan review found 32 issues but matrix analysis found 15 additional gaps reviewers missed: Phase 1+2 untested, Quick Flow untested, no test fixtures, no brain seeding, UX features missing entirely, no scope enforcement. Dependencies domain (env assumptions, prerequisite ordering) useful — reviewer missed BMAD source path verification + git init for test projects |
| 2026-03-17 | Orchestra-BMAD Post-Implementation Verify | 7 | 6 gaps (cleanup, noise, regression docs) | CRITICAL LESSON: "25/25 tasks done" ≠ "implementation complete". Matrix analysis post-implementation found: 111 bilateral noise recreated by workers, 32 test memories uncleaned, stale files, 3 gaps not recorded in REGRESSIONS, UX features spec'd but not built. Cleanup domain + Data Integrity domain catch issues that task completion tracking misses. MUST run matrix analysis after implementation, not just before |
| 2026-03-17 | Orchestra-BMAD Plugin Spec | 7 | 12 (3 critical, 5 important, 4 nice-to-have) | NEW DOMAIN TEMPLATE needed: "Plugin Packaging" — Install Experience + Content Migration + Self-containment are plugin-specific concerns. Key finding: existing files have hardcoded external paths that break when bundled into plugin. Agent conflict between plugin agents and user agents is non-obvious gap. SKILL.md token budget is a platform constraint easy to miss |
| 2026-03-17 | Orchestra-BMAD Plugin Plan | 6 | 7 (1 critical, 4 important, 2 nice-to-have) | "Content Fidelity" domain catches: SKILL.md is new file (not migrated) needing explicit source refs. "Rollback Safety" domain catches: backup before delete old files. "Verification" domain catches: smoke test only tests Quick Flow, not full cycle. Reviewer missed all 7 — matrix analysis complements reviewer well |
| 2026-03-17 | Content Fidelity Audit | 8 | CRITICAL — source content condensed >99% = systematic loss | **LESSON:** When condensing any structured content, MUST audit: (1) List every original step/item, (2) For each: condensed version keeps enough detail?, (3) Checklists preserved?, (4) Validation dimensions preserved? Previous 6 runs MISSED because lacked "Content Condensing" domain. **Added 2 new domain templates + 1 high-yield pattern.** User found gap that AI missed — proves skill needs continuous evolution from real usage |
