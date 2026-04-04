---
name: threejs-dev
description: Three.js game builder for YetiClaw Pi. Generates a game-config.json that plugs into a pre-built engine template. Selects the best matching template for the game genre, or builds a minimal custom one if no template fits. Use for any /threejsdev task.
---

## You Are On Constrained Hardware
- 4B model, ~11 tok/s, 600s timeout (~6,600 tokens max output)
- You CANNOT write complete game files. Do not try.
- You generate ONLY a `game-config.json` (~100-200 lines of JSON)
- A pre-built HTML template handles all engine code

## How It Works
1. Read the game brief
2. Pick the best template (or the generic one if nothing fits)
3. Copy the template to the project folder
4. Generate a `game-config.json` matching that template's schema
5. Save it. Done. One shot, no "continue", no chunking.

## Workflow

**Step 1: Read the brief**
```bash
cat /opt/yeticlaw/openclaw/workspace/projects/[slug]/brief.md
```

**Step 2: Pick a template**
```bash
ls /opt/yeticlaw/openclaw/workspace/skills/threejs-dev/templates/
```
Each template has a `SCHEMA.md` next to it describing what config it expects.
Read the schema for your chosen template:
```bash
cat /opt/yeticlaw/openclaw/workspace/skills/threejs-dev/templates/[name]/SCHEMA.md
```

Template selection guide:
- Match on core mechanic, not theme or story
- Brewing/mixing/crafting → `alchemy`
- Side-scrolling movement → `platformer`
- Cards/deck/hand/turns → `cardgame`
- Grid/tiles/matching → `puzzle`
- Click/tap enemies, waves → `clicker-defense`
- Narrative choices, branching → `visual-novel`
- Nothing fits → `generic`

The `generic` template provides: scene, camera, sprite rendering, input handling,
game loop, HUD, modal system, particle effects, procedural audio, save/load.
Its config defines: entities, interactions, win/lose conditions, UI labels, colors.

If the user's game truly can't work with any template, say so:
"This game needs a custom template. I can write the config schema for it —
then use `/skillcreator` to build the template, or wait for Mac deployment."

**Step 3: Copy template to project**
```bash
mkdir -p /opt/yeticlaw/openclaw/workspace/projects/[slug]/html
cp /opt/yeticlaw/openclaw/workspace/skills/threejs-dev/templates/[name]/index.html \
   /opt/yeticlaw/openclaw/workspace/projects/[slug]/html/index.html
```

**Step 4: Generate game-config.json**
Read the SCHEMA.md for the selected template. Output ONLY valid JSON.
No markdown fences. No explanation. No preamble. Just the JSON object.

**Step 5: Save**
```bash
cat > /opt/yeticlaw/openclaw/workspace/projects/[slug]/html/game-config.json << 'CONFIGEOF'
[your generated JSON here]
CONFIGEOF
```

**Step 6: Confirm**
```
✅ Game ready. Open index.html in a browser to play.
Template: [name]
Config: game-config.json

To sync: rclone copy /opt/yeticlaw/openclaw/workspace/projects/[slug]/html gdrive:YetiClaw/gamedev/[slug]/html
```

## Config Generation Rules (all templates)
- Output ONLY valid JSON — no markdown, no backticks, no prose
- All string values must be properly escaped
- All colors as 6-digit hex with # prefix
- Emoji icons as single emoji characters
- Keep descriptions to 1-2 sentences max
- IDs as snake_case, unique within their array
- Reference IDs must match defined IDs (recipes reference ingredient IDs, etc.)

## Asset Pipeline
You coordinate with other agents for art. Never call APIs directly.
- 2D assets: write Image Asset Brief → `/artdirector` → `/assetapprover`
- 3D assets: write 3D Asset Brief → `/artdirector` → `/assetapprover`

Asset discovery (never ask user for paths):
```bash
ls /opt/yeticlaw/openclaw/workspace/projects/[slug]/assets/images/
```

## What's Next
After delivering, always end with:

"**What's next?**
1. `/artdirector` — concept art for the visual style
2. `/assetapprover` — estimate asset generation costs
3. `/gamedesigner` — refine game mechanics
4. `/sounddesigner` — design audio identity
5. `save` — sync all files to Drive"

## Slash Command
`/threejsdev [task]`
Example: `/threejsdev build Zeal's Dark Alchemy`
