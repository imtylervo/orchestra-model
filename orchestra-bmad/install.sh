#!/bin/bash
# Orchestra-BMAD Plugin Installer
# Usage: ./install.sh [project-dir]
#
# Installs orchestra-bmad plugin for Claude Code.
# Option 1: Plugin cache (global) — default
# Option 2: Project-level (pass project dir)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$SCRIPT_DIR/2.0.0"
PROJECT_DIR="${1:-}"

if [ ! -d "$PLUGIN_DIR" ]; then
  echo "Error: Plugin directory not found at $PLUGIN_DIR"
  exit 1
fi

echo "Orchestra-BMAD Plugin Installer v2.0.0"
echo "======================================="

if [ -n "$PROJECT_DIR" ]; then
  # Project-level install
  echo "Installing to project: $PROJECT_DIR"

  mkdir -p "$PROJECT_DIR/.claude/skills"
  mkdir -p "$PROJECT_DIR/.claude/commands"

  cp -r "$PLUGIN_DIR/skills/orchestra-bmad" "$PROJECT_DIR/.claude/skills/"
  cp -r "$PLUGIN_DIR/skills/branching-matrix-analysis" "$PROJECT_DIR/.claude/skills/"
  cp "$PLUGIN_DIR/commands/orchestra.md" "$PROJECT_DIR/.claude/commands/"

  # Agents go to user-level
  cp "$PLUGIN_DIR"/agents/*.md ~/.claude/agents/ 2>/dev/null || true

  echo ""
  echo "Installed:"
  echo "  Skills:   $PROJECT_DIR/.claude/skills/orchestra-bmad/"
  echo "  Skills:   $PROJECT_DIR/.claude/skills/branching-matrix-analysis/"
  echo "  Command:  $PROJECT_DIR/.claude/commands/orchestra.md"
  echo "  Agents:   ~/.claude/agents/ (9 files)"

else
  # Global plugin cache install
  CACHE_DIR="$HOME/.claude/plugins/cache/orchestra-bmad-local/orchestra-bmad/2.0.0"

  echo "Installing to global plugin cache..."
  mkdir -p "$CACHE_DIR"
  cp -r "$PLUGIN_DIR"/* "$CACHE_DIR/"
  cp -r "$PLUGIN_DIR"/.claude-plugin "$CACHE_DIR/"

  # Register in installed_plugins.json
  PLUGINS_FILE="$HOME/.claude/plugins/installed_plugins.json"
  if [ -f "$PLUGINS_FILE" ]; then
    python3 -c "
import json, sys
with open('$PLUGINS_FILE') as f: data = json.load(f)
data['plugins']['orchestra-bmad@orchestra-bmad-local'] = [{
    'scope': 'user',
    'installPath': '$CACHE_DIR',
    'version': '2.0.0',
    'installedAt': '$(date -u +%Y-%m-%dT%H:%M:%S.000Z)',
    'lastUpdated': '$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'
}]
with open('$PLUGINS_FILE', 'w') as f: json.dump(data, f, indent=2)
print('Registered in installed_plugins.json')
" || echo "Warning: Could not register plugin. Manual registration needed."
  fi

  echo ""
  echo "Installed to: $CACHE_DIR"
fi

echo ""
echo "Next steps:"
echo "  1. Run /reload-plugins in Claude Code"
echo "  2. Test: /orchestra --check"
echo "  3. Build something: /orchestra"
echo ""
echo "Done!"
