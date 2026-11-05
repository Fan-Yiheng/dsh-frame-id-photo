#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

PROFILE="${DSH_PROFILE_DIR:-$HOME/.dsh/profiles/desktop}"
PLUGIN="$PWD/dsh-plugin"

if [[ ! -f "$PLUGIN/package.json" || ! -f "$PLUGIN/client.js" ]]; then
  echo "dsh-plugin/client.js not found. Run: node build-dsh-plugin.mjs" >&2
  exit 1
fi

if [[ ! -f "$PROFILE/package.json" ]]; then
  echo "DSH profile not found: $PROFILE" >&2
  exit 1
fi

mkdir -p "$PROFILE/node_modules/@local"
rm -rf "$PROFILE/node_modules/@local/frame-photo-studio"
cp -R "$PLUGIN" "$PROFILE/node_modules/@local/frame-photo-studio"

python3 - "$PROFILE/package.json" "$PLUGIN" <<'PY'
import json, os, sys
profile_pkg, plugin_dir = sys.argv[1], sys.argv[2]
with open(profile_pkg) as f:
    data = json.load(f)
data.setdefault("dependencies", {})["@local/frame-photo-studio"] = "file:" + plugin_dir
bundles = data.setdefault("dsh", {}).setdefault("profile", {}).setdefault("bundles", [])
if "@local/frame-photo-studio" not in bundles:
    bundles.append("@local/frame-photo-studio")
with open(profile_pkg, "w") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
    f.write("\n")
print("Registered @local/frame-photo-studio in", profile_pkg)
PY

echo "Installed. Refresh Harness (or restart it if the sidebar does not update)."
