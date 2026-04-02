===== PHASE X PROMPT — Global Frosted Glass Rollout + Dense Sanctuary Sacred Surfaces =====

PRIMARY OBJECTIVE === BUILDING THE FINAL SHARED MATERIAL DIRECTION FOR PATH OF NŪR

Repo: TheArchitect925/path_of_nur

Context:
We already completed the global glass/theme audit and confirmed the correct architecture path.

This implementation phase should:
1. make Frosted Glass the shared default surface direction across the app
2. use Dense Sanctuary Glass + subtle edge light only for sacred/devotional surfaces
3. improve card shadows globally so cards feel lifted and softly 3D instead of flat

Critical instruction:
Always check the repo first for what already exists before making changes.
Do not create a parallel theme/material system.
Do not go haywire and delete or rewrite working systems for no reason.
Do not redesign page layouts.
Do not do a placeholder pass.
Build this as the real production-ready shared material implementation.

Existing architecture to respect:
- `lib/core/theme/app_theme.dart`
- `lib/core/theme/app_surfaces.dart`
- `lib/core/theme/app_backgrounds.dart`
- `lib/shared/widgets/premium_card.dart`
- `lib/features/profile/application/profile_settings_provider.dart`
- `lib/app/app.dart`

Important implementation principle:
The winning style must be implemented primarily through the shared surface/material system, not by styling random pages manually.

==================================================
TARGET VISUAL DIRECTION
==================================================

A. Global app default = Frosted Glass
Apply as the standard shared surface direction for:
- general cards
- islands
- panels
- feature tiles
- most settings surfaces
- learn/journey/worship/home cards
- general pills/chips where appropriate

Visual intent:
- calm frosted translucency
- readable and premium
- slightly softened glass feel
- not too milky
- not overly clear/crystal
- soft depth, soft highlights, gentle contrast
- consistent across the app

B. Sacred/devotional surfaces = Dense Sanctuary Glass + subtle edge light
Apply ONLY to sacred/devotional surfaces such as:
- Qur’an quote blocks
- Qur’an reader key reading/sacred surfaces
- dua cards / supplication surfaces
- other clearly devotional quote/ayah surfaces if they are truly sacred content owners

Visual intent:
- denser ivory sanctuary glass
- calmer, more protected, more reverent
- higher readability
- less see-through than normal frosted glass
- subtle edge light / halo-like rim light
- must feel elevated and special
- must NOT become neon, flashy, sci-fi, or gaudy

C. Depth upgrade everywhere
Add a stronger but soft shadow system so cards stop looking flat.

Visual intent:
- surfaces should feel lifted
- soft 3D depth
- elegant, premium, spiritual calm
- no harsh black shadow slabs
- no muddy heavy UI

==================================================
IMPLEMENTATION STRATEGY
==================================================

Do this in the following order:

PHASE 1 — SHARED SURFACE FOUNDATION
Primary owner:
- `lib/core/theme/app_surfaces.dart`

Tasks:
1. Audit existing surface variants and treatments.
2. Make Frosted Glass the shared default material direction for standard surfaces.
3. Add a new sacred treatment for Dense Sanctuary Glass.
4. Add shared support for subtle edge-light behavior for the sacred treatment.
5. Add a centralized shadow/depth strategy for all shared surface variants.
6. Keep existing architecture intact — evolve it, do not replace it.

Expected result:
- shared surface resolver becomes the main owner of frosted/default behavior
- sacred treatment exists as a first-class shared option
- shadow behavior is centralized instead of ad hoc

PHASE 2 — THEME TOKEN SUPPORT
Supporting owner:
- `lib/core/theme/app_theme.dart`

Tasks:
1. Add or refine appearance tokens only if needed to support:
   - frosted default behavior
   - dense sanctuary surfaces
   - edge-light consistency
   - improved shadow harmony
2. Keep theme mode architecture intact.
3. Do not create a separate giant theme mode just for this if the shared surface system can own it more cleanly.
4. Preserve current settings behavior:
   - app theme mode
   - disable glass transparency
   - disable colored glass
   - glass transparency level
   - disable background
   - high contrast text
   - reduce motion

Expected result:
- shared surfaces have the tokens they need
- settings still flow correctly into runtime theme resolution

PHASE 3 — BACKGROUND HARMONY TUNING
Supporting owner:
- `lib/core/theme/app_backgrounds.dart`

Tasks:
1. Tune backgrounds only if needed so the new Frosted Glass reads correctly.
2. Do not redesign background atmospheres.
3. Ensure sacred sanctuary surfaces still sit beautifully on current backgrounds.
4. Keep changes minimal and support-oriented.

Expected result:
- backgrounds support the new material direction without fighting it

PHASE 4 — SHARED CONSUMER ADOPTION
Primary shared consumer:
- `lib/shared/widgets/premium_card.dart`

Tasks:
1. Update `PremiumCard` so it properly reflects the new default Frosted Glass behavior.
2. Ensure default cards gain improved shadow/depth from shared logic.
3. Preserve its role as the main shared card consumer.
4. Do not make `PremiumCard` page-specific.

Expected result:
- standard cards across the app automatically improve through shared ownership

PHASE 5 — SACRED SURFACE TARGETING
Apply Dense Sanctuary + subtle edge light ONLY to the correct devotional owners.

Inspect and update the actual sacred-content owners such as:
- Qur’an quote block owners
- Qur’an reader surface owners
- dua / supplication surface owners
- other explicitly sacred text/ayah surface owners if clearly appropriate

