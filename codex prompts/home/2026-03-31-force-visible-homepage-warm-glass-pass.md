# PHASE X PROMPT — FORCE A VISIBLY DIFFERENT HOMEPAGE WARM GLASS PASS

PRIMARY OBJECTIVE === MAKE THE HOMEPAGE VISIBLY DIFFERENT

The previous audit says the homepage warm glass pilot is already implemented, but the homepage still appears unchanged in practice.

This means one of the following is true:
- the visual delta is too subtle
- the wrong visible surface owner is still being styled
- the homepage is using a different render path than expected
- rebuild/state/theme interaction is masking the change

Your task:
Do a second-pass audit and make the homepage change VISIBLY and UNMISTAKABLY while still keeping it elegant and production-ready.

RULES
- Homepage only
- Do not globalize
- Do not touch non-home tabs/pages
- Do not break layout or readability
- Do not stop at “the treatment already exists”
- Verify actual visible rendering ownership
- Production-ready only

STEP 1 — TRACE ACTUAL VISIBLE HOMEPAGE SURFACES
Audit the live homepage widget tree again and identify:
- every visible homepage card/panel
- the exact BoxDecoration / surface resolver / widget wrapper actually painting each one
- whether any widget is bypassing `homepageWarmGlass`
- whether dark/light mode branches or conditional wrappers are overriding the pilot style

Output:
- visible surface widget
- actual paint owner
- whether `homepageWarmGlass` is truly applied
- why the homepage still looks unchanged

STEP 2 — INCREASE VISUAL DIFFERENCE
Tune the homepage warm glass so the change is unmistakable but still premium.

Required visible adjustments:
- warmer parchment/ivory tint
- softer creamy fill
- more noticeable gold-beige border
- more obvious warm shadow separation
- slightly richer inner glow/top sheen
- less flat white appearance

Do NOT overdo it.
It should still feel refined, calm, premium, and readable.

STEP 3 — APPLY ONLY TO HOMEPAGE
Ensure every homepage card/panel uses the stronger warm-glass treatment consistently.

This includes:
- ayah card
- prayer summary areas
- mini stat cards
- embedded homepage cards
- learning/action surfaces on home
- any home-local glass wrapper

STEP 4 — ADD TEMPORARY VISUAL VERIFICATION
For verification only during this pass, add one clearly inspectable property to homepage warm glass, such as:
- slightly more obvious border tint
- slightly warmer surface gradient
- slightly stronger warm shadow

This is not a debug banner.
It must remain production-acceptable, but clear enough that a screenshot comparison shows the difference.

STEP 5 — VALIDATE
Run:
- flutter analyze on changed files
- confirm only homepage surfaces changed

DELIVERABLES
1. Actual visible surface owners
2. What was overriding or masking the previous pass
3. Files changed
4. Exact styling values adjusted
5. Why this pass will now be visually noticeable
6. Analyzer results

FINAL REQUIRED STEP
State clearly:
- whether the previous implementation existed but was too subtle
- or whether the previous implementation missed the true visible surface owners
