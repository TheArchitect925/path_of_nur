===== PHASE X PROMPT — Full UI Surface Consistency Audit + Global Material Unification =====

PRIMARY OBJECTIVE === AUDIT AND FIX THE ENTIRE APP SO THE UI USES ONLY THE APPROVED SURFACE TYPES CONSISTENTLY

Repo: TheArchitect925/path_of_nur

Context:
Previous instructions were only applied partially. Some screens and widgets were updated, but others were left on older/default/local styling. I need a full repo-wide audit and correction pass so the whole app follows one consistent material/surface system.

This is not a small tweak.
This is a production cleanup + unification pass.

Critical instruction:
Always check the repo first for what already exists before changing anything.
Do not create a parallel theme system.
Do not go haywire and delete or rewrite working product logic for no reason.
Do not do a placeholder pass.
Do not only fix a few obvious pages and stop.
Audit the whole visual ownership chain and fix all remaining drift.

==================================================
TARGET DESIGN RULES — ONLY THESE SURFACE FAMILIES
==================================================

We want the app to use only these material categories:

1. SACRED / DEVOTIONAL CONTENT
Anything that is:
- Qur’an
- Dua
- Ayah
- Surah
- Qur’anic quote
- Qur’anic reference
- devotional sacred reading/explanation panels
- explicitly sacred text containers

MUST use:
- Dense Sanctuary Glass

Codex already knows what we mean by Dense Sanctuary Glass from the prior implementation/testing.
Keep using the shared sacred treatment, not page-local imitation.

2. EVERYTHING ELSE
All normal:
- islands
- cards
- panels
- feature tiles
- list-style content containers
- homepage containers
- settings containers
- learning cards
- section containers
- general widget containers
- journey/worship/learn/home containers
- frosted info surfaces

MUST use:
- Frosted Glass

And this Frosted Glass should read as:
- consistent across the whole app
- golden yellow / warm gold / spiritually warm
- not random parchment in one place and beige in another and grey in another
- still elegant and readable
- still Path of Nūr
- not neon
- not orange
- not muddy

Important rule:
If something currently uses a parchment-like or warm ivory surface and it is NOT sacred content, convert it into the shared golden-yellow Frosted Glass direction instead of leaving it as a one-off parchment owner.

Special note on learning cards:
- We are changing learning cards too
- keep any intentional category/color identity that still matters
- but the actual surface/material language should still become Frosted Glass
- so if something is currently parchment, convert that to golden-yellow Frosted Glass rather than leaving it on an old parchment box style
- preserve tasteful category accents only where needed, not separate material systems

==================================================
WHAT THIS PHASE MUST DO
==================================================

This phase must:
1. audit the full repo for surface/material/card/island/container drift
2. identify all remaining local/default/legacy/hardcoded surface owners
3. replace the drift with the approved two-family system
4. ensure sacred surfaces use Dense Sanctuary
5. ensure all non-sacred containers use Frosted Glass
6. preserve product behavior and layout
7. finish with a true final audit summary

This is both:
- an audit pass
- a correction pass

==================================================
VISUAL POLICY TO ENFORCE
==================================================

Allowed material families after this pass:

A. Dense Sanctuary Glass
Only for sacred/devotional surfaces

B. Frosted Glass
For everything else

No third unofficial material family should remain unless there is a very strong, explicit reason already built into the product architecture.

That means:
- no random default Material cards
- no inconsistent local white containers
- no leftover parchment-only surfaces that ignore the shared system
- no feature-specific one-off card systems unless truly justified
- no legacy flat boxes that escaped the rollout
- no silent fallback to default Flutter card appearance where shared surfaces should be used

==================================================
AUDIT SCOPE
==================================================

You must inspect all major visual owners including but not limited to:

