# Kids Dua Learning Enhancement Backlog

- Add reviewed audio assets for each starter dua and enable real playback.
- Add localized kids dua strings for release locales beyond English.
- Add a second practice mode after validating the first match-by-situation flow.
- Add richer reward artwork if the sticker system expands into shared kids rewards.
- Add parent dashboard visibility for kids dua alongside kids Arabic if a combined kids learning dashboard is approved.
- Add content localization architecture for full dua text once non-English kids dua rollout is approved.
- Align reward sticker definitions with the expanded 23-dua library so every `rewardStickerId` can surface in UI later.
- Decide whether the advanced practice and rewards pages should stay exposed in V1 or be hidden until their datasets are expanded to match the full library.
- Add a lightweight source badge style for `sourceType` and `sourceReference` on the detail page.
- Add focused route smoke coverage for `kidsDuaLanding`, `kidsDuaCategory`, and `kidsDuaLesson`.

## Experience-layer next options
- Add route/widget smoke tests for landing, category, lesson, practice, and rewards page loading.
- Add translated kids dua chrome keys for `ar` and `de` so the new experience-layer strings do not fall back to English.
- Add a small audio availability adapter so lesson pages can show enabled playback only when real assets exist.
- Add category-specific featured/continue recommendations instead of whole-library ordering once product sequencing is approved.
- Add a lightweight unlocked-reward detail sheet from the rewards page without introducing a full achievement engine.

## Daily system and rewards next options
- Add translated daily/sticker UI keys for Arabic and German so the new daily flow does not fall back to English.
- Add a dedicated sticker detail sheet showing unlock time and category context.
- Add a small practice-priority adapter so today's dua appears in the first question more consistently.
- Add a lightweight daily-return message on the landing page after today's dua is already learned.
- Add widget smoke tests for landing and rewards pages with daily-focus and sticker states.

## My Day With Duas next options
- Add translated `My Day With Duas` UI keys for Arabic and German.
- Add a dedicated day-complete sheet on the My Day page instead of relying only on the lesson completion sheet.
- Add widget smoke tests for the My Day page with first-open, in-progress, and day-complete states.
- Add optional scroll-to-next-section behavior once the layout is stable on small screens.
- Add a subtle landing-page progress fraction for My Day sections completed today.

## Suggested Dua next options
- Add translated Suggested Dua UI keys for Arabic and German so the new guidance strip does not fall back to English.
- Let the recommendation engine avoid suggesting a dua already completed in `My Day` when another relevant option exists in the same time block.
- Add a small “Use now” completion affordance for already learned suggestions without forcing the practice flow.
- Add widget smoke coverage for the landing-page Suggested Dua section across not-learned, in-progress, and learned states.
- Add optional day-of-week weighting once product wants stronger real-life rhythm than pure time-block matching.

## Practice system next options
- Add translated practice UI keys for Arabic and German so the new quiz chrome does not fall back to English.
- Move behavior-scenario prompt copy into structured localizable content so it is not English-first.
- Add a lightweight end-of-round sticker-progress callout when practice unlocks a reward.
- Add widget smoke coverage for correct-answer, retry, and summary states on the practice page.
- Add a fourth practice mode only after validating completion rates for the first three modes.

## Unified My Day next options
- Add translated merged My Day guidance keys for Arabic and German so the unified daily surface does not fall back to English.
- Add a dedicated day-complete sheet on the My Day page instead of relying only on the lesson completion sheet.
- Add widget smoke coverage for Right Now, Next Up, and completed-day states on the My Day page.
- Add optional scroll-to-current-section behavior once the merged timeline layout is stable on small screens.
- Add smarter evening handling if product wants a distinct dusk step instead of mapping evening into the night flow.

## My Day embedded practice follow-ups
- Move behavior-scenario copy into the structured localized content pipeline so prompts and distractors are fully locale-owned instead of English-first seed logic.
- Add an inline `Try a question` affordance inside My Day sections if product wants mid-flow reinforcement before lesson completion.
- Add widget coverage for the full lesson -> embedded question -> back to My Day flow, including recap bonus display after day completion.
- Unify embedded My Day question copy and selection logic with any remaining standalone practice surface if both continue to coexist.

## Kids Dua light and retention follow-ups
- Add a dedicated light detail sheet with level meaning, longest streak snapshot, and the next gentle milestone.
- Add scheduler integration on top of the reminder-ready prompt model so morning, bedtime, and gentle-recovery nudges can be delivered natively.
- Add a small visual light illustration that changes by level on the landing and My Day surfaces without changing the core theme.
- Add widget coverage for landing and My Day light-state variants, especially recovery and completed-today states.

## Kids Dua drawing and parent view follow-ups
- Add a lightweight parent-only drawing detail sheet with the linked dua, save date, and quick reflection prompt.
- Add editable drawing reopening so a child can continue an existing dua drawing instead of only creating a new image.
- Add a simple parent-view gate before opening the dashboard if the product wants a clearer child/parent boundary.
- Add widget coverage for the drawing canvas save flow and the parent dashboard empty/non-empty states.

## Kids Dua story mode follow-ups
- Move story narration and scene text into a dedicated localized content pipeline so Story Mode can ship fully translated story content instead of English-first seed text.
- Add reviewed audio narration assets and scene-level playback controls for non-readers.
- Add illustration asset mapping so each scene uses real visual artwork instead of icon-based placeholders.
- Add story progress/resume state so children can return to the last seen scene in a story.

## Kids Dua full story mode follow-ups
- Move the 23-story seed text into a dedicated locale-owned content layer so story narration and scene text are fully translatable.
- Add reviewed narration audio and scene-by-scene playback controls for non-readers.
- Replace icon placeholders with real illustration assets keyed by the existing `illustrationHint` values.
- Add widget coverage for featured story, continue story, browse filtering, and final story-to-lesson CTA flow.

- Formalize the canonical story illustration taxonomy and add seasonal/light theme variants on top of the new asset resolver.
