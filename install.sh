#!/usr/bin/env bash
# D4C CoWork Skills — One-line installer
# Usage: curl -fsSL https://raw.githubusercontent.com/NoonMoonAI/d4c-cowork-skills/main/install.sh | bash

set -e

REPO="https://raw.githubusercontent.com/NoonMoonAI/d4c-cowork-skills/main"
SKILL_DIR="$HOME/.claude/skills/d4c-moodboard"
SETTINGS="$HOME/.claude/settings.json"

echo ""
echo "D4C CoWork Skills Installer"
echo "==========================="
echo ""

# 1. Install the skill
echo "→ Installing d4c-moodboard skill..."
mkdir -p "$SKILL_DIR"
curl -fsSL "$REPO/skills/d4c-moodboard/SKILL.md" -o "$SKILL_DIR/SKILL.md"
echo "  ✓ Skill installed at $SKILL_DIR"

# 2. Python dependencies
echo ""
echo "→ Installing Python dependencies..."
pip3 install pillow psd-tools --quiet
echo "  ✓ pillow + psd-tools ready"

# 3. Adobe plugin — add to settings.json if not already there
echo ""
echo "→ Checking Adobe plugin config..."
if [ -f "$SETTINGS" ]; then
  if grep -q "adobe-skills" "$SETTINGS" 2>/dev/null; then
    echo "  ✓ Adobe plugin already configured"
  else
    echo "  ℹ  Adobe plugin not found in settings.json"
    echo "     To enable background removal, add to $SETTINGS:"
    echo '     "extraKnownMarketplaces": { "adobe-skills": { "source": { "source": "github", "repo": "adobe/skills" } } }'
    echo '     "enabledPlugins": { "adobe-for-creativity@adobe-skills": true }'
  fi
else
  echo "  ℹ  No settings.json found — Claude CoWork may not be installed yet."
fi

echo ""
echo "==========================="
echo "Install complete."
echo ""
echo "Open Claude CoWork and type /d4c-moodboard to start building."
echo ""
