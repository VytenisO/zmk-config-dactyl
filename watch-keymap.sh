#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEYMAP="$SCRIPT_DIR/config/boards/shields/dactyl_manuform_4x5/dactyl_manuform_4x5.keymap"

if ! command -v inotifywait &>/dev/null; then
    echo "inotifywait not found — install inotify-tools: pacman -S inotify-tools"
    exit 1
fi

bash "$SCRIPT_DIR/generate-keymap.sh"

echo "Watching $KEYMAP for changes..."
while inotifywait -e close_write "$KEYMAP" 2>/dev/null; do
    echo "Keymap changed, regenerating..."
    bash "$SCRIPT_DIR/generate-keymap.sh"
done
