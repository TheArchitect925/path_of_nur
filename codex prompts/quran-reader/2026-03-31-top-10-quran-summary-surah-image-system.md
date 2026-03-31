# PHASE 1 PROMPT — TOP 10 QURAN SUMMARY SURAH IMAGE SYSTEM

PRIMARY OBJECTIVE === BUILDING THE TOP 10 QURAN SUMMARY SURAH IMAGE SYSTEM

You are working in the existing Flutter codebase for “Path of Nūr”.

This phase is for the Qur’an Summary experience.

We want to generate and integrate symbolic background artwork for each surah card, similar in spirit to the prophets artwork direction we used before, but tailored to each surah’s meaning and tone.

These images will sit INSIDE the surah name/container card as a subtle visual layer behind the text content.

IMPORTANT:
- Build this production-ready
- Do not use placeholders if the real implementation can be completed now
- Do not break existing card layout, spacing, readability, routing, localization, or performance
- Audit first before changes
- At the very end, do a Codex audit summary so I can review everything cleanly in one pass
- Always ensure the system is not going haywire and removing deleting records for no reason

==================================================
PRODUCT GOAL
==================================================

Create a complete V1 system that:
1. defines a visual identity for each surah in the Quran Summary list
2. starts with the Top 10 surahs as the first rollout
3. stores the generated images as optimized .webp assets
4. integrates those visuals into the surah summary cards as subtle internal background art
5. keeps the visuals spiritually aligned, calm, elegant, and readable

The artwork should feel:
- soft
- atmospheric
- symbolic
- thematic to the surah
- subtle enough that text remains easy to read
- visually consistent with Path of Nūr

==================================================
DESIGN DIRECTION
==================================================

Style direction:
- soft watercolor / parchment / mist / light / subtle depth
- calm spiritual atmosphere
- soft gold warmth where appropriate
- no harsh contrast
- no busy compositions
- no faces
- no people
- no prophets
- no literal religious depictions
- avoid animals unless there is a very strong reason, and even then prefer symbolic/abstract direction
- no text embedded inside the artwork
- no UI baked into the images

These assets are background-support visuals, not posters.

The final in-app effect should feel like:
- a meaningful atmosphere inside the card
- not a loud illustration
- not a wallpaper that fights the typography

==================================================
ROLL OUT SCOPE FOR THIS PHASE
==================================================

Implement only the Top 10 surahs in this phase:

1. Al-Fatiha
2. Al-Baqarah
3. Aal-E-Imran
4. An-Nisa
5. Al-Ma’idah
6. Al-An’am
7. Al-A’raf
8. Al-Anfal
9. At-Tawbah
10. Yunus

This phase must be built in a way that scales cleanly to all 114 surahs later.

==================================================
STEP A — AUDIT FIRST
==================================================

Before editing anything:

1. Find the current Quran Summary list/card implementation
2. Identify:
   - the widget that renders each surah summary card
   - the current layout structure of the name/content container
   - how cards are styled
   - how assets are currently organized
   - whether any similar artwork or card background support already exists
3. Confirm the safest insertion point for the background artwork layer
4. Confirm what fallback behavior should happen when a surah image does not yet exist
5. Confirm whether image preloading/caching is already used anywhere nearby
6. Audit whether the existing card text colors, overlays, borders, and spacing will remain readable once subtle artwork is added

Do not start changing files until the audit is complete.

==================================================
STEP B — DEFINE A SCALABLE SURAH VISUAL THEME MODEL
==================================================

Create a clean structured model for surah background theme data.

Example structure:

- surah number
- surah key/name
- short theme title
- longer visual prompt
- asset path

Use a maintainable structure, for example:
- a model
- a registry/map
- or a static config file

This must be easy to extend later for all 114 surahs.

For this phase, define thematic direction for the Top 10:

1. Al-Fatiha
   Theme: opening, guidance, first light, path, mercy

2. Al-Baqarah
   Theme: vastness, foundation, law, protection, grounded earth

3. Aal-E-Imran
   Theme: faith under trial, divine help, trust, uplifted light

4. An-Nisa
   Theme: justice, balance, dignity, order, gentle strength

