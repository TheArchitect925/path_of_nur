# Qur'an Summary Top 10 Surah Background Art Prompts

Date: 2026-03-31

## Delivery state

- Final `.webp` binaries were not generated in-environment.
- Reason: live image generation is unavailable in this session because `OPENAI_API_KEY` is not set.
- The app-side pipeline, registry, prompts, and fallback integration are prepared for asset drop-in.

## Asset target

- Folder: `assets/images/quran/surah_summary_backgrounds/`
- Filenames:
  - `001.webp`
  - `002.webp`
  - `003.webp`
  - `004.webp`
  - `005.webp`
  - `006.webp`
  - `007.webp`
  - `008.webp`
  - `009.webp`
  - `010.webp`

## Suggested generation spec

- Style: soft watercolor, parchment, mist, calm spiritual atmosphere
- No faces, people, prophets, text, UI, or literal religious depictions
- Prefer abstraction and symbolic atmosphere
- Recommended output aspect: landscape, close to card-friendly 4:3 or 3:2
- Recommended master export: around 1600px wide
- Recommended app optimization pass:
  - convert to `.webp`
  - target quality around `72–80`
  - keep typical file sizes in the rough `40–120 KB` range if visual quality holds

## Top 10 prompts

1. `001.webp` — Al-Fatiha — Opening Light
   Prompt:
   `Soft watercolor abstract spiritual opening, first light through mist, subtle path of guidance, mercy and welcome, calm warm neutrals, gentle gold glow, parchment softness, minimal, elegant, atmospheric depth, no humans, no animals, no text, no symbols, no UI.`

2. `002.webp` — Al-Baqarah — Grounded Vastness
   Prompt:
   `Soft watercolor abstract grounded landscape, vast earth tones, expansive horizon, foundation, law, protection, subtle divine light over textured earth, restrained gold warmth, calm and weighty atmosphere, minimal, elegant, no humans, no animals, no text, no literal objects.`

3. `003.webp` — Aal-E-Imran — Uplifted Trust
   Prompt:
   `Soft watercolor spiritual sky, uplifting light through layered clouds, faith under trial, divine help, trust, blue gray and warm gold tones, gentle upward movement, calm reflective atmosphere, minimal, elegant, no humans, no animals, no text.`

4. `004.webp` — An-Nisa — Balanced Dignity
   Prompt:
   `Soft watercolor abstract symmetry, justice, balance, dignity, order, gentle strength, refined warm neutrals with subtle bronze lines, calm structural rhythm, restrained sacred atmosphere, minimal, elegant, no humans, no animals, no text.`

5. `005.webp` — Al-Ma’idah — Provision And Covenant
   Prompt:
   `Soft watercolor symbolic provision and covenant, nourishment and gratitude suggested through layered circular and table-like forms without literal objects, gentle golden light, calm cream and stone tones, minimal, elegant, no humans, no animals, no text.`

6. `006.webp` — Al-An’am — Signs Of Creation
   Prompt:
   `Soft watercolor signs of creation, layered sky and earth, reflective atmosphere, divine order, subtle transitions between land and heavens, calm natural tones with restrained light, minimal, elegant, no humans, no animals, no text.`

7. `007.webp` — Al-A’raf — Threshold Horizons
   Prompt:
   `Soft watercolor elevated horizon, thresholds and heights, separation, warning and hope, atmospheric distance, layered ridgelines, soft light through mist, calm editorial composition, minimal, elegant, no humans, no animals, no text.`

8. `008.webp` — Al-Anfal — Resolved Reliance
   Prompt:
   `Soft watercolor atmosphere of resolve and supported struggle, quiet strength, directional light, restrained earth and bronze tones, calm intensity, subtle sense of forward reliance without battle imagery, minimal, elegant, no humans, no animals, no text.`

9. `009.webp` — At-Tawbah — Moral Clarity
   Prompt:
   `Soft watercolor moral clarity, truth cutting through haze, subtle separation of shadow and light, sincerity, repentance, return, minimal layered forms, warm neutrals with firm gold light, elegant, no humans, no animals, no text.`

10. `010.webp` — Yunus — Calm Return
    Prompt:
    `Soft watercolor calm journey atmosphere, patience and trust after distress, subtle horizon and sea-inspired tranquility used abstractly, gentle light after heaviness, muted blue gray and warm sand tones, minimal, elegant, no humans, no animals, no text.`

## Activation step after assets are added

Update `kQuranSurahSummaryBackgroundReadyNumbers` in:

- `lib/features/learn/quran/data/quran_surah_summary_background_registry.dart`

Add the ready surah numbers there once the corresponding `.webp` files exist.
