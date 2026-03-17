# Orchestra-BMAD Plugin v2.0.0

Structured agile workflow with parallel agent execution for Claude Code. Say "build X" and the Orchestrator runs 4 phases, dispatches 9 agents, and produces code + tests + docs.

## Quick Start

```
/orchestra                        # Full BMAD cycle (new feature/product)
/orchestra --quick "fix bug X"    # Quick Flow — Barry solo, <3 files
/orchestra --resume               # Continue from checkpoint
/orchestra --status               # View progress
/orchestra --check                # Verify plugin health
```

## How It Works

```
User: "build a task management app"

  Phase 1: Orchestrator asks 3-5 questions about the idea     (5-10 min)
  Phase 2: Planning + UI design                                (automated)
  Phase 3: System design + work breakdown                      (automated)
  Phase 4: Build each part, test, review                       (automated)

  → Code + tests + docs, committed to git
```

The Orchestrator runs everything autonomously, only pausing when:
- A decision is needed from you (scope, requirements)
- 3 consecutive failures cannot be resolved

## 9 Agents

| Agent | Role | Phase |
|-------|------|-------|
| **Mary** (Analyst) | Brainstorm, research, product brief | 1 |
| **John** (PM) | PRD, epics & stories, course correction | 2, 3 |
| **Sally** (UX) | User flows, wireframes, design system | 2 |
| **Winston** (Architect) | Architecture, ADRs, readiness check | 3 |
| **Paige** (Tech Writer) | Project context, documentation | 3 |
| **Bob** (Scrum Master) | Sprint planning, story creation, retrospective | 4 |
| **Amelia** (Developer) | TDD implementation (Red-Green-Refactor) | 4 |
| **Quinn** (QA) | E2E tests, API tests, adversarial review | 4 |
| **Barry** (Quick Flow) | Quick spec + dev for small changes | QF |

## Quality Gates (Automated)

| Gate | When | Auto-fix? |
|------|------|-----------|
| PRD covers all requirements | After Phase 2 | Yes (retry 2x) |
| Architecture ↔ Stories aligned | After Phase 3 | Yes (retry 2x) |
| Code review min 3 findings | Each story | Yes (retry 3x) |
| Tests pass 100% | Each story | Yes (retry 3x) |
| Branching Matrix Analysis | **9 trigger points** | Yes (fix gaps before proceeding) |

## Branching Matrix Analysis (Built-in)

Automatic matrix analysis at 9 points in the workflow:
1. After brainstorm (Phase 1)
2. After PRD + UX (Phase 2)
3. After architecture (Phase 3)
4. After writing plan
5. After code review
6. Each phase gate commit
7. When requirements change
8. After implementation complete
9. Quick Flow: after spec

Finds gaps before proceeding. Nothing slips through.

## Installation

### From git

```bash
# Clone repo
git clone https://github.com/imtylervo/orchestra-model.git
cd orchestra-model

# Option A: Use install script (recommended)
./orchestra-bmad/install.sh

# Option B: Manual — copy plugin into Claude Code
cp -r orchestra-bmad/2.0.0 ~/.claude/plugins/cache/orchestra-bmad-local/orchestra-bmad/2.0.0

# Register plugin
python3 -c "
import json
path = '\$HOME/.claude/plugins/installed_plugins.json'
with open(path) as f: data = json.load(f)
data['plugins']['orchestra-bmad@orchestra-bmad-local'] = [{
    'scope': 'user',
    'installPath': '\$HOME/.claude/plugins/cache/orchestra-bmad-local/orchestra-bmad/2.0.0',
    'version': '2.0.0',
    'installedAt': '\$(date -Is)',
    'lastUpdated': '\$(date -Is)'
}]
with open(path, 'w') as f: json.dump(data, f, indent=2)
print('Registered!')
"

# OR: copy skills/commands/agents directly (simpler)
cp -r orchestra-bmad/2.0.0/skills/orchestra-bmad <project>/.claude/skills/
cp -r orchestra-bmad/2.0.0/skills/branching-matrix-analysis <project>/.claude/skills/
cp orchestra-bmad/2.0.0/commands/orchestra.md <project>/.claude/commands/
cp orchestra-bmad/2.0.0/agents/*.md ~/.claude/agents/

# Reload
/reload-plugins
```

