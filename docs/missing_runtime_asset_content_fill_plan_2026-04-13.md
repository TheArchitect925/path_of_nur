# Missing Runtime Asset Content-Fill Plan

Date: 2026-04-13
Status: Prepared, generation blocked locally

## Blocker

- Actual image generation was not run in this pass because `OPENAI_API_KEY` is not set in the current environment.
- The repo is now prepared with a first-pass content spec so the next run can generate assets instead of redoing discovery.

## Recommended Batch Order

1. `quran_teacher` visual pack
2. `kids_stories` covers and backdrops
3. `kids_stories` scene illustrations

## Batch 1 — Qur'an Teacher Visual Pack

Style direction:
- clean child-friendly educational illustration
- soft neutral or pastel background
- simple focal object
- high legibility
- no decorative clutter
- suitable for early reading support

Missing assets:

- `assets/images/quran_teacher/placeholders/soft_placeholder.png`
  - Prompt: soft abstract placeholder card for Qur'an learning, gentle cream and sky palette, subtle geometric Islamic classroom atmosphere, no text, calm and minimal

- `assets/images/quran_teacher/visual_mode/letters/alif_apple.png`
  - Prompt: child-friendly educational illustration of a bright red apple for Arabic letter Alif, centered object, soft pastel classroom background, no text
- `assets/images/quran_teacher/visual_mode/letters/ba_ball.png`
  - Prompt: child-friendly educational illustration of a simple colorful ball for Arabic letter Ba, centered object, soft pastel classroom background, no text
- `assets/images/quran_teacher/visual_mode/letters/ta_tree.png`
  - Prompt: child-friendly educational illustration of a small green tree for Arabic letter Ta, centered object, soft pastel background, no text
- `assets/images/quran_teacher/visual_mode/letters/jeem_juice.png`
  - Prompt: child-friendly educational illustration of a cup of fruit juice for Arabic letter Jeem, centered object, soft pastel background, no text
- `assets/images/quran_teacher/visual_mode/letters/seen_sun.png`
  - Prompt: child-friendly educational illustration of a warm smiling sun symbol for Arabic letter Seen, centered object, soft pastel background, no text
- `assets/images/quran_teacher/visual_mode/letters/meem_moon.png`
  - Prompt: child-friendly educational illustration of a crescent moon for Arabic letter Meem, centered object, soft pastel night-sky background, no text
- `assets/images/quran_teacher/visual_mode/letters/noon_nest.png`
  - Prompt: child-friendly educational illustration of a bird nest for Arabic letter Noon, centered object, soft pastel background, no text
- `assets/images/quran_teacher/visual_mode/letters/waw_water.png`
  - Prompt: child-friendly educational illustration of a clear water cup or water splash for Arabic letter Waw, centered object, soft pastel background, no text

- `assets/images/quran_teacher/visual_mode/words/maa_water.png`
  - Prompt: child-friendly educational illustration representing the word water, clean cup or pouring water, centered, soft pastel background, no text
- `assets/images/quran_teacher/visual_mode/words/shams_sun.png`
  - Prompt: child-friendly educational illustration representing the word sun, warm glowing sun motif, centered, soft pastel background, no text
- `assets/images/quran_teacher/visual_mode/words/qamar_moon.png`
  - Prompt: child-friendly educational illustration representing the word moon, gentle crescent moon and stars, centered, soft pastel background, no text
- `assets/images/quran_teacher/visual_mode/words/kitab_book.png`
  - Prompt: child-friendly educational illustration representing the word book, simple closed book with warm colors, centered, soft pastel background, no text

## Batch 2 — Kids Stories Covers And Backdrops

Style direction:
- gentle illustrated children's book style
- calm lighting and soft color palette
- family-safe, modest, non-scary, non-chaotic
- no text baked into artwork
- visual storytelling should match the story theme without inventing harsh drama

Cover and backdrop pairs:

