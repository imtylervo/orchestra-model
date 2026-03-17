# Create Story Workflow — Full Step-by-Step

**Goal:** Create a comprehensive story file giving the dev agent EVERYTHING needed for flawless implementation.

**Your Purpose:** NOT to copy from epics — it's to create a comprehensive, optimized story context that prevents LLM developer mistakes.

**CRITICAL RULES (NO EXCEPTIONS):**
- EXHAUSTIVE ANALYSIS REQUIRED — thoroughly analyze ALL artifacts, do NOT be lazy or skim
- COMMON LLM MISTAKES TO PREVENT: reinventing wheels, wrong libraries, wrong file locations, breaking regressions, ignoring UX, vague implementations, lying about completion, not learning from past work
- ZERO USER INTERVENTION — fully automated except for initial epic/story selection
- Use subagents/parallel processing to analyze artifacts simultaneously when available
- SAVE QUESTIONS: If you think of questions during analysis, save them for after story is written

---

## Step 1: Determine Target Story

### If story path provided:
- Parse: extract epic_num, story_num, story_key from format like "1-2-user-auth" or "2.4" or "epic 1 story 5"
- Proceed to Step 2

### If sprint-status.yaml exists:
- Read COMPLETE file from start to end (preserve order)
- Find FIRST story where status = "backlog" (key pattern: number-number-name, NOT epic-X or retrospective)
- Extract epic_num, story_num, story_key
- If first story in epic: update epic status to "in-progress"
  - "backlog" → "in-progress"
  - "contexted" (legacy status) → "in-progress" (backward compatibility)
  - "in-progress" → no change needed
  - "done" → ERROR: Cannot create story in completed epic. HALT.
  - Any other status → ERROR: Invalid epic status. HALT.
- If no backlog stories: HALT with options (sprint-planning, correct-course, or retrospective)

### If no sprint status and no story specified:
- HALT: request sprint-planning or specific story number

## Step 2: Load and Analyze Core Artifacts

**EXHAUSTIVE ARTIFACT ANALYSIS — This is where you prevent future developer mistakes!**

### Input Discovery Protocol (Smart File Loading)

For each input type, try sharded first, then whole file. Use the appropriate loading strategy:

| Input | Whole Pattern | Sharded Pattern | Strategy |
|-------|--------------|-----------------|----------|
| PRD | `*prd*.md` | `*prd*/*.md` | SELECTIVE_LOAD |
| Architecture | `*architecture*.md` | `*architecture*/*.md` | SELECTIVE_LOAD |
| UX | `*ux*.md` | `*ux*/*.md` | SELECTIVE_LOAD |
| Epics | `*epic*.md` | `*epic*/*.md` | SELECTIVE_LOAD |

**Loading Strategies:**

**FULL_LOAD** — Load ALL files in sharded directory. Use for comprehensive analysis.
1. Glob for ALL `.md` files in sharded directory
2. Load EVERY matching file completely
3. Concatenate: `index.md` first, then alphabetical

**SELECTIVE_LOAD** — Load specific shard using template variable (e.g., `{{epic_num}}`).
1. Check for template variables in pattern
2. If variable undefined, ask user or infer from context
3. Resolve to specific file path
4. Load that specific file

**INDEX_GUIDED** — Load index.md, analyze structure, intelligently load relevant docs.
1. Load `index.md` from sharded directory
2. Parse TOC, links, section headers
3. Analyze workflow purpose — identify which docs are likely relevant
4. Load all identified relevant documents
5. **When in doubt, LOAD IT** — context is valuable, being thorough beats missing info

**For each pattern:**
- Try sharded first → if found, apply strategy → mark RESOLVED
- If no sharded → try whole file glob → load completely → mark RESOLVED
- If neither found → set to empty, offer user chance to provide path

**Report discovery results:**
```
OK Loaded {prd_content} from 5 sharded files
OK Loaded {architecture_content} from 1 whole file
OK Loaded {epics_content} from selective load: epics/epic-3.md
-- No ux_design files found
```

