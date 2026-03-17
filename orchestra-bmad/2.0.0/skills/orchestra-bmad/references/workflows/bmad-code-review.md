# Code Review Workflow — Full Step-by-Step

**Goal:** Review code changes adversarially using structured review and triage.

**CRITICAL RULES (NO EXCEPTIONS):**
- Execute steps in exact order, no skipping
- Read entire workflow before acting
- Do NOT modify any files — review is read-only
- Minimum 3 findings per review perspective. 0 findings = HALT and re-review more carefully

### Step Processing Rules
1. **READ COMPLETELY**: Read the entire step file before acting
2. **FOLLOW SEQUENCE**: Execute sections in order
3. **WAIT FOR INPUT**: Halt at checkpoints and wait for human
4. **NEVER** load multiple steps simultaneously
5. **NEVER** skip steps or optimize the sequence

---

## Step 1: Gather Context

### Intent Detection
Detect review scope from the triggering prompt. Match phrases to review mode:

| Phrase | Mode |
|--------|------|
| "staged" / "staged changes" | Staged changes only |
| "uncommitted" / "working tree" / "all changes" | Uncommitted (staged + unstaged) |
| "branch diff" / "vs main" / "against main" / "compared to {branch}" | Branch diff (extract base branch) |
| "commit range" / "last N commits" / "{sha}..{sha}" | Specific commit range |
| "this diff" / "provided diff" / "paste" | User-provided diff |

- When multiple phrases match, prefer the most specific match
- Do NOT match bare "diff" — it appears in other modes
- If clear match found: announce detected mode and proceed directly
- If no match from invocation text: check for sprint tracking file (`*sprint-status*`) for stories in `review` status
  - Exactly one `review` story: suggest it, confirm with user, derive diff source from story context
  - Multiple `review` stories: present numbered options, wait for selection
- If no match and no sprint tracking: HALT and ask user what to review. Present options:
  - Uncommitted changes (staged + unstaged)
  - Staged changes only
  - Branch diff vs a base branch
  - Specific commit range
  - Provided diff or file list

### Construct Diff
Build the diff from chosen source.

### Diff Validation (per-type)
- **Branch diff:** Verify base branch exists before running `git diff`. If not found → HALT, ask for valid branch
- **Commit range:** Verify range resolves. If not → HALT, ask for valid range
- **Provided diff:** Validate content is non-empty and parseable as unified diff. If not parseable → HALT, ask for valid diff
- **File list:** Validate each path exists. Use `git diff HEAD -- <paths>` for tracked files. For untracked files use `git diff --no-index /dev/null <path>`. If diff is empty → ask whether to review full file contents or specify different baseline
- **All types:** Verify diff is non-empty. If empty → HALT: nothing to review

### Spec Context
- Ask if spec/story file provides context for these changes
- If yes: set review_mode = "full", load spec file
- If no: set review_mode = "no-spec"

### Spec Frontmatter Context
If review_mode = "full" and spec file has a `context` field in its frontmatter listing additional docs:
- Load each referenced document
- Warn user about any docs that cannot be found

### Large Diff Handling
If diff exceeds ~3000 lines: warn and offer to chunk by file group.
- If user opts to chunk: agree on first group, narrow diff accordingly, list remaining groups for follow-up runs
- If user declines: proceed as-is with full diff

### Checkpoint
Present summary: diff stats (files changed, lines added/removed), review_mode, loaded context docs. HALT and wait for confirmation.

## Step 2: Review — Three Parallel Perspectives

Launch each review perspective. Each reviewer gets NO conversation history:

### Blind Hunter (ALWAYS)
- Receives: diff ONLY — no spec, no project context
- Mission: Find bugs, logic errors, security vulnerabilities, code smells, performance issues
- DO NOT assess "feature completeness" — code quality only
- Adversarial mindset: assume code has bugs, prove otherwise
- **Subagent:** Invoke `bmad-review-adversarial-general` skill. Pass `content` = diff only

### Edge Case Hunter (ALWAYS)
- Receives: diff + read access to project
- Mission: Check EVERY branching path (if/else, switch, error handling, null checks)
- Find: missing edge cases, boundary conditions, race conditions, error propagation
- Test: empty input, max values, concurrent access, network failure
- **Subagent:** Invoke `bmad-review-edge-case-hunter` skill. Pass `content` = diff

