# Quran Companion Phase 7 Enhancement Backlog

Date: 2026-03-31

## Good next enhancements

- Add lightweight recommendation rotation or dismiss controls for secondary companion cards so the hub can refresh gently without feeling like a feed.
- Persist a tiny local recommendation interaction log so the companion can avoid showing the same non-resume suggestion too often.
- Add pathway and theme view-history signals so related follow-up suggestions can rely on direct discovery activity instead of mostly recent surah inference.
- Introduce a clearer Friday companion lane with reviewed Al-Kahf and other carefully grounded weekly recommendations, keeping scholarly-safety notes internal.
- Add a small “Why this?” explainer affordance on companion cards for users who want more transparency around recommendation reasons.
- Surface related companion suggestions inside Surah Summary Detail and Theme Detail so the personalized layer is not limited to the main Qur’an hub.
- Connect companion fallback logic to translated editorial content once non-English Qur’an theme/pathway copy is fully localized.
- Add focused provider tests for recommendation deduping, time-of-day scoring, Friday surfacing, low-data fallback ordering, and growth-focus mapping.
- Consider an optional prayer-context adapter later, but only after current prayer timing ownership is stable and the recommendation rationale remains simple.

## Notes

- This phase intentionally kept the system local, rules-based, and explainable.
- No opaque scoring, no feed-style endless list, and no new global recommendation architecture was introduced.