### Epic Analysis
From epics content, extract Epic N complete context:
- Epic objectives and business value
- ALL stories in this epic for cross-story context
- Our story's requirements, user story statement, acceptance criteria
- Technical requirements and constraints
- Dependencies on other stories/epics
- Source hints pointing to original documents

### Story Foundation
Extract our story details:
- User story statement (As a, I want, so that)
- Detailed acceptance criteria (BDD formatted)
- Technical requirements specific to this story
- Business context and value
- Success criteria

### Previous Story Intelligence (if story_num > 1)
Find highest story number less than current in same epic. Load and extract:
- Dev notes and learnings from previous story
- Review feedback and corrections needed
- Files created/modified and their patterns
- Testing approaches that worked/didn't
- Problems encountered and solutions found
- Code patterns and conventions established

### Git Intelligence (if previous story exists AND git repo detected)
- Get last 5 commit titles for recent patterns
- Analyze 1-5 most recent commits for:
  - Files created/modified
  - Code patterns and conventions used
  - Library dependencies added/changed
  - Architecture decisions implemented
  - Testing approaches used
- Extract actionable insights for current story

## Step 3: Architecture Analysis — Developer Guardrails

**Extract EVERYTHING the developer MUST follow!**

Load architecture content (single file or sharded). Systematically analyze for story-relevant requirements:

- **Technical Stack:** Languages, frameworks, libraries with versions
- **Code Structure:** Folder organization, naming conventions, file patterns
- **API Patterns:** Service structure, endpoint patterns, data contracts
- **Database Schemas:** Tables, relationships, constraints relevant to story
- **Security Requirements:** Authentication patterns, authorization rules
- **Performance Requirements:** Caching strategies, optimization patterns
- **Testing Standards:** Testing frameworks, coverage expectations, test patterns
- **Deployment Patterns:** Environment configurations, build processes
- **Integration Patterns:** External service integrations, data flows

Extract any story-specific requirements the developer MUST follow.
Identify any architectural decisions that override previous patterns.

## Step 4: Latest Technical Research

Identify libraries/frameworks mentioned in architecture.
For each critical technology, research:
- Latest stable version and key changes
- Breaking changes or security updates
- Performance improvements or deprecations
- Best practices for current version

Include in story any critical latest information:
- Specific library versions and why chosen
- API endpoints with parameters and authentication
- Recent security patches or considerations
- Migration considerations if upgrading

## Step 5: Create Comprehensive Story File

### Story Template (exact structure):

```markdown
# Story {epic_num}.{story_num}: {story_title}

Status: ready-for-dev

## Story

As a {role},
I want {action},
so that {benefit}.

## Acceptance Criteria

1. [Detailed, BDD-formatted criteria from epics/PRD]

## Tasks / Subtasks

- [ ] Task 1 (AC: #)
  - [ ] Subtask 1.1
- [ ] Task 2 (AC: #)
  - [ ] Subtask 2.1

## Dev Notes

- Relevant architecture patterns and constraints
- Source tree components to touch
- Testing standards summary

### Project Structure Notes

- Alignment with unified project structure (paths, modules, naming)
- Detected conflicts or variances (with rationale)

### References

- Cite all technical details with source paths and sections,
  e.g. [Source: docs/<file>.md#Section]

## Dev Agent Record

### Agent Model Used

{agent_model_name_version}

### Debug Log References

### Completion Notes List

### File List
```

### Dev Agent Guardrails (MOST IMPORTANT PART)
Include in Dev Notes:
- Technical requirements from architecture
- Architecture compliance rules
- Library/framework requirements with versions
- File structure requirements
- Testing requirements
- Previous story intelligence (if available)
- Git intelligence summary (if available)
- Latest tech information (if researched)
- Project context reference (if project-context.md exists)

Set story Status to "ready-for-dev".

## Step 6: Validate and Finalize

### Basic Quality Checklist
Before finalizing, verify:

