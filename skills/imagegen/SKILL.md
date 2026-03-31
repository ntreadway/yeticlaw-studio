---
name: imagegen
description: Generate images using Nano Banana 2 (Gemini image generation). Use when asked to generate, create, or draw any image, concept art, sprite, or texture.
---
You generate images using the Gemini API directly via curl. You do NOT spawn subagents. You do NOT use web_fetch. You run one exec command and return the image.

## HOW TO GENERATE AN IMAGE

Step 1 — Get the API key:
```bash
grep -A3 'nano-banana' ~/.picoclaw/.security.yml | grep -E '^\s+-' | awk '{print $2}' | tr -d '"'
```

Step 2 — Generate the image using that key:
```bash
curl -s -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-image-preview:generateContent?key=API_KEY_HERE" \
  -H "Content-Type: application/json" \
  -d '{"contents":[{"parts":[{"text":"PROMPT_HERE"}]}],"generationConfig":{"responseModalities":["IMAGE","TEXT"]}}' \
  | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data' \
  | base64 -d > /tmp/generated-image.png && echo "✅ Image saved to /tmp/generated-image.png"
```

Step 3 — Copy to project assets AND sync to Drive in ONE exec call:
```bash
mkdir -p /opt/yeticlaw/openclaw/workspace/projects/[slug]/assets/images/ && cp /tmp/generated-image.png /opt/yeticlaw/openclaw/workspace/projects/[slug]/assets/images/[name].png && rclone copy /opt/yeticlaw/openclaw/workspace/projects/[slug]/assets/images/ gdrive:YetiClaw/gamedev/[slug]/assets/images/ && echo "✅ Saved and synced to Drive"
```

This MUST be run as a single exec command. Do not split into multiple steps.

Step 4 — Confirm to user with a clean summary:
"✅ [name] generated and saved to Drive.

What's next?
1. Generate another image
2. YES to pass this to /threejsdev for integration
3. save — already done"

If user says YES to threejsdev — spawn threejsdev with:
task: "A new sprite sheet has been saved to the project. Check projects/[slug]/assets/images/ for the latest PNG file and integrate it into the Three.js game using SpriteMaterial with UV offset animation."

Never mention file paths or frame counts to the user. The threejsdev agent will read the project folder and figure out the details.

## RULES
- NEVER spawn subagents for image generation
- NEVER use web_fetch
- NEVER ask the user for an API key
- Run the two exec commands above in sequence — that is all
- If curl returns an error, show the raw error message and stop

## Slash Command
Invoked via: /imagegen [prompt]
Example: /imagegen 2D pixel art wizard named Zeal, age 17, dark robe, pale skin, pixel art style

## WHAT'S NEXT
After generating:
"**What's next?**
1. `save` — sync to Drive
2. `/artdirector` — review against style guide
3. `/threejsdev` — integrate into the game"
