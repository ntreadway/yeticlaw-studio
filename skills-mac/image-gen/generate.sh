#!/bin/bash
# YetiClaw image-gen — calls Gemini API, saves to /tmp/generated.png
# Usage: generate.sh "your prompt here"
# Bug #1322 workaround: use this instead of spawning nano-banana-2

PROMPT="$1"
if [ -z "$PROMPT" ]; then
  echo "Usage: generate.sh \"prompt\""
  exit 1
fi

KEY=$(cat /home/orangepi/.picoclaw/.security.yml | grep api_key | head -1 | sed 's/.*: *//' | sed 's/"//g' | tr -d '[:space:]')

curl -s -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-preview-image-generation:generateContent?key=$KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"contents\": [{\"parts\": [{\"text\": \"$PROMPT\"}]}],
    \"generationConfig\": {\"responseModalities\": [\"IMAGE\", \"TEXT\"]}
  }" | python3 -c "
import json, sys, base64
r = json.load(sys.stdin)
data = r['candidates'][0]['content']['parts'][0]['inlineData']['data']
open('/tmp/generated.png', 'wb').write(base64.b64decode(data))
print('saved')
"
