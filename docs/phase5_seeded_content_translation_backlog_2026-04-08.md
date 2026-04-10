# Phase 5 Seeded Content Translation Backlog

Date: 2026-04-08

## Completed in this pass

- Replaced English fallback values for a seeded-content slice that is already routed through the localization system:
  - Ocean reflections
  - Ocean community stage titles and descriptions
  - Ocean personal stage titles and descriptions
  - Bundled adhan option titles and subtitles
- Confirmed the targeted keyset has `0` same-as-English values across:
  - `ar`
  - `de`
  - `fa`
  - `hi`
  - `ur`
  - `bn`
  - `id`
  - `ms`
  - `tr`
  - `tg`
  - `pa`
  - `ps`
  - `ha`
  - `ku`

## Remaining Phase 5 priorities

- Seeded learning content still needs phased translation and QA in:
  - Qur'an explanation/enrichment datasets
  - Prophets seeded lesson content
  - Hadith foundation and path packs
  - Dua seed collections
  - Journey seeded growth/reflection content
  - Kids bedtime and story packs
- Prioritize data sources that already render through shared localization seams before attempting raw longform dataset migration.

## Multilingual QA follow-up

- Spot-check Ocean community and Adhan settings on-device in at least:
  - Arabic
  - Urdu
  - Turkish
  - Indonesian
- Confirm layout holds for longer translated stage descriptions and subtitle lines.
- Verify no clipped text in Settings Adhan picker or Ocean ladder cards.

## Enhancement Options

- Add a seeded-content QA script that checks selected content packs for same-as-English fallback by locale.
- Add route-level screenshots for Ocean and Settings in 3-4 priority locales to catch overflow earlier.
- Move the next seeded pack onto a dedicated localized metadata layer before translating its longform entries.