Do NOT apply sanctuary treatment broadly to:
- settings cards
- generic admin/config cards
- generic statistic cards
- non-devotional utility cards
- unrelated navigation surfaces

Expected result:
- sacred surfaces are distinct and reverent
- non-sacred surfaces remain on Frosted Glass

PHASE 6 — TARGETED PAGE HARMONIZATION
Inspect and tune the biggest standalone owners only as needed:
- `lib/features/home/presentation/home_page.dart`
- `lib/features/salah/presentation/salah_page.dart`
- `lib/features/profile/presentation/settings_page.dart`
- `lib/features/learn/quran/presentation/quran_summary_theme.dart`

Tasks:
1. Remove visual mismatch where shared rollout is not enough.
2. Keep page layouts unchanged.
3. Do not rewrite feature logic.
4. Only harmonize material usage where the page is still locally diverging from the shared system.

==================================================
MATERIAL DETAILS TO IMPLEMENT
==================================================

1. FROSTED GLASS DEFAULT
Implement a more clearly frosted standard material using the existing shared surface system.

Desired characteristics:
- soft translucent body
- subtle white/ivory diffusion
- readable foreground contrast
- restrained tinting
- elegant border
- gentle top highlight
- balanced bottom tint
- soft lifted shadow

It should feel:
- calmer than crystal
- lighter than dense sanctuary
- more consistent than current mixed warm/page-local behavior

2. DENSE SANCTUARY GLASS
Implement a sacred treatment that feels denser, calmer, and more devotional.

Desired characteristics:
- more opaque than frosted default
- warm ivory/sanctuary diffusion
- stronger readability
- richer but soft internal light
- more protected, less transparent feel
- slightly deeper presence than standard cards

3. SUBTLE EDGE LIGHT
Apply only to Dense Sanctuary sacred surfaces.

Desired characteristics:
- soft perimeter edge light
- halo-like refinement
- delicate, premium, devotional
- warm ivory / gentle gold-white leaning
- low intensity
- should be clearly visible but restrained

Forbidden results:
- neon glow
- sci-fi border
- bright gold outline
- overly luminous or tacky edge

4. SHADOW SYSTEM
Centralize shadows by surface variant and treatment.

Need thoughtful depth for:
- card
- island
- panel
- featureTile
- pill
- navigationBar

Guidance:
- cards and islands should get the most useful lift
- pills should remain restrained
- nav bars should stay subtle
- sacred sanctuary surfaces may have slightly richer depth than normal frosted ones
- shadows must adapt well to light and dark modes

==================================================
PACKAGE USAGE RULES
==================================================

We know `liquid_glass_renderer` exists and is currently isolated through:
- `lib/shared/widgets/noor_liquid_glass.dart`
- temporary comparison code

Rules:
1. Do NOT scatter direct package usage across the app.
2. If using the package in this rollout, keep it behind the wrapper boundary only.
3. Prefer the existing in-house shared surface architecture unless the wrapper can be integrated cleanly and safely.
4. Do not make the whole implementation depend on fragile one-off package calls inside feature pages.
5. If the best implementation is to keep the package wrapper isolated and continue using the existing shared surface system, do that.

==================================================
DO NOT DO THESE THINGS
==================================================

- Do NOT redesign homepage layout
- Do NOT redesign Qur’an reader IA
- Do NOT create a second appearance/settings system
- Do NOT remove existing settings controls
- Do NOT break profile appearance flow
- Do NOT globally force sanctuary treatment everywhere
- Do NOT turn the app into shiny iOS demo glass
- Do NOT flatten everything into one identical card style
- Do NOT delete temporary comparison code unless necessary and clearly safe
- Do NOT touch unrelated business logic, routing, reminders, learning content, or persistence for no reason

==================================================
QUALITY BAR
==================================================

The final result should feel:
- more premium
- more consistent
- more dimensional
- calmer
- spiritually elegant
- more readable
- production ready

The app should still feel like Path of Nūr, not like a random glass UI kit.

==================================================
FILES TO PRIORITIZE
==================================================

Primary:
- `lib/core/theme/app_surfaces.dart`

Supporting:
- `lib/core/theme/app_theme.dart`
- `lib/core/theme/app_backgrounds.dart`
- `lib/shared/widgets/premium_card.dart`

Likely sacred/devotional consumers:
- Qur’an quote owners
- Qur’an reader surface owners
- dua/supplication surface owners

Likely harmonization targets:
- `lib/features/home/presentation/home_page.dart`
- `lib/features/salah/presentation/salah_page.dart`
- `lib/features/profile/presentation/settings_page.dart`
- `lib/features/learn/quran/presentation/quran_summary_theme.dart`

==================================================
DELIVERABLES
==================================================

1. Implement the shared Frosted Glass default across the app
2. Implement Dense Sanctuary Glass + subtle edge light for sacred surfaces
3. Implement improved shared shadows/depth
4. Keep the implementation centralized and production-clean
5. Preserve current settings architecture
6. Avoid unrelated regressions

At the end provide:
- files modified
- what was changed in each
- whether `liquid_glass_renderer` was actually used in final runtime code or not
- which sacred surfaces now use Dense Sanctuary treatment
- whether any temporary comparison code remains
- any follow-up harmonization still recommended

==================================================
FINAL AUDIT REQUIRED
==================================================

At the very end, do one final audit pass and provide one full summary covering:
- shared surface ownership after implementation
- sacred surface ownership after implementation
- shadow rollout status
- any remaining page-local visual drift
- anything that still needs cleanup later

Do not stop at planning.
Implement the full shared material rollout.
