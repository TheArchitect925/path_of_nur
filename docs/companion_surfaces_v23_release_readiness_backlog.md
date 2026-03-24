# Companion Surfaces V23 Release Readiness Backlog

Date: 2026-03-23

## Immediate follow-up candidates

1. Replace the companion-surface English fallback ARB values in non-English locales with real translations.
2. Add a manual VoiceOver/TalkBack QA sweep for `/learn/seerah`, `/learn/character`, and `/learn/daily-wisdom`.
3. Decide whether the remaining hidden `learnLegacy` catalog items (`jummah`, `eid`, `funeral`) should gain real owned destinations or stay intentionally archived.
4. Add one more narrow widget-level accessibility regression slice if manual QA finds semantics ordering issues on premium cards.

## Deferred by design

1. Do not remove `learnLegacy` broadly; the remaining dependencies are intentional compatibility debt outside the live companion routes.
2. Do not add a companion-surface detail page or heavier revisit engine for Daily Wisdom in this stabilization pass.
3. Do not redesign Learn IA or Journey architecture while release-hardening the companion surfaces.
