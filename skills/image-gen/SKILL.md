---
name: image-gen
description: Generate images using Gemini. Use for concept art, icons, sprites, textures, backgrounds, character art.
---

NEVER use web_search, web_fetch, spawn, or subagent to generate images.
Bug #1322: spawn with agent_id ignores target model — always use generate.sh directly.

## HOW TO GENERATE

1. Resolve the project slug first:
```bash
ls /opt/yeticlaw/openclaw/workspace/projects/
```

2. Run generate.sh with the image prompt:
```bash
/opt/yeticlaw/openclaw/workspace/skills/image-gen/generate.sh "YOUR PROMPT HERE"
```

3. send_file: /tmp/generated.png

4. Send EXACTLY this message (mandatory — do not skip):
"Save as `FILENAME.png` to game assets? Reply YES to save or NO to discard."
Replace FILENAME.png with the correct asset filename.

5. WAIT for user reply. Do nothing else.

6. If YES:
```bash
cp /tmp/generated.png /opt/yeticlaw/openclaw/workspace/projects/[slug]/assets/images/FILENAME.png && echo "saved"
```

7. Confirm: "✅ Saved FILENAME.png — ready for next image?"

8. If NO: ask if they want to regenerate.

DO NOT spawn anything after send_file.

## Slash Command
/image-gen [description]
