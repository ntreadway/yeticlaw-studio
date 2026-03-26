#!/usr/bin/env bash
# ============================================================================
# YetiClaw Studio Agents — macOS Deploy Script
# Installs all 24 skill files and config to ~/.picoclaw/
#
# Usage: bash deploy-mac.sh
# No sudo required.
# ============================================================================
set -euo pipefail

WORKSPACE="$HOME/.picoclaw/workspace"
CONFIG_DIR="$HOME/.picoclaw"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
log()  { echo -e "${GREEN}[deploy-mac]${NC} $1"; }
warn() { echo -e "${YELLOW}[deploy-mac]${NC} $1"; }
err()  { echo -e "${RED}[deploy-mac]${NC} $1"; exit 1; }

# Check picoclaw is installed
command -v picoclaw &>/dev/null || err "picoclaw not found. Install from: https://picoclaw.io"

# Check Ollama is running
if ! curl -s http://127.0.0.1:11434 &>/dev/null; then
    warn "Ollama not responding at :11434"
    warn "Start it with: brew services start ollama"
    warn "Then pull the model: ollama pull qwen3.5:4b"
fi

# Check rclone
command -v rclone &>/dev/null || warn "rclone not installed — Google Drive saves will not work. Install: brew install rclone"

# Create workspace
mkdir -p "$WORKSPACE/skills"

# Backup existing config
if [ -f "$CONFIG_DIR/config.json" ]; then
    cp "$CONFIG_DIR/config.json" "$CONFIG_DIR/config.json.bak.$(date +%Y%m%d%H%M%S)"
    log "Backed up existing config"
fi

# Install skill files
AGENTS="creative-director technical-director producer \
        game-designer level-designer systems-designer \
        gameplay-programmer engine-programmer ai-programmer ui-programmer unity-specialist \
        art-director sound-designer technical-artist \
        narrative-director writer world-builder qa-tester \
        threejs-dev ai-consultant email-writer avatar-clothing \
        asset-approver meshy"

log "Installing skill files..."
for agent in $AGENTS; do
    src="$SCRIPT_DIR/skills/$agent/SKILL.md"
    dst="$WORKSPACE/skills/$agent"
    [ -f "$src" ] || { warn "Missing $src — skipping"; continue; }
    mkdir -p "$dst"
    cp "$src" "$dst/SKILL.md"
    log "  ✓ $agent"
done

# Install AGENTS.md
cp "$SCRIPT_DIR/AGENTS.md" "$WORKSPACE/AGENTS.md"
log "AGENTS.md installed ✓"

# Install config — patch workspace path for macOS
log "Installing config.json..."
python3 -c "
import json, os
with open('$SCRIPT_DIR/config.json') as f:
    cfg = json.load(f)
# Update workspace path for macOS
cfg['agents']['defaults']['workspace'] = os.path.expanduser('~/.picoclaw/workspace')
# Update model to use Ollama endpoint
for m in cfg['model_list']:
    if m['model_name'] == 'qwen3.5:4b':
        m['model'] = 'openai/qwen3.5:4b'
        m['api_base'] = 'http://127.0.0.1:11434/v1'
        m['api_key'] = 'ollama'
with open('$CONFIG_DIR/config.json', 'w') as f:
    json.dump(cfg, f, indent=4)
print('config.json written with macOS paths')
"

# rclone gdrive check
if ! rclone listremotes 2>/dev/null | grep -q "^gdrive:"; then
    warn "Google Drive remote 'gdrive' not configured."
    warn "Run: rclone config"
    warn "(Name the remote 'gdrive', type: drive, follow OAuth in browser)"
else
    log "gdrive remote found — creating folder structure..."
    for folder in threejs outreach avatar-clothing gamedev meshy-models asset-spend; do
        rclone mkdir "gdrive:YetiClaw/$folder" 2>/dev/null || true
    done
    log "Drive folders ready ✓"
fi

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}   YetiClaw Studio — macOS Deploy Complete  ${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "  Next steps:"
echo ""
echo "  1. Edit ~/.picoclaw/config.json"
echo "     → Set channels.telegram.token"
echo "     → Set channels.telegram.allow_from to your Telegram user ID"
echo "     → Replace YOUR_GEMINI_API_KEY with your key from aistudio.google.com/apikey"
echo ""
echo "  2. Add Meshy key to your shell:"
echo "     echo 'export MESHY_API_KEY=\"your_key\"' >> ~/.zshrc && source ~/.zshrc"
echo ""
echo "  3. Start the gateway:"
echo "     picoclaw gateway"
echo ""
echo "  4. Test in Telegram:"
echo "     /gamedesigner design a stamina system for combat"
echo ""
