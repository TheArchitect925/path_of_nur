# Learn Placeholder Containment Backlog

Last updated: 2026-03-22

## Purpose

Track the remaining Learn-area work after the Phase 10 production-safety containment pass.

## Completed in Phase 10

- removed `legacy-learning` from live Learning Journey discovery surfaces
- contained the placeholder-backed `tajweed-basics` journey and direct stage route
- contained `/learn/guides` and `/learn/guides/quran-lessons-mapping`
- preserved `/learn/legacy` as a compatibility route without surfacing it from active journey discovery
- confirmed live Dua surfaces already filter to verified items rather than exposing stub catalog breadth

## Recommended next enhancements

1. Replace `tajweed-basics` with a real beginner-safe tajweed path.
   - Why: the route now fails safely, but the product gap is still visible in the Arabic-learning map.
   - Scope: reuse `quranArabic` ownership and existing Qur'anic Arabic tools instead of adding another parallel hub.

2. Decide the long-term fate of `/learn/legacy`.
   - Why: it still exists as a compatibility surface even though current Learn ownership has shifted to `/learn`.
   - Options: keep as compatibility-only, convert to contained route later, or archive once callers are removed.

3. Audit the remaining journey lesson copy for “future” or “later” language on live routes.
   - Why: some journeys are technically wired but still describe future-state content in stage summaries.
   - Focus areas: discovery journeys and generic lesson-backed stages.

4. Replace the contained guide routes with curated real content or remove their public surfacing permanently.
   - Why: containment is safer for beta, but the product still needs a final decision on whether these are editorial tools or user-facing learning content.

5. Continue Learn localization hardening on high-traffic pages.
   - Why: placeholder containment is safer now, but Learn still has English-heavy legacy copy in some older surfaces.

6. Add broader widget coverage for Learn discovery.
   - Why: the new containment rules should stay protected when Learn IA shifts again.
   - Suggested targets: `/learn`, `/learn/explore`, journey home visibility, contained route rendering.