### Prerequisites

- **Claude Code CLI**
- **Git** — phase gate commits + rollback
- **NeuralMemory plugin** (optional) — enables cross-agent memory via `nmem_recall`/`nmem_remember`

### Verify

```
/orchestra --check
# Expected: "Orchestra-BMAD v2.0.0 ready. 9 agents, 23 workflows, 17 templates."
```

## Usage Guide

### Full Cycle — Build a new feature/product

```
You: /orchestra
Orchestrator: "What do you want to build?"
You: "A task management app with team collaboration"

Phase 1 — Orchestrator asks you 3-5 questions to understand the idea
         → creates _bmad-output/product-brief.md

Phase 2 — John (PM) writes the PRD with requirements
         → Sally (UX) designs the interface
         → creates PRD.md + ux-spec.md

Phase 3 — Winston (Architect) designs the system
         → John creates epics & stories
         → Winston checks implementation readiness
         → Paige writes project context
         → creates architecture.md + epics.md + project-context.md

Phase 4 — For each story in sprint order:
           Bob creates story context
           → Amelia implements with TDD (Red-Green-Refactor)
           → 3 parallel code reviewers check the work
           → Quinn runs E2E tests after each epic
           → Bob runs retrospective
         → creates src/ + tests/ + sprint-status.yaml
```

You only need to answer questions in Phase 1. Everything else runs autonomously.

### Quick Flow — Small changes

```
You: /orchestra --quick "add /health endpoint"

Barry handles everything:
  1. Reads codebase, creates tech spec
  2. Implements with TDD
  3. Runs adversarial self-review
  → Done in one shot
```

Use Quick Flow when: bug fix, < 3 files, single component, no new architecture.

### Resume after interruption

```
You: /orchestra --resume
Orchestrator: "Project 'task-app' is at Phase 3, step 3c (readiness check). Continue?"
```

State is saved automatically after every phase and story.

### Check progress

```
You: /orchestra --status
Orchestrator: "Phase 4, Epic 2/5, Story 3/8. Sprint progress: 42%"
```

### With NeuralMemory (optional)

