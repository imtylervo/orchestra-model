---
allowed-tools: Agent, Read, Bash(git:*), Bash(test:*), Bash(ls:*), Bash(cat:*), Bash(mkdir:*), Skill
description: Start Orchestra-BMAD workflow — structured agile development with parallel agents
argument-hint: '[--quick "change"] [--resume] [--status] [--check]'
---

## Context

- Working directory: !`pwd`
- Git status: !`git status --short 2>/dev/null || echo "not a git repo"`
- Checkpoint exists: !`test -f _bmad-output/.orchestra-state.yaml && echo "YES — resume available" || echo "no"`

## Your task

Invoke the `orchestra-bmad` skill with the user's arguments.

### Flag handling

**No args or feature description** → Full BMAD cycle (Phase 1-4)
**`--quick "description"`** → Quick Flow via Barry (spec + dev, skip phases 1-3)
**`--resume`** → Resume from checkpoint in `_bmad-output/.orchestra-state.yaml`
**`--status`** → Show current progress from checkpoint file
**`--check`** → Verify plugin health: count agents (9), templates (17), skill exists

### Instructions

1. Parse the arguments provided
2. Use the Skill tool to invoke `orchestra-bmad` skill
3. Pass the parsed mode and any description to the skill

If `--check`: read and count files in plugin directories, report health without invoking the skill.
