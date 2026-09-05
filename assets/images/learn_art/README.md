# Learn "storybook" card art (v2 — 2026-08-28)

27 WebP scenes for the calm-navigation redesign, in the approved Option A
"storybook" style: soft gradient skies, calm silhouettes, warm ivory light,
gold accents. No faces, no figures, no text baked into artwork (the single
letterforms in `kids_arabic` are pictorial subjects, not copy).

v2 changes over v1:
- **Palette consolidated to 5 sky recipes** anchored to the app's theme tokens
  (`lib/core/theme/app_backgrounds.dart`): Dawn Amber, Day Sky, Night Indigo
  (the app's night background trio `#232A44/#1A1F33/#121423`), Masjid Emerald,
  and Layali Violet (night / lift / dusk variants).
- **Scrim-safe composition**: heroes centered near the 40–45% line, calm
  bottom band, shared ~80% horizon so card rows align.
- **De-duplicated heroes**: door is now exclusive to `level_new_to_islam`
  (`path_foundations` became a five-arch dawn colonnade), the kite is
  kids-only (`island_games` became octagram puzzle tiles), the rehal appears
  once per audience with distinct framing.
- **New legible heroes** for `kids_arabic` (floating letterforms), `kids_duas`
  (misbaha on the windowsill, light rising), `kids_story_library` (storybook
  stack + ribbon), `kids_fun_learning` (play blocks + ball),
  `level_deepening_knowledge` (book + qalam + inkwell), `level_refinement`
  (pearl on the moonlit shore).
- **Levels read as one journey**: threshold door → lantern-lit road → night of
  study → moonlit shore with the pearl.
- **Kids set day-lit and softer**, with the approved potted-bloom character
  reused as a cameo (`path_kids_starter`, `kids_quran`, `kids_hadith`).
- Two-layer glows (bright core + faint halo) instead of single haze; fewer,
  brighter stars.

- Master format: 1600×1200 (4:3), WebP q78, every file 10–20 KB
  (well inside the 40–120 KB budget from
  `docs/quran_summary_top_10_surah_background_art_prompts_2026-03-31.md`).
- Cards render these with the prophet-card pattern: 4:3 header, three-stop
  dark scrim, light title text — readable on day and night themes alike.

## Sets

| Prefix | Count | Intended surface |
|---|---|---|
| `island_*` | 6 | Adult Learn topic groups (Foundations, Qur'an, Worship, Character, Stories, Games) |
| `path_*` | 7 | Guided learning paths (incl. `path_kids_starter`) |
| `level_*` | 4 | Leveled learning paths (New to Islam, Building Consistency, Deepening Knowledge, Refinement) |
| `kids_*` | 10 | Kids Learning subcategories |

## Regenerating / editing

Source of truth is the parametric generator (not the WebPs):
`tooling/art_src/learn_art/generate_art.mjs` (+ emitted SVG masters in
`tooling/art_src/learn_art/svg/`). To regenerate:

```
node tooling/art_src/learn_art/generate_art.mjs   # emits svg/ next to the script
rsvg-convert -w 1600 -h 1200 <name>.svg -o <name>.png
cwebp -q 78 <name>.png -o <name>.webp
```

## Not yet wired

`pubspec.yaml` does NOT declare this folder yet — wiring happens in the
calm-navigation build phase (remember: pubspec asset entries are
non-recursive, so `assets/images/learn_art/` needs its own line).