5. Al-Ma’idah
   Theme: provision, covenant, nourishment, sacred table, gratitude

6. Al-An’am
   Theme: creation, signs, sky, earth, reflection, divine order

7. Al-A’raf
   Theme: heights, thresholds, separation, horizon, warning and hope

8. Al-Anfal
   Theme: struggle, resolve, support, victory through reliance

9. At-Tawbah
   Theme: truth, sincerity, separation from falsehood, moral clarity

10. Yunus
   Theme: patience, trust, turning back, calm after distress, sea/journey symbolism used carefully and subtly

Keep the actual prompts tasteful and symbolic.

==================================================
STEP C — BUILD/ADD THE IMAGE ASSET SET
==================================================

Create and add the artwork assets for the Top 10 surahs.

Requirements:
- format: .webp
- optimized for app use
- target size: ideally lightweight enough for smooth list scrolling
- resolution: enough to look clean in-card without overkill
- maintain a consistent visual language across all 10 images

Folder suggestion:
assets/quran/surah_summary_backgrounds/

Suggested filenames:
001.webp
002.webp
003.webp
004.webp
005.webp
006.webp
007.webp
008.webp
009.webp
010.webp

If a different naming convention is more consistent with the repo, use that instead, but keep it systematic.

Also update pubspec asset registration if needed.

If Codex cannot truly generate final image binaries in the current environment, then do not fake completion.
In that case:
- still build the full production-ready asset pipeline structure
- generate the exact finalized prompts and metadata for each of the Top 10 surahs
- prepare the repo for asset drop-in
- wire in the rendering and fallback system
- clearly state what was completed and what remains external

But if the environment supports producing the assets, produce them properly.

==================================================
STEP D — BUILD A CLEAN ASSET HELPER + FALLBACK SYSTEM
==================================================

Create a helper that resolves the surah background asset path by surah number.

Requirements:
- must support Top 10 assets immediately
- must safely return null or fallback when no image exists
- must not crash if asset missing
- must be easy to extend later to full 114 coverage

Example behavior:
- Surah 1..10 -> returns actual asset
- Surah 11+ -> returns null or a calm default background
- if asset loading fails -> fallback gracefully

If there is already an app-wide image helper pattern, reuse it.

==================================================
STEP E — INTEGRATE THE BACKGROUND INTO THE SURAH CARD
==================================================

Modify the surah summary card so the artwork appears inside the main name/content container.

Important:
- keep the existing container shape, border, and theme intact
- preserve text readability
- preserve tap handling
- preserve spacing
- preserve performance
- preserve accessibility

Recommended layer order:
1. card surface/base
2. artwork background
3. soft overlay/gradient to keep text readable
4. existing card content

The image must feel subtle.
It should not dominate the card.

Use:
- clipped corners matching the existing container radius
- low opacity
- possibly a soft blend with the card surface
- a gentle overlay above the image

Do not make the card look muddy or overprocessed.

==================================================
STEP F — KEEP TEXT READABILITY STRONG
==================================================

Audit and adjust as needed:
- Arabic title
- English title
- subtitle/meaning
- metadata chips
- description text
- CTA text like “View details”
- chevrons/icons if present

If needed:
- slightly strengthen overlay
- subtly adjust image opacity
- slightly darken/lighten the text surface
- do not redesign the whole card unless necessary

The result must still feel like Path of Nūr.

==================================================
STEP G — PERFORMANCE + SCROLL SAFETY
==================================================

This is a scrolling Quran list, so performance matters.

Implement safely:
- use optimized asset sizes
- do not use oversized images
- avoid unnecessary rebuilds
- avoid expensive runtime effects
- consider precache if appropriate and safe
- keep scroll smooth

Do not introduce jank.

==================================================
STEP H — LOCALIZATION / ARCHITECTURE / CLEANUP
==================================================

Preserve localization.
Do not introduce hardcoded user-facing strings where avoidable.

Clean up:
- remove any dead experimental background code if you find it and if it is clearly obsolete
- do not remove unrelated code
- keep naming clean
- keep ownership obvious