If you have the [NeuralMemory plugin](https://github.com/nhadaututtheky/neural-memory) installed, agents will:
- Recall context from previous sessions (`nmem_recall`)
- Save decisions and learnings to shared brain (`nmem_remember`)
- Check for knowledge gaps before starting work

This makes multi-session projects work better — agents remember what happened in previous sessions.

Without NeuralMemory, the plugin works fine using file-based context only.

## Project Output

Each project creates `_bmad-output/` containing all artifacts:

```
<project>/
├── _bmad-output/
│   ├── .orchestra-state.yaml   ← Checkpoint (resume after crash)
│   ├── product-brief.md        ← Phase 1: product brief
│   ├── PRD.md                  ← Phase 2: detailed plan
│   ├── ux-spec.md              ← Phase 2: UI design
│   ├── architecture.md         ← Phase 3: system design
│   ├── epics/                  ← Phase 3: work breakdown
│   └── project-context.md      ← Phase 3: constitution for Phase 4
├── implementation_artifacts/    ← Phase 4: story specs
├── sprint-status.yaml           ← Phase 4: progress tracking
└── src/ tests/                  ← Phase 4: code + tests
```

## Checkpoint & Resume

State is automatically saved to `_bmad-output/.orchestra-state.yaml` after each phase/story.
- Session interrupted mid-work → next session auto-detects and offers to resume
- Crash → restart → reads checkpoint and resumes

## Plugin Contents

```
orchestra-bmad/2.0.0/
├── .claude-plugin/plugin.json        ← Plugin manifest
├── README.md                          ← This file
├── commands/orchestra.md              ← /orchestra command
├── agents/                            ← 9 BMAD personas
│   ├── mary-analyst.md
│   ├── john-pm.md
│   ├── winston-architect.md
│   ├── bob-sm.md
│   ├── amelia-dev.md
│   ├── sally-ux.md
│   ├── quinn-qa.md
│   ├── barry-quickflow.md
│   └── paige-tech-writer.md
├── skills/
│   ├── orchestra-bmad/                ← Main orchestrator
│   │   ├── SKILL.md                   ← Workflow logic (~250 lines)
│   │   ├── worker-protocol.md         ← Worker instructions
│   │   ├── references/               ← BMAD docs + workflows
│   │   │   ├── workflow-map.md
│   │   │   ├── agent-personas.md
│   │   │   ├── phase-workflows.md
│   │   │   ├── documentation-standards.md
│   │   │   ├── project-context-template.md
│   │   │   ├── command-registry.md
│   │   │   └── workflows/            ← 23 step-by-step workflows (7,690 lines)
│   │   │       ├── bmad-create-brief.md
│   │   │       ├── bmad-market-research.md
│   │   │       ├── bmad-domain-research.md
│   │   │       ├── bmad-technical-research.md
│   │   │       ├── bmad-create-prd.md
│   │   │       ├── bmad-edit-prd.md
│   │   │       ├── bmad-validate-prd.md
│   │   │       ├── bmad-create-ux-design.md
│   │   │       ├── bmad-create-architecture.md
│   │   │       ├── bmad-create-epics.md
│   │   │       ├── bmad-check-readiness.md
│   │   │       ├── bmad-generate-project-context.md
│   │   │       ├── bmad-document-project.md
│   │   │       ├── bmad-sprint-planning.md
│   │   │       ├── bmad-sprint-status.md
│   │   │       ├── bmad-create-story.md
│   │   │       ├── bmad-dev-story.md
│   │   │       ├── bmad-code-review.md
│   │   │       ├── bmad-qa-e2e-tests.md
│   │   │       ├── bmad-retrospective.md
│   │   │       ├── bmad-correct-course.md
│   │   │       ├── bmad-quick-spec.md
│   │   │       └── bmad-quick-dev.md
│   │   └── templates/                 ← 17 task templates
│   │       ├── phase2-prd.md
│   │       ├── phase2-ux.md
│   │       ├── phase3-architecture.md
│   │       ├── phase3-stories.md
│   │       ├── phase3-readiness.md
│   │       ├── phase3-project-context.md
│   │       ├── phase4-sprint-planning.md
│   │       ├── phase4-create-story.md
│   │       ├── phase4-dev-story.md
│   │       ├── phase4-review-blind.md
│   │       ├── phase4-review-edge.md
│   │       ├── phase4-review-acceptance.md
│   │       ├── phase4-e2e-tests.md
│   │       ├── phase4-retrospective.md
│   │       ├── phase4-course-correction.md
│   │       ├── quickflow-spec.md
│   │       └── quickflow-dev.md
│   └── branching-matrix-analysis/     ← Matrix thinking skill
│       └── SKILL.md
└── hooks/hooks.json                   ← SessionStart checkpoint detect
```

**62 files total.** ~95% coverage of BMAD Method v6.2.0. Self-contained — works without external dependencies. NeuralMemory is an optional enhancement for cross-agent memory.

## Origin

- **BMAD Method v6.2.0** by BMad — structured agile with adversarial review
- **Orchestra Model v2** by Tyler Vo — parallel agent execution + shared brain
- **Branching Matrix Analysis** — systematic gap-finding

Built and validated with 25 implementation tasks, 88 tests, full Phase 1→4 cycle on real features.

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0.0 | 2026-03-17 | Full BMAD fidelity: 23 workflows (7,690 lines) adapted from 346 source files. 9 enriched agent personas. 3 new references (doc-standards, context-template, command-registry). 17 templates with mandatory workflow refs. ~95% BMAD v6.2.0 coverage. |
| 1.0.0 | 2026-03-17 | Initial release: 9 agents, 17 templates, 5 condensed workflows, 9 matrix trigger points. |