- [ ] Story has clear user story statement
- [ ] ALL acceptance criteria are BDD-formatted and specific enough for TDD
- [ ] Tasks/subtasks map to acceptance criteria
- [ ] Dev Notes contain architecture requirements
- [ ] Dev Notes reference specific files/patterns
- [ ] Previous story learnings included (if applicable)
- [ ] Technical stack versions specified
- [ ] Testing requirements documented
- [ ] No ambiguous or vague instructions

### Finalize
1. Save story document
2. Update sprint-status.yaml: backlog → ready-for-dev (preserve ALL comments and STATUS DEFINITIONS)
3. Report completion with story file path and next steps

---

## Step 7: Quality Competition — Story Context Validation

**CRITICAL MISSION: Outperform the initial story creation with systematic quality review.**

After Step 6 saves the story, run this validation to catch mistakes the initial pass missed. This is the most important quality control in the entire development process.

**CRITICAL MISTAKES TO PREVENT:**
- Reinventing wheels — creating duplicate functionality instead of reusing existing
- Wrong libraries — incorrect frameworks, versions, or dependencies
- Wrong file locations — violating project structure
- Breaking regressions — changes that break existing functionality
- Vague implementations — unclear, ambiguous implementation guidance
- Not learning from past work — ignoring previous story learnings

### 7.1: Systematic Re-analysis

Re-do the entire analysis with a critical eye for what the initial pass missed:

#### Epics Re-analysis
- Re-read epic content — did we miss any cross-story dependencies?
- Are ALL acceptance criteria captured with full technical detail?
- Any business value or constraints overlooked?

#### Architecture Deep-Dive
- Systematically scan for ANYTHING story-relevant that was missed:
  - Technical stack with exact versions
  - Code structure and organization patterns
  - API design patterns and contracts
  - Database schemas and relationships
  - Security requirements and patterns
  - Performance requirements
  - Testing standards and frameworks
  - Deployment and environment patterns
  - Integration patterns and external services

#### Previous Story Intelligence Re-check (if applicable)
- Did we extract ALL actionable intelligence?
  - Dev notes and learnings
  - Review feedback and corrections needed
  - Files created/modified and their patterns
  - Problems encountered and solutions found
  - Code patterns and conventions established

#### Git History Analysis
- Analyze recent commits for patterns missed:
  - Files created/modified in previous work
  - Code conventions used
  - Library dependencies added/changed
  - Testing approaches used

#### Latest Technical Research
- Verify library/framework versions mentioned are current
- Check for breaking changes, security updates, deprecations

### 7.2: Disaster Prevention Gap Analysis

**Identify every gap that could cause implementation disasters:**

#### Reinvention Prevention Gaps
- Areas where developer might create duplicate functionality
- Code reuse opportunities not identified
- Existing solutions not mentioned that developer should extend

#### Technical Specification Disasters
- Wrong libraries/frameworks — missing version requirements causing compatibility issues
- API contract violations — missing endpoint specs that could break integrations
- Database schema conflicts — missing requirements that could corrupt data
- Security vulnerabilities — missing security requirements exposing the system
- Performance disasters — missing requirements causing system failures

#### File Structure Disasters
- Wrong file locations — missing organization requirements breaking build
- Coding standard violations — missing conventions creating inconsistent codebase
- Integration pattern breaks — missing data flow requirements
- Deployment failures — missing environment requirements

#### Regression Disasters
- Breaking changes — missing requirements that could break existing functionality
- Test failures — missing test requirements allowing bugs to production
- UX violations — missing UX requirements ruining the product
- Learning failures — missing previous story context repeating mistakes

#### Implementation Disasters
- Vague implementations — missing details leading to incorrect work
- Completion lies — missing acceptance criteria allowing fake implementations
- Scope creep — missing boundaries causing unnecessary work
- Quality failures — missing quality requirements delivering broken features

### 7.3: LLM Dev-Agent Optimization Analysis

Analyze story content for LLM processing efficiency:

**Issues to detect:**
- **Verbosity problems:** Excessive detail wasting tokens without adding value
- **Ambiguity issues:** Vague instructions leading to multiple interpretations
- **Context overload:** Too much info not directly relevant to implementation
- **Missing critical signals:** Key requirements buried in verbose text
- **Poor structure:** Information not organized for efficient LLM processing

**Optimization principles to apply:**
- Clarity over verbosity — precise and direct, eliminate fluff
- Actionable instructions — every sentence guides implementation
- Scannable structure — clear headings, bullet points, emphasis
- Token efficiency — maximum information in minimum text
- Unambiguous language — no room for misinterpretation

### 7.4: Improvement Recommendations

Categorize all gaps found:

**Critical Misses (Must Fix):**
- Missing essential technical requirements
- Missing previous story context that could cause errors
- Missing anti-pattern prevention leading to duplicate code
- Missing security or performance requirements

**Enhancement Opportunities (Should Add):**
- Additional architectural guidance for developer
- More detailed technical specifications
- Better code reuse opportunities
- Enhanced testing guidance

**Optimizations (Nice to Have):**
- Performance optimization hints
- Additional context for complex scenarios
- Enhanced debugging or development tips

**LLM Optimization Improvements:**
- Token-efficient phrasing of existing content
- Clearer structure for LLM processing
- More actionable and direct instructions
- Reduced verbosity while maintaining completeness

### 7.5: Competition Success Metrics

**Category 1 — Critical Misses (Blockers):**
- Essential technical requirements developer needs but aren't provided
- Previous story learnings that would prevent errors if ignored
- Anti-pattern prevention that would prevent code duplication
- Security or performance requirements that must be followed

**Category 2 — Enhancement Opportunities:**
- Architecture guidance significantly helping implementation
- Technical specs preventing wrong approaches
- Code reuse opportunities developer should know about
- Testing guidance improving quality

**Category 3 — Optimization Insights:**
- Performance or efficiency improvements
- Development workflow optimizations
- Additional context for complex scenarios

### 7.6: Interactive Improvement Process

**Present findings to user:**

```
STORY CONTEXT QUALITY REVIEW COMPLETE

Story: {story_key} - {story_title}

Found {critical_count} critical issues, {enhancement_count} enhancements, {optimization_count} optimizations.

CRITICAL ISSUES (Must Fix):
{list each critical issue}

ENHANCEMENT OPPORTUNITIES (Should Add):
{list each enhancement}

OPTIMIZATIONS (Nice to Have):
{list each optimization}

LLM OPTIMIZATION (Token Efficiency & Clarity):
{list each LLM optimization}
```

**User selection options:**
- **all** — Apply all suggested improvements
- **critical** — Apply only critical issues
- **select** — Choose specific numbers
- **none** — Keep story as-is
- **details** — Show more details about any suggestion

**Apply selected improvements:**
- Load the story file
- Apply accepted changes naturally (as if they were always there)
- Do NOT reference the review process or that changes were "added"
- Ensure clean, coherent final story

**Confirmation after applying:**
```
STORY IMPROVEMENTS APPLIED

Updated {count} sections in the story file.
The story now includes comprehensive developer guidance.

Next Steps:
1. Review the updated story
2. Run dev-story for implementation
```

### Competition Excellence Goal

The LLM developer agent processing the final story will have:
- Clear technical requirements they must follow
- Previous work context they can build upon
- Anti-pattern prevention to avoid common mistakes
- Comprehensive guidance for efficient implementation
- Optimized content structure for maximum clarity and minimum token waste
- Actionable instructions with no ambiguity or verbosity
- Efficient information density — maximum guidance in minimum text

**Every improvement makes it IMPOSSIBLE for the developer to:**
- Reinvent existing solutions
- Use wrong approaches or libraries
- Create duplicate functionality
- Miss critical requirements
- Misinterpret requirements due to ambiguity
- Waste tokens on verbose, non-actionable content