If a summary card widget is getting too overloaded, refactor lightly and safely.

==================================================
STEP I — VALIDATION CHECKLIST
==================================================

Validate all of the following:

1. Top 10 surahs resolve to the correct background asset
2. artwork appears inside the surah card container
3. text remains clearly readable
4. tap/route behavior is unchanged
5. no layout breakage on smaller phone widths
6. scrolling remains smooth
7. fallback works for surahs without artwork
8. analyzer is run on changed files
9. any tests that can reasonably be run for changed logic are run
10. no unrelated regressions introduced

==================================================
STEP J — DELIVERABLES
==================================================

At the end provide a concise structured summary with:

1. Audit findings
   - where the surah summary card lives
   - how the card is structured now
   - safest background insertion point
   - fallback strategy chosen

2. Files created

3. Files modified

4. Surah visual mapping summary
   For each of the Top 10:
   - surah number
   - surah name
   - theme name
   - asset filename

5. Asset generation summary
   - whether final .webp files were actually produced in-environment
   - if not, the exact prompts prepared for external generation
   - compression/optimization approach

6. Integration summary
   - how the background is layered into the card
   - what opacity/overlay approach was used
   - how readability was preserved

7. Performance summary
   - anything done to keep scrolling smooth

8. Validation summary
   - analyzer result
   - tests run
   - fallback verification

9. Follow-up recommendations
   - best next step for rolling out 11–114
   - whether to next do Juz Amma, all 114, or dark-mode variants

==================================================
IMPORTANT IMPLEMENTATION NOTES
==================================================

- Prefer symbolic abstraction over literal illustration
- Keep everything elegant and spiritually calm
- Do not overbuild animation in this phase
- Do not rebuild the Quran Summary page from scratch
- Extend what exists cleanly
- Keep the system scalable to all surahs
- If there is any uncertainty in where to integrate, audit first and choose the least invasive production-safe option

==================================================
OPTIONAL PROMPT REFERENCES FOR THE TOP 10 ARTWORK
==================================================

Use these as thematic prompt foundations if image generation is supported or if an external pipeline is prepared:

1. Al-Fatiha
“Soft watercolor abstract spiritual opening, first light through mist, subtle path of guidance, calm warm neutrals, gentle gold glow, minimal, elegant, no humans, no animals, no text”

2. Al-Baqarah
“Soft watercolor abstract grounded landscape, vast earth tones, calm horizon, sense of foundation and protection, subtle divine light, minimal, elegant, no humans, no animals, no text”

3. Aal-E-Imran
“Soft watercolor spiritual sky, uplifting light through clouds, faith under trial, trust and divine support, calm gold and blue-gray tones, minimal, elegant, no humans, no animals, no text”

4. An-Nisa
“Soft watercolor abstract symmetry, balance, justice, dignity, gentle structure, refined warm neutrals, subtle light, minimal, elegant, no humans, no animals, no text”

5. Al-Ma’idah
“Soft watercolor symbolic provision and covenant, gentle table-like sacred composition without literal objects, nourishment and gratitude, subtle golden light, minimal, elegant, no humans, no animals, no text”

6. Al-An’am
“Soft watercolor signs of creation, layered sky and earth, reflective atmosphere, divine order, gentle light, calm natural tones, minimal, elegant, no humans, no animals, no text”

7. Al-A’raf
“Soft watercolor elevated horizon, thresholds and heights, separation and reflection, gentle atmospheric distance, soft light, minimal, elegant, no humans, no animals, no text”

8. Al-Anfal
“Soft watercolor atmosphere of resolve and supported struggle, quiet strength, directional light, calm intensity, restrained warm and earth tones, minimal, elegant, no humans, no animals, no text”

9. At-Tawbah
“Soft watercolor moral clarity, truth cutting through haze, subtle separation of shadow and light, sincerity and return, minimal, elegant, no humans, no animals, no text”

10. Yunus
“Soft watercolor calm journey atmosphere, trust and patience after distress, subtle horizon and sea-inspired tranquility used abstractly, gentle light, minimal, elegant, no humans, no animals, no text”

==================================================
END OF PROMPT
==================================================
