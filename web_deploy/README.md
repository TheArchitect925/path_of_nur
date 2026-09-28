# Web build at mcsnow.ca/pathofnur

The Flutter web build is served from `https://mcsnow.ca/pathofnur/` by its own
Cloudflare Worker, `pathofnur-web`. Its route, `mcsnow.ca/pathofnur*`, is more
specific than the MCSnow site's `mcsnow.ca/*`, so the MCSnow site never changes
when this deploys (METEOR's `/meteor*` works the same way).

```
scripts/deploy_web.sh            # build, stage build/web_deploy/, deploy
scripts/deploy_web.sh --dry-run  # build and stage only
FLUTTER=~/development/flutter/bin/flutter scripts/deploy_web.sh
```

Needs `brotli` (Homebrew) and a Cloudflare login for Wrangler (`npx wrangler login`).

## What is different on the web

- **SQLite** runs as WebAssembly (`web/sqlite3.wasm`, from the sqlite3.dart
  release `sqlite3-2.9.4`; replace it when `package:sqlite3` moves) and keeps its
  file in IndexedDB. See `lib/shared/persistence/sqlite_opener*.dart`.
- **Qur'an audio** streams from everyayah.com; there are no downloads, and no
  lock-screen controls (`just_audio_background` is skipped).
- **Wide windows** show the app at phone width, centred (`WebPhoneFrame`).
- Notifications, widgets, Live Activities, the watch and camera features are
  phone-only and stay quiet.

## Serving

`main.dart.js` is about 70 MB, over the 25 MiB per-file limit for Worker
assets, so the deploy uploads only its Brotli and gzip copies and `worker.js`
serves whichever the browser accepts. Everything else is a plain static asset.
`_headers` sends `X-Robots-Tag: noindex` while the web app is a trial; remove it
(and the header in `worker.js`) to let search engines list it.
