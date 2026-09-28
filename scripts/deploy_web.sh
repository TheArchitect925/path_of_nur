#!/usr/bin/env bash
# Builds the web app and deploys it to mcsnow.ca/pathofnur/ (Cloudflare Worker
# `pathofnur-web`, config in web_deploy/). Needs `npx wrangler login` once.
#   scripts/deploy_web.sh            build, stage, deploy
#   scripts/deploy_web.sh --dry-run  build and stage only
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

FLUTTER="${FLUTTER:-flutter}"
BASE="/pathofnur/"
STAGE="build/web_deploy"
OUT="$STAGE${BASE%/}"

"$FLUTTER" build web --release --base-href "$BASE"

rm -rf "$STAGE"
mkdir -p "$OUT"
cp -R build/web/. "$OUT/"
cp web_deploy/_headers "$STAGE/_headers"

# main.dart.js is over the 25 MiB asset limit; worker.js serves these instead.
brotli --quality=11 --force --output="$OUT/main.dart.js.br" "$OUT/main.dart.js"
gzip -9 --keep --force "$OUT/main.dart.js"
rm "$OUT/main.dart.js"

too_big="$(find "$STAGE" -type f -size +25M)"
if [[ -n "$too_big" ]]; then
  echo "Over the 25 MiB asset limit:" >&2
  echo "$too_big" >&2
  exit 1
fi
echo "Staged $(find "$STAGE" -type f | wc -l | tr -d ' ') files ($(du -sh "$STAGE" | cut -f1)) in $STAGE"

if [[ "${1:-}" == "--dry-run" ]]; then
  exit 0
fi
npx -y wrangler@4 deploy -c web_deploy/wrangler.jsonc
