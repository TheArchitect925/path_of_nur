#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

APP_CONFIG="ios/Flutter/AppConfig.xcconfig"
PBXPROJ="ios/Runner.xcodeproj/project.pbxproj"

base_bundle_id="$(sed -n 's/^APP_BUNDLE_ID_BASE = //p' "$APP_CONFIG" | head -n1 | tr -d '[:space:]')"
team_id="$(sed -n 's/^APPLE_DEVELOPMENT_TEAM = //p' "$APP_CONFIG" | head -n1 | tr -d '[:space:]')"

if [[ -z "$base_bundle_id" || -z "$team_id" ]]; then
  echo "Missing APP_BUNDLE_ID_BASE or APPLE_DEVELOPMENT_TEAM in $APP_CONFIG" >&2
  exit 1
fi

if rg -n 'YOURTEAMID|com\.company\.|APPLE_DEVELOPMENT_TEAM = ""' "$PBXPROJ" "$APP_CONFIG" >/dev/null; then
  echo "Found placeholder signing or bundle settings" >&2
  exit 1
fi

if rg -n 'DEVELOPMENT_TEAM = [0-9A-Z]+;' "$PBXPROJ" | rg -v "DEVELOPMENT_TEAM = ${team_id};" >/dev/null; then
  echo "Found hardcoded DEVELOPMENT_TEAM value that does not match $team_id" >&2
  exit 1
fi

if rg -n 'APPLE_DEVELOPMENT_TEAM = [0-9A-Z]+;' "$PBXPROJ" "$APP_CONFIG" | rg -v "APPLE_DEVELOPMENT_TEAM = ${team_id};|APPLE_DEVELOPMENT_TEAM = ${team_id}$" >/dev/null; then
  echo "Found APPLE_DEVELOPMENT_TEAM value that does not match $team_id" >&2
  exit 1
fi

runner_settings="$(xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -showBuildSettings 2>/dev/null)"
watch_settings="$(xcodebuild -project ios/Runner.xcodeproj -target "PathOfNurWatch Watch App" -configuration Release -showBuildSettings 2>/dev/null)"

runner_bundle_id="$(printf '%s\n' "$runner_settings" | sed -n 's/^[[:space:]]*PRODUCT_BUNDLE_IDENTIFIER = //p' | head -n1 | tr -d '[:space:]')"
runner_team_id="$(printf '%s\n' "$runner_settings" | sed -n 's/^[[:space:]]*DEVELOPMENT_TEAM = //p' | head -n1 | tr -d '[:space:]')"
if [[ -z "$runner_team_id" ]]; then
  runner_team_id="$(printf '%s\n' "$runner_settings" | sed -n 's/^[[:space:]]*APPLE_DEVELOPMENT_TEAM = //p' | head -n1 | tr -d '[:space:]')"
fi
watch_bundle_id="$(printf '%s\n' "$watch_settings" | sed -n 's/^[[:space:]]*PRODUCT_BUNDLE_IDENTIFIER = //p' | head -n1 | tr -d '[:space:]')"
watch_companion_id="$(printf '%s\n' "$watch_settings" | sed -n 's/^[[:space:]]*WK_COMPANION_APP_BUNDLE_IDENTIFIER = //p' | head -n1 | tr -d '[:space:]')"

expected_watch_app_id="${base_bundle_id}.watchkitapp"

if [[ "$runner_bundle_id" != "$base_bundle_id" ]]; then
  echo "Runner bundle identifier mismatch: expected $base_bundle_id, got $runner_bundle_id" >&2
  exit 1
fi

if [[ "$watch_bundle_id" != "$expected_watch_app_id" ]]; then
  echo "Watch app bundle identifier mismatch: expected $expected_watch_app_id, got $watch_bundle_id" >&2
  exit 1
fi

if [[ "$watch_companion_id" != "$base_bundle_id" ]]; then
  echo "Watch companion app bundle identifier mismatch: expected $base_bundle_id, got $watch_companion_id" >&2
  exit 1
fi

if [[ "$runner_team_id" != "$team_id" ]]; then
  echo "Runner development team mismatch" >&2
  exit 1
fi

if ! rg -F "\"PRODUCT_BUNDLE_IDENTIFIER[sdk=watchos*]\" = \"\$(APP_WATCH_APP_BUNDLE_ID)\";" "$PBXPROJ" >/dev/null; then
  echo 'Expected watch app watchOS override to use $(APP_WATCH_APP_BUNDLE_ID)' >&2
  exit 1
fi

