# YetiClaw Studio Agents
Qwen3.5 4B · llama.cpp · Orange Pi 6 Plus · Picoclaw gateway

---

## How to Use
Type a slash command in Telegram followed by your task.
Example: `/gamedesigner design a stamina system for combat`

---

## 🎬 Directors
| Command | Role |
|---|---|
| `/creativedirector` | Creative vision, tone, aesthetic, MDA review |
| `/technicaldirector` | Unity architecture decisions, coding standards (code-gen) |
| `/producer` | Sprint planning, milestone tracking, blocker management |

## 🎮 Design
| Command | Role |
|---|---|
| `/gamedesigner` | Mechanics, GDDs, MDA analysis, Bartle player types |
| `/leveldesigner` | Level layouts, flow, pacing, encounter design |
| `/systemsdesigner` | Economy, progression, data-driven system specs |

## 💻 Programming (code-gen — no direct Unity Editor access)
| Command | Role |
|---|---|
| `/gameplayprogrammer` | Unity C# player mechanics, movement, combat |
| `/engineprogrammer` | Unity C# core: save systems, scene management, Addressables |
| `/aiprogrammer` | Unity C# enemy AI, behavior trees, NavMesh |
| `/uiprogrammer` | Unity UI Toolkit, HUD, menus, accessibility |
| `/unityspecialist` | Package conflicts, editor scripting, render pipeline |

## 🎨 Art & Audio
| Command | Role |
|---|---|
| `/artdirector` | Style guide, art briefs, asset review specs |
| `/sounddesigner` | Audio identity, FMOD events, adaptive music |
| `/technicalartist` | Shaders, VFX Graph, asset import pipeline (code-gen) |

## 📖 Narrative & QA
| Command | Role |
|---|---|
| `/narrativedirector` | Story structure, character arcs, narrative doc |
| `/writer` | Dialogue, UI copy, item descriptions, voice guide |
| `/worldbuilder` | Lore, factions, geography, world bible |
| `/qatester` | Test plans, bug reports (Critical/High/Medium/Low) |

## 🌐 Web & XR
| Command | Role |
|---|---|
| `/threejsdev` | Three.js games for VIVERSE (WebGL, WebXR, single HTML file) |

## 💼 Business
| Command | Role |
|---|---|
| `/emailwriter` | Outreach for game dev · AI integration · AI app dev |
| `/aiconsultant` | Find AI integration leads, profile companies, pitch angles |

## 👗 Avatar
| Command | Role |
|---|---|

---

## Avatar Clothing Workflow
1. Send UV map + clothing photo to **Gemini**
2. Copy Gemini's description
4. Agent produces: texture paint spec + Blender Python bake script + Meta Horizon upload checklist

## Google Drive Save Paths
| Agent | Drive Path |
|---|---|
| Three.js games | `gdrive:YetiClaw/threejs/` |
| Outreach emails | `gdrive:YetiClaw/outreach/` |
| Game design docs | `gdrive:YetiClaw/gamedev/` |

---

## Notes
- Unity agents are **code-gen only** — Unity Editor runs on a separate x86 machine
- Vision (images) handled by **Gemini** in your existing workflow, not YetiClaw
- `exec` is enabled for `rclone` only — agents cannot run arbitrary shell commands
- Bump `n_predict` in llama-server service if responses are cut off (default 192)

## 💰 Asset Generation (approval required)
| Command | Role |
|---|---|
| `/assetapprover` | Budget gate — review cost + approve/deny before Nano Banana or Meshy fires |
| `/meshy` | Meshy.ai 3D model generation (text-to-3D or image-to-3D) |

---

## Asset Generation Workflow
```
/threejsdev or /artdirector
    → produces Asset Brief
        → /assetapprover [brief]
            → shows cost estimate
                → you reply /approve [name] or /deny [name]
                    → /approve → Nano Banana 2 or /meshy executes
                    → /deny   → placeholder used instead
```

### Nano Banana 2 (images)
- Model: `gemini-3.1-flash-image-preview`
- Gated by: `asset-approver`
- Cost: ~$0.04/image (1K resolution default)

### Meshy (3D models)
- Used by: `threejs-dev`, `art-director` (for game assets)
- Gated by: `asset-approver`
- Cost: ~20 credits per text-to-3D or image-to-3D task
- Output: GLB saved to `gdrive:YetiClaw/meshy-models/`

---

## Setup: API Keys Needed
| Key | Where to get it | Where to set it |
|---|---|---|
| `GEMINI_API_KEY` | aistudio.google.com/apikey | config.json model_list |
| `MESHY_API_KEY` | meshy.ai → API page | /etc/environment on Pi |

```bash
# On the Pi — add Meshy key to environment
echo 'export MESHY_API_KEY="your_key_here"' >> /home/orangepi/.bashrc
source /home/orangepi/.bashrc
```
