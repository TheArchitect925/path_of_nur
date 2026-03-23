# Phase 4 Prompt — RTL + Layout + Font Readiness

PRIMARY OBJECTIVE === BUILDING RTL, TEXT LAYOUT, AND FONT READINESS FOR PATH OF NŪR

You are working in the existing Path of Nūr Flutter codebase.

Task type:
Localization UI readiness (Phase 4 — RTL + layout + font support).

This is NOT a feature expansion phase.
This is NOT a broad UI redesign.
This is a production-readiness phase for multilingual UI behavior.

========================================================
CORE GOAL
========================================================

Make the app properly support:
- RTL languages (especially Arabic and Urdu)
- mixed-language text layouts
- mobile-safe text wrapping and overflow handling
- correct alignment and direction behavior
- suitable font handling for Arabic/Urdu/Qur’an text

The goal is to ensure the localized app is usable, readable, and visually stable.

========================================================
PRIMARY TARGET LANGUAGES
========================================================

This phase must prioritize:
1. Arabic
2. Urdu

Secondary awareness:
3. German
4. English

========================================================
STRICT DO-NOT-DO RULES
========================================================

Do NOT:
- redesign the app visually unless layout correction requires it
- rewrite unrelated business logic
- add new features
- remove routes, pages, or user data
- change product architecture
- go haywire and remove/delete records or functionality for no reason

========================================================
AUDIT-FIRST REQUIREMENTS
========================================================

Before editing, audit and document:

1. current app-wide text direction behavior
2. whether locale-driven RTL switching is already wired correctly
3. which screens break visually under Arabic/Urdu
4. which widgets assume LTR spacing/alignment
5. which screens contain mixed content:
   - Arabic
   - Urdu
   - English
   - transliteration
   - Qur’an text
6. which font families are currently used and where
7. whether Qur’an Arabic text and UI Arabic text should use the same font or separate fonts
8. where overflow/truncation is most likely in German and Arabic
9. whether icon mirroring / directional paddings / row alignment behave correctly in RTL

Do not guess.
Use the existing live screens and layout structure.

========================================================
PHASE SCOPE
========================================================

This phase should focus on:

A. RTL DIRECTION SUPPORT
- ensure Arabic and Urdu switch app layout direction correctly where appropriate
- ensure direction-sensitive widgets respect locale direction
- ensure text alignment matches intended UX

B. MIXED-CONTENT LAYOUT
Support safe rendering for screens containing combinations of:
- Qur’an Arabic
- Urdu UI
- English translation
- transliteration
- counts / placeholders / badges / chips

C. FONT READINESS
- audit current fonts used for:
  - general UI
  - Arabic UI
  - Qur’an text
  - Urdu text
- improve font usage if necessary for readability and consistency
- do not introduce unnecessary font complexity

D. OVERFLOW / WRAPPING SAFETY
- identify and fix obvious overflow/truncation issues in:
  - buttons
  - pills
  - cards
  - headers
  - bottom navigation labels
  - section tiles
  - settings rows
  - quiz/game cards
  - kids pages
  - Qur’an and Wudu surfaces

E. DIRECTION-SENSITIVE UI
- paddings/margins that assume left-to-right
- arrows/icons that should mirror in RTL
- row order and alignment where locale direction matters
- text fields and chips where mixed-direction content appears

========================================================
IMPLEMENTATION RULES
========================================================

1. Prefer app-wide correctness over one-off hacks.
2. Use locale-aware directionality where appropriate.
3. Preserve existing UX unless layout correctness requires adjustment.
4. Keep solutions maintainable and production-ready.
5. Fix real RTL/LTR bugs, not cosmetic preferences.
6. Prefer reusable helpers/patterns if multiple screens share the same issue.
7. Keep blast radius controlled.

========================================================
FONT RULES
========================================================

Handle fonts intentionally:

1. Distinguish between:
   - Qur’an Arabic text
   - Arabic UI text
   - Urdu UI text
   - Latin/German/English UI text

2. If separate fonts are needed:
   - use them intentionally and minimally
   - document where each is used

3. Ensure Arabic/Urdu rendering is:
   - readable
   - visually stable
   - not clipped
   - not awkwardly spaced

4. Do not over-engineer a font system if the current one already works with small targeted fixes.

========================================================
VALIDATION TARGETS
========================================================

At minimum verify these kinds of screens:
- Home
- Qur’an hub
- Qur’an reader/search
- Wudu
- Kids Arabic
- Games hub
- Growth home/details
- Settings
- Learn landing and major category cards

Also verify:
- buttons
- pills/chips
- cards
- bottom nav labels
- mixed Arabic/English text blocks
- RTL back/navigation affordances

========================================================
TESTING REQUIREMENTS
========================================================

Run:
- flutter analyze
- relevant widget/golden/layout tests if available
- add focused tests for RTL/layout direction if needed
- verify no regressions on existing localization-backed screens

If there are no suitable tests, add targeted coverage for:
- RTL direction application
- mixed-content rendering safety
- critical no-overflow layout behavior on key surfaces

Do not weaken tests just to pass.

========================================================
OUTPUT FORMAT
========================================================

Return exactly:

1. Audit Findings Before Changes
2. RTL / Layout / Font Risks Found
3. Files Changed
4. What Was Implemented
5. RTL Support Results
6. Font Handling Results
7. Overflow / Wrapping Fix Results
8. What Was Explicitly Not Changed
9. Remaining RTL / Localization UI Debt
10. Tests Added / Updated / Run
11. Final Audit Summary

========================================================
FINAL AUDIT SUMMARY FORMAT
========================================================

At the end provide:

- analyzer_passing: yes/no
- rtl_switching_verified: yes/no/partial
- mixed_content_layout_improved: yes/no/partial
- arabic_ui_font_readiness_improved: yes/no/partial
- urdu_ui_font_readiness_improved: yes/no/partial
- quran_text_rendering_preserved: yes/no
- overflow_risk_reduced: yes/no/partial
- unrelated_scope_expanded: yes/no
- biggest_rtl_ui_debt_remaining: <text>

========================================================
FINAL RULE
========================================================

This phase is an RTL + layout + font readiness pass only.

Do not broaden scope.
Do not restructure unrelated feature families.
Do not remove/delete records, routes, or features for no reason.

===== END =====