### Acceptance Auditor (only if review_mode = "full")
- Receives: diff + spec/story file + context docs
- Mission: Compare diff against acceptance criteria
- Find: violations, deviations from spec intent, missing implementations, contradictions
- Output: AC status for each criterion (Met/Partial/Missing)
- **Subagent:** Direct prompt — receives diff, spec content, and loaded context docs

### Minimum Findings Rule
Each reviewer: **minimum 3 findings.** If 0 findings → HALT and re-review with deeper scrutiny.

### Subagent Fallback
If subagents are not available: generate prompt files — one per active reviewer:
- `review-blind-hunter.md` (always)
- `review-edge-case-hunter.md` (always)
- `review-acceptance-auditor.md` (only if review_mode = "full")

HALT. Tell user to run each prompt in a separate session and paste back findings. When findings are pasted, resume and proceed to triage.

### Subagent Failure Handling
If any subagent fails, times out, or returns empty: append the layer name to failed_layers (comma-separated) and proceed with findings from remaining layers. Do NOT abort the entire review for one failed layer.

### No-Spec Mode Note
If review_mode = "no-spec": announce "Acceptance Auditor skipped — no spec file provided." Only Blind Hunter and Edge Case Hunter run.

### Expected Output Formats per Reviewer

**Blind Hunter output:** Markdown list of findings (descriptions only, adversarial prose).

**Edge Case Hunter output:** JSON array with structured fields:
```json
[{
  "location": "file:line",
  "trigger_condition": "what triggers the edge case",
  "guard_snippet": "what code should guard against it",
  "potential_consequence": "what happens if unguarded"
}]
```

**Acceptance Auditor output:** Markdown list with:
- One-line title
- Which AC/constraint it violates
- Evidence from the diff

### Finding Format (after normalization)
Each finding must include:
- Severity: Critical / Major / Minor
- Location: file:line
- Description: what's wrong
- Suggested fix or test

## Step 3: Triage

### Normalize Findings
Expected input formats vary by layer:
- Blind Hunter: markdown list of descriptions (adversarial prose)
- Edge Case Hunter: JSON array with location, trigger_condition, guard_snippet, potential_consequence
- Acceptance Auditor: markdown list with title, AC reference, evidence

If a layer's output does not match expected format, attempt best-effort parsing. Note parsing issues.

Convert all to unified format:
- `id` — sequential number
- `source` — blind, edge, auditor, or merged (e.g., blind+edge)
- `title` — one-line summary
- `detail` — full description
- `location` — file:line reference

### Deduplicate
If two+ findings describe the same issue:
- Use most specific finding as base (prefer edge-case JSON with location over adversarial prose)
- Merge unique details from others
- Set source to merged sources

### Classify Each Finding
When uncertain between categories, prefer the more conservative classification.
Exactly one bucket per finding:
- **intent_gap** — spec/intent incomplete (only if review_mode = "full")
- **bad_spec** — spec should have prevented this (only if review_mode = "full")
- **patch** — code issue, trivially fixable
- **defer** — pre-existing issue, not from current change
- **reject** — noise, false positive, handled elsewhere

If review_mode = "no-spec" and finding would be intent_gap/bad_spec → reclassify as patch or defer.

### Drop all "reject" findings. Record reject count.

### Failed Layers Warning
If failed_layers is non-empty: report which layers failed before announcing results. If zero findings remain after dropping rejects AND failed_layers is non-empty → warn user that the review may be incomplete rather than announcing a clean review.

## Step 4: Present Results

### Group by category, present in order:

1. **Intent Gaps**: "These suggest captured intent is incomplete"
2. **Bad Spec**: "Spec should be amended" + suggested amendments
3. **Patch**: "Fixable code issues" + location
4. **Defer**: "Pre-existing issues" + detail

### Summary Line
**X** intent_gap, **Y** bad_spec, **Z** patch, **W** defer. **R** rejected as noise.

### Clean Review
If zero findings after triage: state that findings were raised but all classified as noise, or no findings at all.

### Next Steps (recommendations, not automated):
- If patch findings: "Can be addressed in follow-up pass or manually"
- If intent_gap/bad_spec: "Consider clarifying intent or amending spec before continuing"
- If only defer: "No action needed. Deferred items noted for future"
- If failed layers exist: "Review may be incomplete — consider re-running failed perspectives"
