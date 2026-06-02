#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV="$SCRIPT_DIR/.venv"
KEYMAP="$SCRIPT_DIR/config/boards/shields/dactyl_manuform_4x5/dactyl_manuform_4x5.keymap"
DTSI="$SCRIPT_DIR/config/boards/shields/dactyl_manuform_4x5/dactyl_manuform_4x5.dtsi"
KEYMAP_YAML="$SCRIPT_DIR/keymap.yaml"
OUTPUT_SVG="$SCRIPT_DIR/keymap.svg"

if [[ ! -d "$VENV" ]]; then
    echo "Creating venv..."
    python3 -m venv "$VENV"
    "$VENV/bin/pip" install keymap-drawer -q
fi

echo "Parsing keymap..."
"$VENV/bin/keymap" parse -z "$KEYMAP" > "$KEYMAP_YAML"

echo "Injecting physical layout..."
python3 - "$KEYMAP_YAML" "$DTSI" <<'PYEOF'
import sys
import re

yaml_path = sys.argv[1]
dtsi_path = sys.argv[2]

with open(yaml_path) as f:
    content = f.read()

layout_block = f"""layout:
  dts_layout: {dtsi_path}
  layout_name: physical_layout
"""

# Remove any existing layout: block if present, then prepend
content = re.sub(r'^layout:.*?(?=^\S|\Z)', '', content, flags=re.MULTILINE | re.DOTALL)
content = layout_block + content

with open(yaml_path, 'w') as f:
    f.write(content)
PYEOF

CONFIG="$SCRIPT_DIR/keymap_drawer.config.yaml"

echo "Drawing SVG..."
"$VENV/bin/keymap" -c "$CONFIG" draw "$KEYMAP_YAML" > "$OUTPUT_SVG"
echo "Generated: $OUTPUT_SVG"
