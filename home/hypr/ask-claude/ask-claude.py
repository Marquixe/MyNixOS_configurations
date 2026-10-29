#!/usr/bin/env python3
import sys, base64, json, urllib.request, os

API_KEY = ""  # os.environ.get("ANTHROPIC_API_KEY", "")
if not API_KEY:
    print("NO API KEY", file=sys.stderr)
    sys.exit(1)

with open(sys.argv[1], "rb") as f:
    img_b64 = base64.b64encode(f.read()).decode()

payload = {
    "model": "claude-sonnet-4-20250514",
    "max_tokens": 5,
    "messages": [
        {
            "role": "user",
            "content": [
                {
                    "type": "image",
                    "source": {
                        "type": "base64",
                        "media_type": "image/png",
                        "data": img_b64,
                    },
                },
                {
                    "type": "text",
                    "text": "This is a multiple choice question. Reply with ONLY one letter: a, b, c, or d.",
                },
            ],
        }
    ],
}

req = urllib.request.Request(
    "https://api.anthropic.com/v1/messages",
    data=json.dumps(payload).encode(),
    headers={
        "Content-Type": "application/json",
        "x-api-key": API_KEY,
        "anthropic-version": "2023-06-01",
    },
)

with urllib.request.urlopen(req) as res:
    data = json.loads(res.read())
    answer = data["content"][0]["text"].strip().lower()
    print(answer)
    # поки що просто виводимо — overlay додамо пізніше
