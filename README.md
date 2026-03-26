# YetiClaw Game Studio Agents

> 25 specialized AI agents for game development, AI consulting, avatar creation, and business outreach — running privately on your own hardware via Picoclaw and Qwen3.5 4B.

[![25 Agents](https://img.shields.io/badge/agents-25-blueviolet)](./skills)
[![24 Skills](https://img.shields.io/badge/skills-24-green)](./skills)
[![Picoclaw](https://img.shields.io/badge/runtime-Picoclaw-orange)](https://picoclaw.io)
[![Qwen3.5 4B](https://img.shields.io/badge/model-Qwen3.5%204B-blue)](https://ollama.com/library/qwen3.5)
[![ClaWHub Compatible](https://img.shields.io/badge/clawhub-compatible-red)](https://clawhub.ai)
[![MIT License](https://img.shields.io/badge/license-MIT-blue)](./LICENSE)

---

## Docs

- [README.md](README.md) — setup and installation
- [WORKFLOW.md](WORKFLOW.md) — how to brief agents and run a game project
- [AGENTS.md](AGENTS.md) — quick slash command reference

---

## What Is This?

A complete Picoclaw skill pack that turns your private hardware into a full AI studio. Core workflows run entirely locally — no cloud subscription required for day-to-day use. Optional paid APIs (Nano Banana 2, Meshy) are gated behind a human approval step so you stay in control of spend.

**Works on:**
- 🍊 Orange Pi 6 Plus (ARM64) — the original YetiClaw setup
- 🍎 macOS (Apple Silicon or Intel)
- 🐧 Any Linux x86_64 or ARM64 machine

---

## Agent Roster

### 🎬 Directors
| Command | Role |
|---|---|
| `/creativedirector` | Creative vision, tone, aesthetic, MDA review |
| `/technicaldirector` | Unity/Three.js architecture decisions (code-gen) |
| `/producer` | Sprint planning, milestones, blockers |

### 🎮 Game Design
| Command | Role |
|---|---|
| `/gamedesigner` | Mechanics, GDDs, MDA framework, Bartle player types |
| `/leveldesigner` | Level layouts, flow, pacing, encounters |
| `/systemsdesigner` | Economy, progression, data-driven systems |

### 💻 Programming (code-gen — Unity Editor not required on this machine)
| Command | Role |
|---|---|
| `/gameplayprogrammer` | Unity C# player mechanics, movement, combat |
| `/engineprogrammer` | Unity C# core: save systems, scene management, Addressables |
| `/aiprogrammer` | Unity C# enemy AI, behavior trees, NavMesh |
| `/uiprogrammer` | Unity UI Toolkit, HUD, menus, accessibility |
| `/unityspecialist` | Package conflicts, editor scripting, render pipeline |

### 🎨 Art & Audio
| Command | Role |
|---|---|
| `/artdirector` | Visual style guide, art briefs, concept generation (Nano Banana 2) |
| `/sounddesigner` | Audio identity, FMOD events, adaptive music |
| `/technicalartist` | Shaders, VFX Graph, asset import pipeline (code-gen) |

### 📖 Narrative & QA
| Command | Role |
|---|---|
| `/narrativedirector` | Story structure, character arcs, narrative design |
| `/writer` | Dialogue, UI copy, item descriptions, voice guide |
| `/worldbuilder` | Lore, factions, geography, world bible |
| `/qatester` | Test plans, bug reports (Critical / High / Medium / Low) |

### 🌐 Web & XR
| Command | Role |
|---|---|
| `/threejsdev` | TypeScript Three.js games for VIVERSE (WebGL/WebXR) — orchestrates asset pipeline |

### 💼 Business
| Command | Role |
|---|---|
| `/emailwriter` | Outreach for game dev · AI integration · AI app dev |
| `/aiconsultant` | Find AI integration leads, profile companies, pitch angles |

### 👗 Avatar
| Command | Role |
|---|---|
| `/avatarclothing` | Meta Horizon avatar clothing — paste Gemini UV description → texture spec + Blender script |

### 💰 Asset Generation (approval required before any paid API fires)
| Command | Role |
|---|---|
| `/assetapprover` | Budget gate — shows cost, waits for `/approve` or `/deny` |
| `/meshy` | Meshy.ai text-to-3D and image-to-3D (GLB output) |

---

## Asset Generation Workflow

```
/threejsdev or /artdirector
    → produces Asset Brief
        → /assetapprover [brief]
            → shows cost estimate in Telegram
                → you reply /approve [name] or /deny [name]
                    ✓ approve → Nano Banana 2 or /meshy executes
                    ✗ deny   → placeholder used, no spend
```

**Nano Banana 2** (`gemini-3.1-flash-image-preview`) handles both:
- Image **generation** — concept art, textures, UI assets
- Image **understanding** — reads UV maps and clothing photos

**Meshy** — text-to-3D and image-to-3D, GLB output saved to Google Drive

---

## Prerequisites

### All platforms
- A [Telegram bot token](https://t.me/BotFather)
- A [Gemini API key](https://aistudio.google.com/apikey) (for Nano Banana 2)
- A [Meshy API key](https://www.meshy.ai/api) (for 3D model generation, Pro plan required)
- [rclone](https://rclone.org) configured with a `gdrive` remote (for Google Drive saves)
- [Node.js 20+](https://nodejs.org) (for Google Drive and Gmail MCP servers)

### Orange Pi 6 Plus only
- Debian 13 (Trixie) or Ubuntu 24.04
- 16GB RAM minimum
- Your HuggingFace token (`HF_TOKEN`) for model download

### macOS only
- [Ollama](https://ollama.com) — serves Qwen3.5 locally (easier than raw llama.cpp on Mac)
- Homebrew (for rclone, Node.js, jq)
- Apple Silicon (M1/M2/M3/M4) recommended — Intel works but will be slower

---

## Installation

### 🍊 Orange Pi 6 Plus

#### Step 1 — Run the YetiClaw base installer

This sets up llama.cpp, downloads the model, and installs Picoclaw:

```bash
# On the Pi as root
sudo HF_TOKEN=hf_your_token_here bash install.sh
```

The installer handles: llama.cpp build with KleidiAI optimizations, Qwen3.5 4B Q4_K_M download, Picoclaw install, systemd services, firewall, and mDNS.

#### Step 2 — Copy and run the agent deploy script

From your computer:
```bash
# Download and extract this repo
tar -xzf yeticlaw-agents.tar.gz

# Copy to the Pi
scp -r yeticlaw-agents/ orangepi@yeticlaw.local:/tmp/

# SSH in and deploy
ssh orangepi@yeticlaw.local
sudo bash /tmp/yeticlaw-agents/deploy.sh
```

The deploy script will:
- Install rclone if missing
- Copy all 24 skill files to `/opt/yeticlaw/openclaw/workspace/skills/`
- Create all agent session directories
- Install `config.json` to `~/.picoclaw/config.json`
- Restart `yeticlaw-gateway`

#### Step 3 — Set up Google Drive (first time only)

```bash
# As orangepi (not root)
su - orangepi
rclone config
# Choose: n (new remote) → name it gdrive → type: drive → follow OAuth prompts
```

#### Step 4 — Add API keys

```bash
# Edit ~/.picoclaw/config.json
# Replace YOUR_GEMINI_API_KEY with your key from aistudio.google.com/apikey

# Add Meshy key to environment
echo 'export MESHY_API_KEY="your_meshy_key_here"' >> /home/orangepi/.bashrc
source /home/orangepi/.bashrc

# Restart gateway to pick up config changes
sudo systemctl restart yeticlaw-gateway
```

#### Step 5 — Set up Google Drive and Gmail MCP servers (optional)

```bash
# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
sudo apt-get install -y nodejs

# Authenticate Google Drive (opens a browser URL — complete OAuth on your computer)
npx @piotr-agier/google-drive-mcp auth

# Authenticate Gmail
npx @gongrzhe/server-gmail-autoauth-mcp auth
```

Add the MCP servers to `~/.picoclaw/config.json` under `tools.mcp.servers` (see `config.json` in this repo for the full block).

---

### 🍎 macOS

#### Step 1 — Install dependencies

```bash
# Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install tools
brew install rclone jq node wget

# Install Ollama (serves Qwen3.5 locally)
brew install ollama
```

#### Step 2 — Download and start Qwen3.5

```bash
# Start the Ollama service
brew services start ollama

# Pull Qwen3.5 4B (multimodal — handles text + image)
ollama pull qwen3.5:4b

# Verify it's running
ollama list
```

#### Step 3 — Install Picoclaw

```bash
# Apple Silicon
curl -L https://github.com/sipeed/picoclaw/releases/latest/download/picoclaw_Darwin_arm64.tar.gz | tar xz
sudo mv picoclaw /usr/local/bin/

# Intel Mac
curl -L https://github.com/sipeed/picoclaw/releases/latest/download/picoclaw_Darwin_x86_64.tar.gz | tar xz
sudo mv picoclaw /usr/local/bin/

# Run onboarding to create default config
picoclaw onboard
```

#### Step 4 — Deploy the agents

```bash
# Extract this repo
tar -xzf yeticlaw-agents.tar.gz
cd yeticlaw-agents

# Run deploy (no sudo needed on Mac — paths adjust automatically)
bash deploy-mac.sh
```

> **Note:** On macOS the deploy script installs skills to `~/.picoclaw/workspace/skills/` and config to `~/.picoclaw/config.json`. The Orange Pi deploy script targets `/opt/yeticlaw/` — they are different scripts.

#### Step 5 — Update config.json for Ollama

On macOS, Picoclaw connects to Ollama instead of a raw llama.cpp server. Edit `~/.picoclaw/config.json` and update the `model_list` entry:

```json
{
    "model_name": "qwen3.5:4b",
    "model": "openai/qwen3.5:4b",
    "api_base": "http://127.0.0.1:11434/v1",
    "api_key": "ollama",
    "timeout": 120
}
```

#### Step 6 — Add API keys

```bash
# Edit ~/.picoclaw/config.json
# Replace YOUR_GEMINI_API_KEY with your key from aistudio.google.com/apikey

# Add Meshy key
echo 'export MESHY_API_KEY="your_meshy_key_here"' >> ~/.zshrc
source ~/.zshrc
```

#### Step 7 — Set up Google Drive (first time only)

```bash
rclone config
# Choose: n → name it gdrive → type: drive → follow OAuth prompts (browser opens automatically on Mac)
```

#### Step 8 — Set up Google Drive and Gmail MCP servers (optional)

```bash
# Authenticate Google Drive
npx @piotr-agier/google-drive-mcp auth

# Authenticate Gmail
npx @gongrzhe/server-gmail-autoauth-mcp auth
```

#### Step 9 — Start the gateway

```bash
picoclaw gateway
```

To run as a background service on macOS:
```bash
# Create a LaunchAgent
cat > ~/Library/LaunchAgents/io.picoclaw.gateway.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>io.picoclaw.gateway</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/picoclaw</string>
        <string>gateway</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/picoclaw.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/picoclaw-error.log</string>
</dict>
</plist>
EOF

launchctl load ~/Library/LaunchAgents/io.picoclaw.gateway.plist
```

---

## Configuration Reference

### config.json structure

```json
{
    "agents": {
        "defaults": {
            "model_name": "qwen3.5:4b",
            "workspace": "/opt/yeticlaw/openclaw/workspace",
            "max_history": 5,
            "max_tool_iterations": 3,
            "max_tokens": 8192,
            "temperature": 0.7
        },
        "list": { ... }
    },
    "model_list": [
        {
            "model_name": "qwen3.5:4b",
            "model": "openai/qwen3.5-4b-q4_k_m.gguf",
            "api_base": "http://127.0.0.1:8080/v1",
            "api_key": "none",
            "timeout": 120
        },
        {
            "model_name": "nano-banana-2",
            "model": "gemini/gemini-3.1-flash-image-preview",
            "api_key": "YOUR_GEMINI_API_KEY",
            "timeout": 60
        }
    ],
    "tools": {
        "web": { "enabled": true, "duckduckgo": { "enabled": true, "max_results": 1 } },
        "exec": {
            "enabled": true,
            "allowlist": ["rclone copy *", "rclone mkdir *", "rclone ls *", "curl -s https://api.meshy.ai/*", "jq *"]
        },
        "mcp": {
            "enabled": true,
            "servers": {
                "gdrive": { "enabled": true, "command": "npx", "args": ["-y", "@piotr-agier/google-drive-mcp"] },
                "gmail":  { "enabled": true, "command": "npx", "args": ["-y", "@gongrzhe/server-gmail-autoauth-mcp"] }
            }
        }
    },
    "channels": {
        "telegram": {
            "enabled": true,
            "token": "YOUR_TELEGRAM_BOT_TOKEN",
            "allow_from": ["YOUR_TELEGRAM_USER_ID"]
        }
    }
}
```

### macOS workspace path

On macOS, change `workspace` in `agents.defaults` to:
```json
"workspace": "/Users/YOUR_USERNAME/.picoclaw/workspace"
```

### Google Drive save paths

| Agent | Drive Path |
|---|---|
| Three.js games | `gdrive:YetiClaw/threejs/` |
| Outreach emails | `gdrive:YetiClaw/outreach/` |
| Avatar clothing | `gdrive:YetiClaw/avatar-clothing/` |
| Game design docs | `gdrive:YetiClaw/gamedev/` |
| Meshy 3D models | `gdrive:YetiClaw/meshy-models/` |
| Asset spend log | `gdrive:YetiClaw/asset-spend/` |

---

## Verify It's Working

Open Telegram and message your bot:

```
/gamedesigner design a simple coin collection mechanic
```
```
/emailwriter find Unity indie studios in Los Angeles
```
```
/threejsdev scaffold a first-person maze game for VIVERSE
```
```
/assetapprover I need a 2048x2048 stone wall texture
```

---

## Avatar Clothing Workflow

This agent uses Nano Banana 2's vision capability to read UV maps and clothing photos.

1. Send your UV map + clothing photo to **Gemini** (your existing workflow)
2. Copy Gemini's description of the UV layout and clothing regions
3. In Telegram: `/avatarclothing [paste Gemini description here]`
4. Agent produces:
   - Texture paint spec (region by region)
   - Blender Python bake setup script
   - Meta Horizon upload checklist
5. Files saved to `gdrive:YetiClaw/avatar-clothing/`

---

## Publishing to ClaWHub

All skills use Picoclaw-compatible YAML frontmatter and are ready to publish to [clawhub.ai](https://clawhub.ai).

```bash
# Install the ClaWHub CLI (on your computer)
npm install -g clawhub

# Log in with GitHub
clawhub login

# Publish all skills
cd yeticlaw-agents/skills
for skill in */; do
    clawhub publish "$skill"
done
```

Each skill gets a page at `clawhub.ai/your-handle/skill-name`.

---

## Platform Differences

| Feature | Orange Pi 6 Plus | macOS |
|---|---|---|
| Model server | llama.cpp (KleidiAI optimized) | Ollama |
| Model format | Q4_K_M GGUF | Ollama pull |
| Speed | ~12 tok/s gen | ~40+ tok/s (M-series) |
| Gateway service | systemd | LaunchAgent |
| Deploy script | `deploy.sh` (requires sudo) | `deploy-mac.sh` (no sudo) |
| Workspace path | `/opt/yeticlaw/openclaw/workspace` | `~/.picoclaw/workspace` |
| Config path | `~/.picoclaw/config.json` | `~/.picoclaw/config.json` |
| Vulkan GPU | Disabled (shared LPDDR5) | Metal (via Ollama) |

---

## Troubleshooting

**Gateway not starting (Orange Pi)**
```bash
journalctl -u yeticlaw-gateway -f
journalctl -u llama-server -f
```

**Gateway not starting (macOS)**
```bash
cat /tmp/picoclaw-error.log
# Check Ollama is running
ollama list
```

**Skill not loading / agent not responding to command**
```bash
# Check skill frontmatter is valid — name must match ^[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*$
head -4 ~/.picoclaw/workspace/skills/game-designer/SKILL.md
```

**Meshy API failing**
```bash
# Check balance first
curl -s https://api.meshy.ai/openapi/v1/credits \
  -H "Authorization: Bearer $MESHY_API_KEY" | jq '.credits'
```

**rclone not syncing to Drive**
```bash
rclone ls gdrive:YetiClaw
# If empty or error, re-authenticate:
rclone config reconnect gdrive:
```

**n_predict cutting off responses (Orange Pi)**

Increase `--n-predict` in the llama-server systemd service:
```bash
sudo nano /etc/systemd/system/llama-server.service
# Change --n-predict 192 to --n-predict 512
sudo systemctl daemon-reload && sudo systemctl restart llama-server
```

---

## File Structure

```
yeticlaw-agents/
├── README.md
├── AGENTS.md               ← Quick reference for all slash commands
├── config.json             ← Picoclaw config (edit API keys before deploying)
├── deploy.sh               ← Orange Pi deploy script
├── deploy-mac.sh           ← macOS deploy script
└── skills/
    ├── creative-director/SKILL.md
    ├── technical-director/SKILL.md
    ├── producer/SKILL.md
    ├── game-designer/SKILL.md
    ├── level-designer/SKILL.md
    ├── systems-designer/SKILL.md
    ├── gameplay-programmer/SKILL.md
    ├── engine-programmer/SKILL.md
    ├── ai-programmer/SKILL.md
    ├── ui-programmer/SKILL.md
    ├── unity-specialist/SKILL.md
    ├── art-director/SKILL.md
    ├── sound-designer/SKILL.md
    ├── technical-artist/SKILL.md
    ├── narrative-director/SKILL.md
    ├── writer/SKILL.md
    ├── world-builder/SKILL.md
    ├── qa-tester/SKILL.md
    ├── threejs-dev/SKILL.md
    ├── ai-consultant/SKILL.md
    ├── email-writer/SKILL.md
    ├── avatar-clothing/SKILL.md
    ├── asset-approver/SKILL.md
    └── meshy/SKILL.md
```

---

## License

MIT — see [LICENSE](./LICENSE)

Skills are compatible with both Picoclaw and OpenClaw SKILL.md format.