Global/shared:
- `lib/core/theme/app_theme.dart`
- `lib/core/theme/app_surfaces.dart`
- `lib/core/theme/app_backgrounds.dart`
- `lib/shared/widgets/premium_card.dart`
- `lib/shared/widgets/app_page_scaffold.dart`
- `lib/shared/widgets/app_scaffold.dart`
- `lib/shared/widgets/section_hub_scaffold.dart`
- `lib/shared/widgets/quran_quote_block.dart`
- `lib/shared/widgets/quran_reference_block.dart`
- `lib/shared/widgets/noor_liquid_glass.dart`

High-risk page/feature owners:
- home
- learn
- worship
- salah
- journey
- quran
- dua
- settings
- feature-specific summary/theme files
- any special widget folders under these features

Especially inspect:
- `home_page.dart`
- `salah_page.dart`
- learning category / island cards
- Qur’an reader surfaces
- Qur’an summary surfaces
- dua detail / list / devotional cards
- settings preview/demo/local visual cards
- any comparison/demo/temporary visual widgets still present

==================================================
IMPLEMENTATION RULES
==================================================

1. SHARED SYSTEM FIRST
Use the shared material system as the authority.
Do not fix pages by painting over problems with local one-off decorations unless absolutely necessary.

2. SACRED CONTENT CLASSIFICATION
Anything that is genuinely sacred/devotional content should opt into Dense Sanctuary.
Be careful and deliberate.
Not every card inside a Qur’an-related page is automatically sacred.
Example:
- ayah text block = sacred
- dua content card = sacred
- generic action utility card on a Qur’an page = probably Frosted
- generic settings/configuration card = Frosted

3. NON-SACRED SURFACES
All general islands/containers/cards/panels should converge to the same Frosted Glass family.

4. GOLDEN-YELLOW FROSTED DIRECTION
Make Frosted Glass clearly read as warm golden-yellow across the app.
Do this through the shared system where possible.
Avoid random page-local yellows.
We want one coherent warm frosted identity.

5. LEARNING CARD RULE
Learning cards can keep tasteful accent identity, but the surface family must still be Frosted Glass.
No leftover parchment-card subsystem.

6. PRESERVE LAYOUTS
Do not redesign layouts, navigation, IA, or logic.

7. PACKAGE USAGE
Do not scatter direct `liquid_glass_renderer` usage across the app.
Keep package usage isolated behind the existing wrapper boundary if relevant.
Prefer the shared in-house surface system.

==================================================
TASKS TO PERFORM
==================================================

PHASE 1 — REPO-WIDE AUDIT
Audit all relevant visual owners and identify:
- sacred surfaces already correct
- non-sacred surfaces already correct
- local/default/legacy drift
- parchment leftovers
- default material leftovers
- feature-specific one-off card systems
- preview/demo/temporary material systems
- any places where the prior rollout only partially landed

PHASE 2 — SHARED SYSTEM TUNING
If needed, refine the shared Frosted Glass appearance so it more clearly reads as:
- warm
- golden yellow
- consistent
- premium
- readable

Do this centrally, not page by page.

If needed, refine Dense Sanctuary slightly only if required for consistency with the audit findings.
Do not weaken its sacred/devotional distinction.

PHASE 3 — REPO-WIDE CORRECTION PASS
Bring remaining drift into compliance:
- sacred -> Dense Sanctuary
- non-sacred -> Frosted Glass

This includes:
- islands
- cards
- panels
- feature tiles
- learning cards
- settings cards
- homepage containers
- worship/journey/learn/home content containers
- section cards
- local hardcoded boxes where shared surfaces should be used

PHASE 4 — LEARNING CARD HARMONIZATION
Specifically inspect learning cards and category cards.
Goal:
- keep useful accent identity where appropriate
- convert material language to Frosted Glass
- replace parchment-style leftovers with golden-yellow Frosted Glass

PHASE 5 — FINAL CLEANUP
Clean up:
- stale local decorations now made redundant
- inconsistent box shadows if now owned centrally
- any leftover preview-only surface logic that interferes with the shared system
- obvious dead visual branches if they are clearly obsolete and safe to remove

Do not delete temporary comparison/demo code unless it is directly interfering and clearly safe to remove.
If kept, call it out in the final audit.
