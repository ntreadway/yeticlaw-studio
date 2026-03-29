# YetiClaw Game Studio Agents
#### By Yeti Games, LLC

> 27 specialized AI agents for game development, AI consulting, avatar creation, and business outreach — running privately on your own hardware via Picoclaw and Qwen3.5 4B.

[![27 Agents](https://img.shields.io/badge/agents-27-blueviolet)](./skills)
[![27 Skills](https://img.shields.io/badge/skills-27-green)](./skills)
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

A complete Picoclaw skill pack that turns your private hardware into a full AI game studio. Core workflows run entirely locally — no cloud subscription required for day-to-day use. Optional paid APIs (Nano Banana 2, Meshy) are gated behind a human approval step so you stay in control of spend.

**Works on:**
- 🍊 Orange Pi 6 Plus (ARM64) — the original YetiClaw setup
- 🍎 macOS (Apple Silicon or Intel)
- 🐧 Any Linux x86_64 or ARM64 machine

---

## Creator Workflow — Brief to Build

The producer is the entry point for any new game project. Give it your full creative vision — story, art style, platform, mechanics, everything — and it writes a structured brief directly, then offers to expand any section with a specialist.

### Step 1 — Brief creation

Just tell the producer what you want. No need to simplify or break it into steps:

```
/producer write a brief for a Three.js 2D magic potion making game for VIVERSE.
Mobile and desktop controls. Young wizard named Zeal using dark magic to make the
Philosopher's Stone. Hermetic magic undertones. Appearance changes as he drinks
potions. Pixel art, light horror, 13+.
```

The producer reads your full vision and writes the brief immediately — no spawning, no waiting. You get back a structured document with game name, concept, mechanics, visual style, platform, timeline, and budget.

### Step 2 — Save the brief

```
save
```

Saves to `projects/[slug]/brief.md` in workspace and syncs to Google Drive.

### Step 3 — Expand sections with specialists

Once the brief exists, expand any section one at a time:

```
expand mechanics
expand narrative
expand three.js
expand levels
expand art
```

Each expansion spawns ONE specialist agent focused on that section only.

### Step 4 — Hand off to specialists

With the brief saved, any agent can read it directly:

```
/threejsdev scaffold the project structure for Zeal's Dark Alchemy
/gamedesigner design the potion brewing minigame
/narrativedirector write Zeal's character arc
```

---

## Agent Roster

### 🎬 Directors
| Command | Role |
|---|---|
| `/creativedirector` | Creative vision, tone, aesthetic, MDA review |
| `/technicaldirector` | Unity/Three.js architecture decisions (code-gen) |
| `/producer` | **Game brief creation** + sprint planning, milestones, blockers |

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
| `/threejsdev` | TypeScript Three.js games for VIVERSE (WebGL/WebXR) |

### 💼 Business
| Command | Role |
|---|---|
| `/emailwriter` | Outreach for game dev · AI integration · AI app dev |
| `/aiconsultant` | AI strategy and consulting for studios and SMBs |

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

**Nano Banana 2** (`gemini-3.1-flash-image-preview`) handles image generation and understanding.

**Meshy** — text-to-3D and image-to-3D, GLB output saved to Google Drive.

---

## Prerequisites

### All platforms
- A [Telegram bot token](https://t.me/BotFather)
- A [Gemini API key](https://aistudio.google.com/apikey) (for Nano Banana 2)
- A [Meshy API key](https://www.meshy.ai/api) (for 3D generation, Pro plan required)
- [rclone](https://rclone.org) configured with a `gdrive` remote
- [Node.js 20+](https://nodejs.org) (for Google Drive and Gmail MCP servers)

### Orange Pi 6 Plus only
- Ubuntu 24.04, 16GB RAM minimum
- Custom Picoclaw binary with 600s timeout fix (see below)

### macOS only
- [Ollama](https://ollama.com) — serves Qwen3.5 locally
- Apple Silicon recommended

---

## Installation

### 🍊 Orange Pi 6 Plus

> **Note:** The base installer (llama.cpp, model download, Picoclaw, systemd services) is not included in this repo. Contact me for installation services.

#### Step 1 — Deploy the agents

```bash
tar -xzf yeticlaw-studio.tar.gz
scp -r yeticlaw-studio/ orangepi@[your_ip]:/tmp/
ssh orangepi@[your_ip]
sudo bash /tmp/yeticlaw-studio/deploy.sh
```

#### Step 2 — Configure secrets

```bash
nano ~/.picoclaw/.security.yml
```

```yaml
channels:
  telegram:
    token: YOUR_TELEGRAM_BOT_TOKEN
model_list:
  nano-banana-2:
    api_key: YOUR_GEMINI_API_KEY
skills: {}
web: {}
```

```bash
chmod 600 ~/.picoclaw/.security.yml
```

Also set `channels.telegram.token` in `config.json` for compatibility.

#### Step 3 — Add Meshy key

```bash
sudo nano /etc/environment
# Add: MESHY_API_KEY=your_meshy_key_here
sudo systemctl restart yeticlaw-gateway
```

#### Step 4 — Set up Google Drive

```bash
su - orangepi
rclone config  # n → gdrive → drive → follow OAuth
npx @piotr-agier/google-drive-mcp auth
npx @gongrzhe/server-gmail-autoauth-mcp auth
```

---

### 🍎 macOS

```bash
brew install rclone jq node wget ollama
brew services start ollama
ollama pull qwen3.5:4b

# Install Picoclaw
curl -L https://github.com/sipeed/picoclaw/releases/latest/download/picoclaw_Darwin_arm64.tar.gz | tar xz
sudo mv picoclaw /usr/local/bin/
picoclaw onboard

# Deploy agents
tar -xzf yeticlaw-studio.tar.gz && cd yeticlaw-studio
bash deploy-mac.sh

picoclaw gateway
```

---

## Important: Custom Binary Required (Orange Pi)

The Orange Pi setup requires a **custom-built Picoclaw binary** with the HTTP timeout increased from 120s to 600s. The official binary cancels responses before the model finishes generating on slow hardware.

Build it on your Mac:

```bash
git clone --depth=1 https://github.com/sipeed/picoclaw.git
cd picoclaw
sed -i '' 's/const DefaultRequestTimeout = 120 \* time.Second/const DefaultRequestTimeout = 600 * time.Second/' pkg/providers/common/common.go
GOOS=linux GOARCH=arm64 go build -tags "goolm,stdjson" -ldflags "-s -w" -o picoclaw-linux-arm64 ./cmd/picoclaw
scp picoclaw-linux-arm64 orangepi@[your_ip]:/tmp/
ssh orangepi@[your_ip]
sudo cp /tmp/picoclaw-linux-arm64 /usr/local/bin/picoclaw && sudo chmod +x /usr/local/bin/picoclaw
```

On macOS with Ollama, the official binary works fine.

---

## Troubleshooting

**Gateway exits silently after loading**
Check `.security.yml` exists with correct token. Verify `config.json` has `"version": 1` (integer) and `channels.telegram.enabled: true`. Clean corrupt cron store:
```bash
echo '{"version":1,"jobs":[]}' > /opt/yeticlaw/openclaw/workspace/cron/jobs.json
sudo systemctl restart yeticlaw-gateway
```

**Responses timing out (Orange Pi)**
Install the custom binary with 600s timeout — see section above.

**Skill not loading / description too long**
Skill descriptions must be under 1024 characters. Check frontmatter:
```bash
head -4 /opt/yeticlaw/openclaw/workspace/skills/[skill-name]/SKILL.md
```

**llama-server SEGV on startup**
Binary is corrupted. Rebuild from source:
```bash
sudo rm -rf /opt/llama.cpp
sudo git clone --depth=1 https://github.com/ggml-org/llama.cpp /opt/llama.cpp
sudo cmake -B /opt/llama.cpp/build /opt/llama.cpp -DGGML_NATIVE=OFF -DGGML_CPU_ARM_ARCH="armv9-a+sve+i8mm+dotprod" -DGGML_CPU_KLEIDIAI=ON -DCMAKE_BUILD_TYPE=Release
sudo cmake --build /opt/llama.cpp/build --config Release -j$(nproc)
sudo install -m 755 /opt/llama.cpp/build/bin/llama-server /usr/local/bin/
sudo systemctl start llama-server
```

**rclone not syncing**
```bash
rclone ls gdrive:YetiClaw
rclone config reconnect gdrive:
```

---

## Platform Differences

| Feature | Orange Pi 6 Plus | macOS |
|---|---|---|
| Model server | llama.cpp (KleidiAI optimized) | Ollama |
| Speed | ~12 tok/s gen | ~40+ tok/s (M-series) |
| Picoclaw binary | Custom build (600s timeout) | Official release |
| Gateway service | systemd | LaunchAgent or foreground |
| Deploy script | `deploy.sh` (sudo required) | `deploy-mac.sh` (no sudo) |
| Workspace path | `/opt/yeticlaw/openclaw/workspace` | `~/.picoclaw/workspace` |

---

## File Structure

```
yeticlaw-studio/
├── README.md
├── AGENTS.md               ← Quick reference for all slash commands
├── SOUL.md                 ← Workspace routing rules (loaded every message)
├── config.json             ← Picoclaw config
├── deploy.sh               ← Orange Pi deploy script
├── deploy-mac.sh           ← macOS deploy script
└── skills/
    ├── producer/           ← Brief creation + sprint planning
    ├── creative-director/
    ├── technical-director/
    ├── game-designer/
    ├── level-designer/
    ├── systems-designer/
    ├── gameplay-programmer/
    ├── engine-programmer/
    ├── ai-programmer/
    ├── ui-programmer/
    ├── unity-specialist/
    ├── art-director/
    ├── sound-designer/
    ├── technical-artist/
    ├── narrative-director/
    ├── writer/
    ├── world-builder/
    ├── qa-tester/
    ├── threejs-dev/
    ├── ai-consultant/
    ├── email-writer/
    ├── asset-approver/
    ├── meshy/
    ├── game-namer/         ← Atomic: generates game name options
    ├── concept-writer/     ← Atomic: writes 2-sentence concept
    ├── mechanics-designer/ ← Atomic: lists 5 core mechanics
    └── style-writer/       ← Atomic: describes visual style
```

---

## License

MIT — see [LICENSE](./LICENSE)

Skills are compatible with both Picoclaw and OpenClaw SKILL.md format.
