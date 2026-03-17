# Orchestra-BMAD — Multi-Agent Development Framework for Claude Code

Multi-agent orchestration system combining [BMAD Method v6.2.0](https://github.com/bmad-code-org/BMAD-METHOD) with Claude Code's Agent tool. 9 agents, 23 workflows, 4 phases — from idea to code + tests + docs.

## Architecture

```
                    ┌─────────────────┐
                    │  Orchestrator   │
                    │    (Opus)       │
                    └────────┬────────┘
                             │ dispatch via Agent tool
          ┌──────────────────┼──────────────────┐
          │                  │                  │
    ┌─────┴─────┐     ┌─────┴─────┐     ┌─────┴─────┐
    │  Phase 1-2 │     │  Phase 3   │     │  Phase 4   │
    │  Mary/John │     │  Winston   │     │  Amelia    │
    │  Sally     │     │  Paige     │     │  Quinn/Bob │
    └───────────┘     └───────────┘     └───────────┘
          │                  │                  │
          └──────────────────┼──────────────────┘
                             │
                    ┌────────┴────────┐
                    │  NeuralMemory   │
                    │ (optional)      │
                    └─────────────────┘
```

- **Orchestrator (Opus)**: Dispatches agents, quality gates, checkpoint/resume
- **Workers (Sonnet)**: Each agent gets persona + workflow + template via Agent tool
- **Shared Brain**: NeuralMemory for cross-agent context (optional enhancement)

## 4 Phases

| Phase | What | Agents | Workflows |
|-------|------|--------|-----------|
| 1. Analysis | Brainstorm, research, product brief | Mary | 4 |
| 2. Planning | PRD, UX design, validation | John, Sally | 4 |
| 3. Solutioning | Architecture, epics, readiness | Winston, John, Paige | 5 |
| 4. Implementation | Sprint, TDD, review, QA, retro | Bob, Amelia, Quinn | 10 |

## Quick Start

```bash
# 1. Clone
git clone https://github.com/imtylervo/orchestra-model.git
cd orchestra-model

# 2. Install
./orchestra-bmad/install.sh            # Auto-install to Claude Code
# OR manually:
cp -r orchestra-bmad/2.0.0/skills/orchestra-bmad <your-project>/.claude/skills/
cp -r orchestra-bmad/2.0.0/skills/branching-matrix-analysis <your-project>/.claude/skills/
cp orchestra-bmad/2.0.0/commands/orchestra.md <your-project>/.claude/commands/
cp orchestra-bmad/2.0.0/agents/*.md ~/.claude/agents/

# 3. Reload plugins in Claude Code
/reload-plugins

# 4. Use
/orchestra                     # Full BMAD cycle — new feature/product
/orchestra --quick "fix X"     # Quick Flow — Barry solo, small changes
/orchestra --resume            # Continue interrupted work
/orchestra --status            # Check progress
```

### Example

```
You: /orchestra
Orchestrator: "What do you want to build?"
You: "A task management app with team collaboration"

→ Phase 1: Asks 3-5 questions, creates product brief
→ Phase 2: John writes PRD, Sally designs UX
→ Phase 3: Winston designs architecture, John creates stories, readiness check
→ Phase 4: Amelia builds with TDD, Quinn reviews, Bob runs retro
→ Code + tests + docs committed to git
```

See [`orchestra-bmad/2.0.0/README.md`](orchestra-bmad/2.0.0/README.md) for full documentation, installation options, and usage guide.

## Stats

- **62 files**, 10,469 lines
- **23 workflows** (7,690 lines) — ~95% BMAD Method v6.2.0 coverage
- **9 agent personas** with full BMAD communication styles
- **17 templates** with mandatory workflow references
- **9 branching matrix trigger points**
- Validated with full Phase 1→4 cycle on real features

## Prerequisites

- Claude Code CLI
- Git
- NeuralMemory plugin (optional — enables cross-agent memory)

## Origin

- [BMAD Method v6.2.0](https://github.com/bmad-code-org/BMAD-METHOD) — AI-driven agile framework
- Orchestra Model v2 — parallel agent execution + shared brain
- Branching Matrix Analysis — systematic gap-finding

## License

MIT
