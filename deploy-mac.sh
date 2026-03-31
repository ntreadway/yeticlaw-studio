#!/usr/bin/env bash
# ============================================================================
# YetiClaw Studio — Mac Mini Deploy (OpenClaw + Ollama)
# ============================================================================
# Prerequisites:
#   brew install node ollama
#   npm install -g openclaw
#   ollama pull qwen3.5:14b
#
# Usage:
#   bash deploy-mac.sh
# ============================================================================
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
log()  { echo -e "${GREEN}[yeticlaw-mac]${NC} $1"; }
warn() { echo -e "${YELLOW}[yeticlaw-mac]${NC} $1"; }
err()  { echo -e "${RED}[yeticlaw-mac]${NC} $1"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$HOME/.openclaw/workspace"
SKILLS_DST="$WORKSPACE/skills"

# Check prerequisites
command -v openclaw &>/dev/null || err "OpenClaw not installed. Run: npm install -g openclaw"
command -v ollama &>/dev/null   || err "Ollama not installed. Run: brew install ollama"

# Check Ollama model
if ! ollama list 2>/dev/null | grep -q "qwen3.5"; then
    warn "Qwen3.5 not found. Pulling qwen3.5:14b (this may take a while)..."
    ollama pull qwen3.5:14b
fi

# Create workspace
mkdir -p "$SKILLS_DST"
log "Workspace: $WORKSPACE"

# Install config
if [ ! -f "$HOME/.openclaw/openclaw.json" ]; then
    cp "$SCRIPT_DIR/config-openclaw.json5" "$HOME/.openclaw/openclaw.json"
    warn "Config installed — edit ~/.openclaw/openclaw.json to add your Telegram token"
else
    log "Config already exists — skipping (edit manually if needed)"
fi

# Install SOUL + AGENTS
cp "$SCRIPT_DIR/SOUL.md" "$WORKSPACE/SOUL.md"
cp "$SCRIPT_DIR/AGENTS.md" "$WORKSPACE/AGENTS.md"
log "SOUL.md + AGENTS.md installed ✓"

# Install public skills
log "Installing skills..."
for skill_dir in "$SCRIPT_DIR/skills"/*/; do
    skill=$(basename "$skill_dir")
    src="$skill_dir/SKILL.md"
    dst="$SKILLS_DST/$skill"
    [ -f "$src" ] || continue
    mkdir -p "$dst"
    cp "$src" "$dst/SKILL.md"
    log "  ✓ $skill"
done

# Install private skills if present
PRIVATE_DIR="$SCRIPT_DIR/yeticlaw-private/skills"
if [ -d "$PRIVATE_DIR" ]; then
    log "Installing private skills..."
    for skill_dir in "$PRIVATE_DIR"/*/; do
        skill=$(basename "$skill_dir")
        src="$skill_dir/SKILL.md"
        dst="$SKILLS_DST/$skill"
        [ -f "$src" ] || continue
        mkdir -p "$dst"
        cp "$src" "$dst/SKILL.md"
        log "  ✓ $skill (private)"
    done
fi

# Start Ollama if not running
if ! pgrep -x ollama &>/dev/null; then
    log "Starting Ollama..."
    ollama serve &>/dev/null &
    sleep 3
fi

# Install OpenClaw daemon
log "Installing OpenClaw daemon..."
openclaw onboard --install-daemon --yes 2>/dev/null || true

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}   YetiClaw Studio — Mac Mini Ready        ${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "  Model:    Qwen3.5 14B (local via Ollama)"
echo "  Gateway:  http://localhost:18789"
echo ""
warn "  Next: edit ~/.openclaw/openclaw.json"
warn "  Add your Telegram bot token + user ID"
warn "  Then: openclaw gateway"
echo ""
echo "  Agents available:"
echo "  /producer  /gamedesigner  /threejsdev"
echo "  /artdirector  /emailwriter  /imagegen"
echo "  + $(ls $SKILLS_DST | wc -l | tr -d ' ') total skills installed"
echo ""
