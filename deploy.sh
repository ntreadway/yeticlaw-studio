#!/usr/bin/env bash
# ============================================================================
# YetiClaw Studio Agents — Deploy Script v2
# 23 agents: game studio + Three.js/VIVERSE + AI consulting + avatar clothing
#
# Usage (run on the Orange Pi as root or with sudo):
#   sudo bash deploy.sh
#
# Or from your machine:
#   scp -r yeticlaw-agents/ orangepi@yeticlaw.local:/tmp/
#   ssh orangepi@yeticlaw.local "sudo bash /tmp/yeticlaw-agents/deploy.sh"
# ============================================================================
set -euo pipefail

WORKSPACE="/opt/yeticlaw/openclaw/workspace"
CONFIG_DIR="/opt/yeticlaw/openclaw"
HOME_CONFIG="/home/orangepi/.picoclaw"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
log()  { echo -e "${GREEN}[deploy]${NC} $1"; }
warn() { echo -e "${YELLOW}[deploy]${NC} $1"; }
err()  { echo -e "${RED}[deploy]${NC} $1"; exit 1; }

[[ $EUID -eq 0 ]] || err "Run as root: sudo bash deploy.sh"

# rclone
log "Checking rclone..."
if ! command -v rclone &>/dev/null; then
    log "Installing rclone..."
    curl https://rclone.org/install.sh | bash
else
    log "rclone $(rclone version | head -1) ✓"
fi

if ! rclone listremotes 2>/dev/null | grep -q "^gdrive:"; then
    warn "Google Drive remote 'gdrive' not configured."
    warn "After deploy, run as orangepi: rclone config"
    warn "(Name the remote 'gdrive', type: drive, follow OAuth)"
else
    log "gdrive remote found — creating folder structure..."
    for folder in threejs outreach avatar-clothing gamedev; do
        rclone mkdir "gdrive:YetiClaw/$folder" 2>/dev/null || true
    done
    log "Drive folders ready ✓"
fi

# Backup
[ -f "$HOME_CONFIG/config.json" ] && \
    cp "$HOME_CONFIG/config.json" "$HOME_CONFIG/config.json.bak.$(date +%Y%m%d%H%M%S)" && \
    log "Config backed up"

# Skills
AGENTS="creative-director technical-director producer \
        game-designer level-designer systems-designer \
        gameplay-programmer engine-programmer ai-programmer ui-programmer unity-specialist \
        art-director sound-designer technical-artist \
        narrative-director writer world-builder qa-tester \
        threejs-dev ai-consultant email-writer avatar-clothing asset-approver meshy"

log "Installing skill files..."
for agent in $AGENTS; do
    src="$SCRIPT_DIR/skills/$agent/SKILL.md"
    dst="$WORKSPACE/skills/$agent"
    [ -f "$src" ] || { warn "Missing $src — skipping"; continue; }
    mkdir -p "$dst"
    cp "$src" "$dst/SKILL.md"
    log "  ✓ $agent"
done

# AGENTS.md
cp "$SCRIPT_DIR/AGENTS.md" "$WORKSPACE/AGENTS.md"
log "AGENTS.md installed ✓"

# Session dirs
log "Creating session directories..."
for agent in $AGENTS; do
    mkdir -p "$CONFIG_DIR/agents/$agent/agent"
    mkdir -p "$CONFIG_DIR/agents/$agent/sessions"
    [ -f "$CONFIG_DIR/agents/$agent/sessions/sessions.json" ] || echo '{}' > "$CONFIG_DIR/agents/$agent/sessions/sessions.json"
done

# Config
log "Installing config.json..."
mkdir -p "$HOME_CONFIG"
cp "$SCRIPT_DIR/config.json" "$HOME_CONFIG/config.json"
cp "$SCRIPT_DIR/config.json" "$CONFIG_DIR/config.json"

# Permissions
chown -R orangepi:orangepi "$WORKSPACE" "$HOME_CONFIG" "$CONFIG_DIR" 2>/dev/null || true

# Restart
log "Restarting yeticlaw-gateway..."
systemctl restart yeticlaw-gateway
sleep 3
systemctl is-active --quiet yeticlaw-gateway && log "Gateway running ✓" || warn "Check: journalctl -u yeticlaw-gateway -f"

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}   YetiClaw Studio — 23 Agents Deployed    ${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "  /creativedirector  /technicaldirector  /producer"
echo "  /gamedesigner  /leveldesigner  /systemsdesigner"
echo "  /gameplayprogrammer  /engineprogrammer  /aiprogrammer"
echo "  /uiprogrammer  /unityspecialist"
echo "  /artdirector  /sounddesigner  /technicalartist"
echo "  /narrativedirector  /writer  /worldbuilder  /qatester"
echo "  /threejsdev"
echo "  /emailwriter  /aiconsultant  /avatarclothing"
echo ""
echo -e "${YELLOW}  If gdrive not set up yet:${NC} su - orangepi -c 'rclone config'"
echo -e "${YELLOW}  Set Telegram token:${NC} edit $HOME_CONFIG/config.json"
echo ""
