# Search Discovery Backlog

## High-Value Next Improvements

- Expand synonym coverage for practical phrases like `new muslim`, `prayer help`, `memorize`, `letters`, and `daily worship`.
- Add better result snippets that explain why an item matched without making the UI noisy.
- Add a stronger related-content graph so discovery can suggest deeper stories, Arabic, and worship continuations more intelligently.
- Make search lightly aware of current path progress so active paths can surface with stronger continuity.
- Add profile-aware discovery tuning for child mode, returning learners, and recently completed paths.

## Seasonal / Contextual Discovery

- Add Ramadan-aware discovery boosts only when the existing seasonal/profile context is active.
- Add Friday-focused worship/story/Qur'an suggestions if the context signal is strong enough.
- Add gentle re-entry search groupings for dormant users.

## Analytics / Tuning

- Track top discovery queries and zero-result terms.
- Review whether guided paths are surfacing too aggressively or not enough.
- Measure whether broad hubs are still outranking better start-here entries for beginner queries.
- Validate whether kids queries need stronger dua/story weighting.

## Content / Metadata Gaps

- Add richer metadata to thin story/history entries that still rely on broad labels.
- Add more direct beginner-safe Qur'an learning entries so search can recommend precise canonical surfaces more often.
- Add search-friendly metadata for kids duas and kids reinforcement lanes.

## Do-Not-Break Notes

- Keep `/quran/*` canonical.
- Keep guided paths orchestration-only.
- Keep kids route family as the preserved audience owner.
- Do not create a second search system parallel to the shared Learn discovery model.
- Do not destabilize existing progress or recommendation providers while tuning discovery.

## Recommended Order

1. Expand synonyms and zero-result handling.
2. Improve snippet/reason presentation.
3. Strengthen related-content graphing.
4. Add profile-aware discovery tuning.
5. Add seasonal boosts only after telemetry confirms the base ranking is stable.