- `bismillah_before_eating_cover.png`
  - Prompt: young child pausing before a simple meal with gratitude, warm family dining scene, gentle children's book illustration, no text
- `bismillah_before_eating_backdrop.png`
  - Prompt: cozy meal table scene with soup, bread, warm light, gratitude atmosphere, gentle children's book illustration, no text

- `sharing_with_others_cover.png`
  - Prompt: two children sharing dates kindly, warm friendship scene, gentle children's book illustration, no text
- `sharing_with_others_backdrop.png`
  - Prompt: simple lunch setting with two children and shared snack, peaceful and generous mood, no text

- `telling_the_truth_cover.png`
  - Prompt: child honestly speaking after spilling water, calm reassuring home scene, gentle children's book illustration, no text
- `telling_the_truth_backdrop.png`
  - Prompt: family table with spilled cup and soft caring cleanup moment, peaceful mood, no text

- `helping_parents_cover.png`
  - Prompt: child helping a parent at home with kindness, gentle family cooperation scene, no text
- `helping_parents_backdrop.png`
  - Prompt: tidy home chore scene with warm supportive atmosphere, no text

- `kindness_to_animals_cover.png`
  - Prompt: child being gentle with a small animal, soft outdoor kindness scene, no text
- `kindness_to_animals_backdrop.png`
  - Prompt: peaceful garden or park scene with child-safe animal care atmosphere, no text

- `masjid_manners_cover.png`
  - Prompt: child entering or sitting in a masjid respectfully, calm and reverent children's illustration, no text
- `masjid_manners_backdrop.png`
  - Prompt: clean peaceful masjid interior with soft light and respectful atmosphere, no text

- `ramadan_kindness_cover.png`
  - Prompt: child showing kindness during Ramadan, lanterns and evening warmth, gentle children's illustration, no text
- `ramadan_kindness_backdrop.png`
  - Prompt: soft Ramadan home evening with lantern glow and generous atmosphere, no text

- `eid_gratitude_cover.png`
  - Prompt: child expressing gratitude on Eid, joyful but calm family-safe celebration, no text
- `eid_gratitude_backdrop.png`
  - Prompt: soft Eid morning scene with gifts, family warmth, and gratitude mood, no text

- `patience_cover.png`
  - Prompt: child practicing patience in a calm everyday moment, reassuring gentle illustration, no text
- `patience_backdrop.png`
  - Prompt: quiet reflective home or outdoor waiting scene with hopeful tone, no text

- `saying_sorry_and_forgiving_cover.png`
  - Prompt: two children reconciling kindly after a mistake, gentle forgiveness scene, no text
- `saying_sorry_and_forgiving_backdrop.png`
  - Prompt: peaceful friendship scene after apology, soft warm mood, no text

- `seerah_journey_cover.png`
  - Prompt: child-friendly seerah journey cover with desert path, stars, and gentle historical wonder, no faces emphasized, no text
- `seerah_journey_backdrop.png`
  - Prompt: calm seerah-inspired travel backdrop with desert horizon and mercy-centered atmosphere, no text

## Batch 3 — Kids Stories Scene Illustrations

Initial missing scenes currently implied:
- `bismillah_before_eating_scene_1.png`
- `bismillah_before_eating_scene_2.png`

Recommended prompt direction:
- Scene 1: child pauses before the first bite and remembers Allah
- Scene 2: meal becomes warm, shared, and grateful

## Suggested Execution Notes

- Generate PNG outputs first so current runtime references can be satisfied immediately.
- After real assets land, optionally run a later WebP migration pass on the new art if size warrants it.
- Keep filenames exactly aligned with the existing missing runtime paths to avoid unnecessary code churn.

## Next Follow-Up Options

1. Set `OPENAI_API_KEY` locally and run a first generation batch for the Qur'an teacher visual pack.
2. Review the generated art before adding the larger kids story cover/backdrop batch.
3. After assets are committed, rerun `tooling/scripts/audit_missing_runtime_assets.sh`.
