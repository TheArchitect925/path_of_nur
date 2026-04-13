# Runtime Icon WebP Migration Backlog

Date: 2026-04-13
Status: Completed for verified live-runtime subset

## Selected First Batch

- `assets/icons/home_lantern_cropped.png`
- `assets/icons/learn_quran_cropped.png`
- `assets/icons/brotherlogo.PNG`
- `assets/icons/sisterlogo.png`

## Why This Subset

- These are the only `assets/icons/` PNGs with verified live runtime owners in the current repo.
- They are isolated enough to migrate without touching launcher icon config.
- This keeps the pass reviewable and avoids turning a mixed icon folder into a blind bulk conversion.

## Deferred For Later

- `assets/icons/app_iconv2.png`
- `assets/icons/app_icondarkv2.png`
- remaining unused icon PNGs such as `creative_palette`, `journey_tree_cropped`, `knowledge_globe`, `map_location`, `notification_bell`, `quran_moon`, `secure_lock`, `worship_hands_cropped`

## Next Follow-Up Options

1. After this batch, audit whether the remaining unused icon PNGs should be converted proactively or left until they gain live runtime ownership.
2. Run a separate launcher/app-icon strategy pass if product wants WebP-friendly app-owned alternates while preserving native packaging requirements.

## Completed Result

- Converted `home_lantern_cropped`, `learn_quran_cropped`, `brotherlogo`, and `sisterlogo` to sibling WebPs.
- Migrated the live runtime owners and focused tests to the new `.webp` paths.
- Tightened the runtime PNG allowlist from a broad `assets/icons/` prefix to explicit remaining PNG exceptions only.
- Archived and deleted the four verified legacy PNGs after policy validation.
