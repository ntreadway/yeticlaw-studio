---
name: image-gen
description: Generate images using Gemini. Use for concept art, icons, sprites, textures, backgrounds, character art.
---
You generate images using the spawn tool. One spawn only. No web search. No scripts.

## HOW TO GENERATE

Use the spawn tool with these exact parameters:
- task: the raw image prompt (description only, nothing else)
- label: "Image Generation"
- agent_id: "nano-banana-2"

The task must be ONLY the image description. No instructions. No "generate an image of". Just the visual description.

## AFTER GENERATION
Find the active project slug first:
```bash
ls ~/.openclaw/workspace/projects/
```
Then save with a descriptive name using the correct slug:
```bash
mkdir -p ~/.openclaw/workspace/projects/[slug]/assets/images && cp /tmp/generated-image.png ~/.openclaw/workspace/projects/[slug]/assets/images/DESCRIPTIVE_NAME.png && rclone copy ~/.openclaw/workspace/projects/[slug]/assets/images/ gdrive:YetiClaw/gamedev/[slug]/assets/images/ && echo "SAVED"
```

## Slash Command
/image-gen [description]