# The watch runs a single-target watchOS layout, so there is no WatchKit
# extension to pin any more; the one remaining extension is the complications
# widget, whose id hangs off the watch app's.
if ! rg -F "\"PRODUCT_BUNDLE_IDENTIFIER[sdk=watchos*]\" = \"\$(APP_WATCH_APP_BUNDLE_ID).complications\";" "$PBXPROJ" >/dev/null; then
  echo 'Expected complications watchOS override to use $(APP_WATCH_APP_BUNDLE_ID).complications' >&2
  exit 1
fi

# Every source file the project builds must actually be in the repo. A stray
# pbxproj commit once declared four Swift files that were only ever in a
# working tree, and the watch target stopped building for everyone else.
missing_sources="$(python3 - "$PBXPROJ" <<'PYEOF'
import os, re, sys

pbxproj = sys.argv[1]
project_dir = os.path.dirname(os.path.dirname(pbxproj))
with open(pbxproj, encoding="utf-8") as handle:
    contents = handle.read()

referenced = {
    path for _, path in re.findall(r'path = ("?)([^";]+\.swift)\1;', contents)
}
on_disk = {
    name
    for _, _, files in os.walk(project_dir)
    for name in files
    if name.endswith(".swift")
}
for path in sorted(referenced):
    if os.path.basename(path) not in on_disk:
        print(path)
PYEOF
)"

if [[ -n "$missing_sources" ]]; then
  echo "Project file references sources that are not in the repo:" >&2
  echo "$missing_sources" | sed 's/^/  /' >&2
  exit 1
fi

# App Store validation rejects any shipping bundle whose Info.plist has no
# CFBundleDisplayName. Build 51 was refused at upload with a 409 for exactly
# this on the complications widget, so catch it here rather than at Apple.
missing_display_names=""
while IFS= read -r plist; do
  [[ -f "$plist" ]] || continue
  if ! /usr/bin/plutil -extract CFBundleDisplayName raw "$plist" >/dev/null 2>&1; then
    missing_display_names+="  $plist"$'\n'
  fi
done <<'PLISTS'
ios/Runner/Info.plist
ios/PathOfNurWatch Watch App/Info.plist
ios/PathOfNurWatchComplications/Info.plist
ios/PathOfNurHomeWidgets/Info.plist
ios/PrayerLiveActivityExtension/Info.plist
ios/PathOfNurTV/Info.plist
PLISTS

if [[ -n "$missing_display_names" ]]; then
  echo "Bundles missing CFBundleDisplayName (App Store upload will fail):" >&2
  printf '%s' "$missing_display_names" >&2
  exit 1
fi

# Font resources must resolve to a file that is actually there. The Apple TV
# target once pointed its Fonts group at ios/PathOfNurTV/Fonts, a directory
# that never existed, and failed on seven missing .ttf files. A basename check
# would not have caught it — the files existed, just not where the group said —
# so resolve each reference through its parent groups to a real path.
missing_resources="$(python3 - "$PBXPROJ" <<'PYEOF'
import json, os, subprocess, sys

pbxproj = sys.argv[1]
project_dir = os.path.dirname(os.path.dirname(pbxproj))  # ios/
raw = subprocess.run(["plutil", "-convert", "json", "-o", "-", pbxproj],
                     capture_output=True, check=True).stdout
objs = json.loads(raw)["objects"]

parent = {}
for key, obj in objs.items():
    if obj.get("isa") in ("PBXGroup", "PBXVariantGroup"):
        for child in obj.get("children", []):
            parent[child] = key

def resolve(key):
    """Directory path for a node, honouring sourceTree at each hop."""
    obj = objs[key]
    tree = obj.get("sourceTree")
    path = obj.get("path", "")
    if tree == "SOURCE_ROOT":
        base = project_dir
    elif tree == "<absolute>":
        return path
    elif key in parent:
        base = resolve(parent[key])
    else:
        base = project_dir
    return os.path.normpath(os.path.join(base, path)) if path else base

for key, obj in objs.items():
    if obj.get("isa") != "PBXFileReference":
        continue
    path = obj.get("path", "")
    if not path.endswith(".ttf"):
        continue
    base = resolve(parent[key]) if key in parent else project_dir
    resolved = os.path.normpath(os.path.join(base, path))
    if not os.path.isfile(resolved):
        print(f"{path} -> {resolved}")
PYEOF
)"

if [[ -n "$missing_resources" ]]; then
  echo "Project file references fonts that do not resolve to a file on disk:" >&2
  echo "$missing_resources" | sed 's/^/  /' >&2
  exit 1
fi

echo "Apple bundle/signing consistency check passed"
