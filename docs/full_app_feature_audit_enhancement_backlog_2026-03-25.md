# Full App Audit Enhancement Backlog

Date: 2026-03-25

Purpose:
- Follow-up ideas from the full-app feature audit.
- This is intentionally separate from the feature inventory so review and implementation prioritization stay clean.

## Highest-value enhancement options

1. Finish end-to-end localization on active high-traffic surfaces, especially Settings, Accounts/Sync, and remaining helper/bridge copy in Wudu and Arabic flows.
2. Run a route ownership cleanup pass in Learn/Qur'an so older aliases stop reading like co-equal product owners.
3. Add focused widget and route regression coverage for the newest Arabic bridge flows, sync restore preview, and growth statistics pages.
4. Run real-device QA for Apple/Google sign-in, remote backup, restore, and auto-backup triggers before treating sync as launch-ready.
5. Consolidate remaining mixed XP and Ocean-drop consumers onto canonical Journey ledgers.
6. Complete the Qur'an playback consolidation pass so reader-owned exceptions do not keep drifting away from the shared orchestrator.
7. Add release-focused accessibility QA on large text, VoiceOver/TalkBack, and offline mode across Home, Qur'an, Arabic, and kids flows.
8. Review low-priority discovery/community surfaces such as Assistant, Circles, Celestial, and Creation features against actual product priorities so they do not accumulate unowned polish debt.

## Product-shaping opportunities

1. Decide whether Home should become a stronger personalized continuation layer across Qur'an, Learn, and Journey, or remain a lighter dashboard.
2. Decide whether adult Arabic progress should remain calm-summary-first or expand into a richer dedicated detail route.
3. Decide whether Kids Qur'an should gain its own search/light recitation tools or stay intentionally simplified.
4. Decide whether manual export should remain full-only or optionally respect sync-scope controls.
5. Decide whether companion surfaces like Seerah, Character, and Daily Wisdom should later influence Home recommendations or stay self-contained.

## Technical quality opportunities

1. Expand performance review coverage on large pages with dense lists and interactive state, especially Qur'an reader, growth statistics, game boards, and kids media surfaces.
2. Add more centralized validators for authored content catalogs so future additions cannot silently reference missing units, routes, or assets.
3. Continue trimming runtime localization shim/bridge code in favor of generated ARB-backed localization only.
4. Audit widget-tree depth and unnecessary rebuild hotspots on dashboard-style screens with multiple Riverpod watches.
5. Expand CI-safe integrity checks around Qur'an references, audio manifests, and content-source contracts.

## Suggested next audit slice

- Run a narrower “release-readiness audit” next, scoped to:
  - localization completeness
  - device QA gaps
  - accessibility gaps
  - route ownership confusion
  - performance hotspots on high-traffic pages
