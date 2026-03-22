# Today Audit Sweep Backlog

Date: 2026-03-21
Scope: broad stabilization follow-up after the current kids/progression/story/day audit pass

## High Priority

- Migrate `kids_arabic` progress and rewards to learner-scoped storage.
- Route kids Arabic XP and Ocean Drops through the shared learner progression gateway instead of direct Journey/Ocean writes.
- Unify fallback learner ID resolution across bedtime, kids dua, kids Arabic, and progression when no child profile exists.

## Medium Priority

- Add widget tests for the learner progression page and bedtime parent dashboard page.
- Extend parent-facing summaries beyond prophet-bedtime metrics so the broader kids stories library and Seerah journeys can appear in one calm summary model.
- Add a canonical learner-scoped bedtime activity log instead of relying only on derived recent activity timestamps.
- Review route alias sprawl in `learn_routes.dart` and document canonical ownership versus compatibility aliases.

## UX / Polish

- Normalize remaining bespoke card containers on older kids/progression-adjacent surfaces to shared `PremiumCard` or shared scaffold surfaces where safe.
- Add compact “recent badges” or “latest milestone” summaries on broader family surfaces after the progression system stabilizes.
- Add overflow-safe review on dense stat surfaces for very long localized strings and small devices.

## Content / Assets

- Add real narrated audio assets for kids duas, expanded kids stories, companion stories, and Seerah journeys.
- Add artwork/illustration asset coverage for non-prophet stories and Seerah journey stages.
- Review partially authored dua/story seed entries for missing Arabic/audio-backed content and prioritize the highest-traffic items first.

## Search / Discoverability

- Expand shared Learn indexing metadata for broader kids-story, Seerah, and progression-adjacent recommendations where useful.
- Keep calm dashboard surfaces non-searchable, but continue structuring metadata for future shared indexing.
