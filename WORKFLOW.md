# Working With Your Agents — Game Project Workflow

How to give agents context about your game and coordinate them across a project.

---

## Three Ways to Brief an Agent

### Option 1 — Inline (quickest, one-off tasks)

Just describe the game as part of the command. The agent will ask clarifying questions before doing anything.

```
/gamedesigner design a stamina system for a 2D roguelike dungeon crawler with sword combat
```
```
/creativedirector the game is a noir detective puzzle game set in 1940s LA, review the core tone
```
```
/leveldesigner design the opening level for a 3D platformer where the player learns the grapple hook
```
```
/threejsdev build a first-person maze game with collectibles for VIVERSE — sci-fi tone, neon aesthetic
```

---

### Option 2 — Project Brief (recommended for real projects)

Set up a brief once. All agents reference it by project name from then on.

**Step 1 — Create the brief:**
```
/producer set up a new project brief for: [game name], [genre], [platform], [engine], [core mechanic], [tone]
```

Example:
```
/producer set up a new project brief for: Project Ember, third-person action RPG,
PC/Steam, Unity, stamina-based melee combat with elemental weapons, dark fantasy tone
```

The producer saves this to Google Drive at:
```
gdrive:YetiClaw/gamedev/project-ember/brief.md
```

**Step 2 — Reference it in any agent:**
```
/gamedesigner using the Project Ember brief, design the stamina system
/leveldesigner using the Project Ember brief, design the opening tutorial level
/writer using the Project Ember brief, write the opening NPC dialogue
/artdirector using the Project Ember brief, write the art brief for the main character
/systemsdesigner using the Project Ember brief, design the elemental weapon upgrade system
```

---

### Option 3 — Paste your notes directly

If you already have ideas written down, paste them straight in:

```
/gamedesigner here's my game concept:

[paste your notes]

Now design the core combat loop.
```

---

## Recommended Flow for a New Project

```
1. /producer          → create and save the project brief
2. /creativedirector  → review and lock the creative pillars
3. /gamedesigner      → design the core loop from the brief
4. /systemsdesigner   → spec out the key systems (economy, progression, etc.)
5. /leveldesigner     → design the first level
6. /narrativedirector → outline the story structure
7. /writer            → draft opening dialogue and UI copy
8. /artdirector       → write art briefs for key assets
9. /gameplayprogrammer → generate Unity C# for the core mechanic
10. /qatester         → write the test plan for the first feature
```

---

## Keeping Agents on Track

Each agent remembers the last 5 messages (`max_history: 5`). For longer projects:

- **Always reference the project name** when switching tasks: `"using the Project Ember brief"`
- **Use /producer** to track what's been decided and what's still open
- **Use /qatester** after any major feature is specced — not just after it's built

---

## Three.js / VIVERSE Projects

For browser games the flow is slightly different — `/threejsdev` orchestrates asset requests:

```
1. /threejsdev        → scaffold the TypeScript project and game loop
2. /artdirector       → approve the visual style
3. /threejsdev        → submit asset briefs for approval
4. /assetapprover     → review cost and approve each asset
5. /threejsdev        → integrate returned assets into the game
6. /qatester          → write the VIVERSE deployment checklist
```

---

## Avatar Clothing Projects

```
1. Send UV map + clothing photo to Gemini (your existing workflow)
2. Copy Gemini's description
   → texture paint spec (region by region)
   → Blender Python bake setup script
   → Meta Horizon upload checklist
```

---

## Quick Reference — All Slash Commands

| Command | What to ask it |
|---|---|
| `/producer` | "set up a brief for [game]" / "plan this week's sprint" / "what's blocked?" |
| `/creativedirector` | "review the tone of [game]" / "are these mechanics consistent with the vision?" |
| `/technicaldirector` | "what architecture should I use for [system]?" |
| `/gamedesigner` | "design [mechanic] for [game]" / "write the GDD for [system]" |
| `/leveldesigner` | "design [level] that teaches [mechanic]" |
| `/systemsdesigner` | "design the [economy/progression/inventory] system" |
| `/gameplayprogrammer` | "implement [mechanic] in Unity C#" |
| `/engineprogrammer` | "design the save system / scene manager / Addressables setup" |
| `/aiprogrammer` | "implement [enemy] behavior tree" |
| `/uiprogrammer` | "build the [HUD/menu/inventory] UI in UI Toolkit" |
| `/unityspecialist` | "why is [Unity thing] broken?" |
| `/artdirector` | "write the art brief for [asset]" |
| `/sounddesigner` | "design the audio system for [game]" |
| `/technicalartist` | "set up the [shader/VFX/render pipeline] for [effect]" |
| `/narrativedirector` | "outline the story for [game]" |
| `/writer` | "write dialogue for [scene/character]" |
| `/worldbuilder` | "define the factions / lore / world rules for [game]" |
| `/qatester` | "write a test plan for [feature]" |
| `/threejsdev` | "build [game concept] for VIVERSE in TypeScript" |
| `/assetapprover` | "[paste asset brief] — approve for generation?" |
| `/meshy` | "generate [3D asset description]" (after /assetapprover approves) |
| `/emailwriter` | "find leads for [service line] in [industry/city]" |
| `/aiconsultant` | "find AI integration leads in [industry]" |

---

*Keep it simple — start with `/producer`, build from there.*
