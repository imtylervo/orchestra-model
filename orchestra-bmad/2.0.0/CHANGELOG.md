# Changelog

All notable changes to Orchestra-BMAD plugin.

## [2.0.0] — 2026-03-17

### Added
- **18 new workflow files** adapted from BMAD Method v6.2.0 (346 source files → 23 self-contained workflows)
  - Phase 1: `bmad-create-brief`, `bmad-market-research`, `bmad-domain-research`, `bmad-technical-research`
  - Phase 2: `bmad-create-prd`, `bmad-edit-prd`, `bmad-create-ux-design`
  - Phase 3: `bmad-create-architecture`, `bmad-create-epics`, `bmad-generate-project-context`, `bmad-document-project`
  - Phase 4: `bmad-sprint-planning`, `bmad-sprint-status`, `bmad-retrospective`, `bmad-correct-course`, `bmad-qa-e2e-tests`
  - Quick Flow: `bmad-quick-spec`, `bmad-quick-dev`
- **3 new reference files**
  - `documentation-standards.md` — CommonMark rules, Mermaid standards, NO TIME ESTIMATES, quality checklist
  - `project-context-template.md` — 8 brainstorming areas for context generation
  - `command-registry.md` — 33 commands across 4 phases + anytime workflows
- **BẮT BUỘC workflow references** in all 17 templates — workers must read workflow file before starting

### Changed
- **2 workflows rewritten** with full depth from BMAD source
  - `bmad-validate-prd` — expanded from condensed → 13-step validation (624 lines)
  - `bmad-check-readiness` — expanded → 6-step with UX alignment + epic quality 5.1-5.11 (362 lines)
- **9 agent files enriched** with full BMAD personas: communication style, core principles, critical actions, capabilities
- `agent-personas.md` — rewritten with full persona details (was condensed summaries)
- `phase-workflows.md` — rewritten as quick reference index table (was outdated summaries)
- `worker-protocol.md` — added workflow execution rule + documentation standards reference
- `SKILL.md` — Phase 1-4 updated with BẮT BUỘC workflow references
- `README.md` — updated file counts, plugin contents tree, version history

### Stats
- Files: 42 → 62 (+48%)
- Workflows: 5 condensed → 23 full (+360%)
- Workflow lines: ~1,600 → 7,690 (+380%)
- Total lines: ~4,000 → 10,469 (+162%)
- BMAD coverage: ~20% → ~95%

## [1.0.0] — 2026-03-17

### Added
- Initial release
- 9 BMAD agent personas (Mary, John, Sally, Winston, Paige, Bob, Amelia, Quinn, Barry)
- 17 task templates across 4 phases + Quick Flow
- 5 condensed workflow files (dev-story, code-review, create-story, check-readiness, validate-prd)
- Branching Matrix Analysis skill with 9 trigger points
- `/orchestra` command with Full Cycle, Quick Flow, Resume, Status modes
- Checkpoint/resume system via `.orchestra-state.yaml`
- Worker dispatch protocol with brain idempotency
- SessionStart hook for checkpoint detection
- Install script for direct copy deployment
- Validated with full Phase 1→4 cycle on real feature (88 tests)
