#!/usr/bin/env bash
# ============================================================================
# YetiClaw Studio Agents — Deploy Script
# Usage (run on the Orange Pi as root or with sudo):
#   sudo bash deploy.sh
#
# Or from your machine:
#   scp -r yeticlaw-studio/ orangepi@yeticlaw.local:/tmp/
#   ssh orangepi@yeticlaw.local "sudo bash /tmp/yeticlaw-studio/deploy.sh"
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

# ── rclone ────────────────────────────────────────────────────────────────────
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
    for folder in threejs outreach gamedev meshy-models asset-spend; do
        rclone mkdir "gdrive:YetiClaw/$folder" 2>/dev/null || true
    done
    log "Drive folders ready ✓"
fi

# ── Backup and preserve existing credentials ──────────────────────────────────
if [ -f "$HOME_CONFIG/config.json" ]; then
    cp "$HOME_CONFIG/config.json" "$HOME_CONFIG/config.json.bak.$(date +%Y%m%d%H%M%S)"
    log "Config backed up"

    EXISTING_TOKEN=$(python3 -c "
import json
try:
    cfg = json.load(open('$HOME_CONFIG/config.json'))
    print(cfg.get('channels', {}).get('telegram', {}).get('token', ''))
except: print('')
" 2>/dev/null || echo "")

    EXISTING_ALLOW_FROM=$(python3 -c "
import json
try:
    cfg = json.load(open('$HOME_CONFIG/config.json'))
    af = cfg.get('channels', {}).get('telegram', {}).get('allow_from', [])
    print(json.dumps(af))
except: print('[]')
" 2>/dev/null || echo "[]")

    EXISTING_GEMINI=$(python3 -c "
import json
try:
    cfg = json.load(open('$HOME_CONFIG/config.json'))
    for m in cfg.get('model_list', []):
        if m.get('model_name') == 'nano-banana-2':
            print(m.get('api_key', ''))
except: print('')
" 2>/dev/null || echo "")
else
    EXISTING_TOKEN=""
    EXISTING_ALLOW_FROM="[]"
    EXISTING_GEMINI=""
fi

# ── Skills ────────────────────────────────────────────────────────────────────
# Note: avatar-clothing and full email-writer are in yeticlaw-private/
# Run deploy-private.sh after this to install them
AGENTS="creative-director technical-director producer \
        game-designer level-designer systems-designer \
        gameplay-programmer engine-programmer ai-programmer ui-programmer unity-specialist \
        art-director sound-designer technical-artist \
        narrative-director writer world-builder qa-tester \
        threejs-dev ai-consultant email-writer \
        imagegen asset-approver \
        asset-approver meshy \
        game-namer concept-writer mechanics-designer style-writer"

log "Installing skill files..."
for agent in $AGENTS; do
    src="$SCRIPT_DIR/skills/$agent/SKILL.md"
    dst="$WORKSPACE/skills/$agent"
    [ -f "$src" ] || { warn "Missing $src — skipping"; continue; }
    mkdir -p "$dst"
    cp "$src" "$dst/SKILL.md"
    log "  ✓ $agent"
done

# AGENTS.md reference doc
cp "$SCRIPT_DIR/AGENTS.md" "$WORKSPACE/AGENTS.md"
cp "$SCRIPT_DIR/PROJECTS.md" "$WORKSPACE/PROJECTS.md" 2>/dev/null || true
cp "$SCRIPT_DIR/SOUL.md" "$WORKSPACE/SOUL.md" 2>/dev/null || true 2>/dev/null || true
mkdir -p "$WORKSPACE/projects"
log "AGENTS.md installed ✓"

# ── Config ────────────────────────────────────────────────────────────────────
log "Installing config.json..."
mkdir -p "$HOME_CONFIG"
cp "$SCRIPT_DIR/config.json" "$HOME_CONFIG/config.json"

# Patch back preserved credentials so redeploy doesn't wipe them
python3 << PYEOF
import json

with open('$HOME_CONFIG/config.json', 'r') as f:
    cfg = json.load(f)

existing_token = '''$EXISTING_TOKEN'''.strip()
existing_allow_from = json.loads('''$EXISTING_ALLOW_FROM''')
existing_gemini = '''$EXISTING_GEMINI'''.strip()

if existing_token:
    cfg['channels']['telegram']['token'] = existing_token
    print("  Telegram token preserved ✓")

if existing_allow_from:
    cfg['channels']['telegram']['allow_from'] = existing_allow_from
    print("  Telegram allow_from preserved ✓")

if existing_gemini and existing_gemini not in ('', 'YOUR_GEMINI_API_KEY'):
    for m in cfg.get('model_list', []):
        if m.get('model_name') == 'nano-banana-2':
            m['api_key'] = existing_gemini
    print("  Gemini API key preserved ✓")

with open('$HOME_CONFIG/config.json', 'w') as f:
    json.dump(cfg, f, indent=4)
PYEOF

cp "$HOME_CONFIG/config.json" "$CONFIG_DIR/config.json"

# ── Permissions ───────────────────────────────────────────────────────────────
chown -R orangepi:orangepi "$WORKSPACE" "$HOME_CONFIG" "$CONFIG_DIR" 2>/dev/null || true

# ── Restart ───────────────────────────────────────────────────────────────────
log "Restarting yeticlaw-gateway..."
systemctl restart yeticlaw-gateway
sleep 3
systemctl is-active --quiet yeticlaw-gateway && log "Gateway running ✓" || warn "Check: journalctl -u yeticlaw-gateway -f"

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}      YetiClaw Studio — Agents Deployed     ${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "  /creativedirector  /technicaldirector  /producer"
echo "  /gamedesigner  /leveldesigner  /systemsdesigner"
echo "  /gameplayprogrammer  /engineprogrammer  /aiprogrammer"
echo "  /uiprogrammer  /unityspecialist"
echo "  /artdirector  /sounddesigner  /technicalartist"
echo "  /narrativedirector  /writer  /worldbuilder  /qatester"
echo "  /threejsdev  /emailwriter  /aiconsultant"
echo "  /assetapprover  /meshy"
echo ""

# Check what still needs setting
TOKEN=$(python3 -c "
import json
try:
    cfg = json.load(open('$HOME_CONFIG/config.json'))
    print(cfg['channels']['telegram'].get('token',''))
except: print('')
" 2>/dev/null || echo "")

GEMINI=$(python3 -c "
import json
try:
    cfg = json.load(open('$HOME_CONFIG/config.json'))
    [print(m.get('api_key','')) for m in cfg.get('model_list',[]) if m.get('model_name')=='nano-banana-2']
except: print('')
" 2>/dev/null || echo "")

echo -e "${YELLOW}  Next steps:${NC}"

if [ -z "$TOKEN" ] || [ "$TOKEN" = "YOUR_TELEGRAM_BOT_TOKEN" ]; then
    echo "  ⚠  Set Telegram token:"
    echo "     nano $HOME_CONFIG/config.json"
    echo "     → channels.telegram.token"
    echo "     → channels.telegram.allow_from"
    echo ""
fi

if [ -z "$GEMINI" ] || [ "$GEMINI" = "YOUR_GEMINI_API_KEY" ]; then
    echo "  ⚠  Set Gemini API key (for art-director and avatar-clothing):"
    echo "     nano $HOME_CONFIG/config.json"
    echo "     → model_list[nano-banana-2].api_key"
    echo "     Get key: https://aistudio.google.com/apikey"
    echo ""
fi

echo "  Run private skills overlay (Yeti Games internal):"
echo "    sudo bash yeticlaw-private/deploy-private.sh"
echo ""
echo "  Set up Google Drive and Gmail (once):"
echo "    See README.md — Step 5"
echo "    Then: nano $HOME_CONFIG/config.json"
echo "    → tools.mcp.servers.gdrive.enabled = true"
echo "    → tools.mcp.servers.gmail.enabled = true"
echo "    → sudo systemctl restart yeticlaw-gateway"
echo ""
