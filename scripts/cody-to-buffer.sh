#!/bin/bash

PROMPT=$(cat -)
TMP_FILE=$(mktemp /tmp/cody_response.XXXXXX)

curl -s http://localhost:11434/api/generate -d "{
  \"model\": \"deepseek-coder\",
  \"prompt\": \"$PROMPT\",
  \"stream\": false
}" | jq -r .response > "$TMP_FILE"

echo "$TMP_FILE"
