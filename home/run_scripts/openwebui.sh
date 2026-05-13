#!/usr/bin/env bash

source openwebui_secr.env

OLLAMA="http://100.85.174.11:11434"
IMAGE="ghcr.io/open-webui/open-webui:main"
PORT=3000

# Stop existing if running
docker stop openwebui 2>/dev/null
docker rm openwebui 2>/dev/null

docker run -d \
    -p $PORT:8080 \
    -v open-webui:/app/backend/data \
    -e OLLAMA_BASE_URL=$OLLAMA \
    -e HF_TOKEN=$HF_TOKEN \
    --name openwebui \
    $IMAGE

echo "Open WebUI starting at http://localhost:$PORT"
echo "Run 'docker logs -f openwebui' to watch boot"
