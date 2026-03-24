# PHASE 31 PROMPT — SHARED ARABIC POSITIONAL FORMS AND JOINED-LETTER FOUNDATION

PRIMARY OBJECTIVE === BUILDING A SHARED ARABIC POSITIONAL-FORM AND JOINED-LETTER FOUNDATION USED BY BOTH KIDS AND ADULT ARABIC LEARNING EXPERIENCES

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready shared-foundation phase built on top of the newly unified Arabic alphabet catalog. DO NOT rebuild the Kids Arabic or Adult Arabic experiences. DO NOT change existing tracing/progress/routing behavior unless a small safe compatibility fix is strictly required. Build safely on top of the current implementation.

## CORE RULES

- Audit first before editing
- Preserve the shared canonical alphabet foundation created in the previous phase
- Preserve Kids Arabic progress, Adult Arabic routing/content continuity, tracing behavior, audio behavior, and lesson state
- Do not flatten Kids and Adults into one UI
- Add shared positional-form and joining metadata beneath both experiences
- Keep scope focused on beginner-friendly positional forms, not full advanced Arabic grammar
- No destructive migrations
- Run analyzer/tests and summarize results

## PHASE OBJECTIVES

1. Create a shared Arabic positional-form foundation for all 28 letters
2. Add shared metadata for:
   - isolated form
   - initial form
   - medial form
   - final form
   - simple joinability behavior where needed
3. Refactor both Kids and Adult Arabic learning flows to read positional-form data from the same shared source
4. Enable future joined-letter, word, and phrase systems to build on one canonical source of truth
5. Preserve age-appropriate presentation:
   - Kids = simpler, more visual, more guided
   - Adults = cleaner, more explanation-friendly, still easy

## AUDIT / IMPLEMENTATION SCOPE

- Audit current positional-form / joining handling across the shared Arabic foundation, Kids Arabic word/joining content, and Adult Qur'anic Arabic letter-form teaching content
- Define a shared positional-form model with canonical id, isolated, initial, medial, final, and joinability behavior
- Ensure full 28-letter coverage
- Encode beginner-friendly joining rules, especially for letters that do not connect forward
- Refactor Kids and Adults to use the shared source
- Keep Kids simpler and Adults clear
- Prepare for future words / phrases
- Add meaningful tests

## DELIVERABLES

1. Files changed
2. Audit findings
3. Shared positional-form foundation summary
4. Joinability summary
5. Refactor summary
6. Data safety summary
7. Validation
8. Final audit

## SUCCESS CRITERIA

- both Kids and Adult Arabic experiences now rely on one shared positional-form foundation
- all 28 letters have shared isolated/initial/medial/final coverage
- simple joining behavior is modeled centrally
- Kids remains simpler and more guided
- Adults remain easy and explanation-friendly
- no tracing/progress/routing behavior is broken
- the app is now ready for future shared words/phrases/joined-letter expansion from one canonical source of truth
