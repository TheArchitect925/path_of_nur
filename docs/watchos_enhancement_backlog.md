# watchOS Enhancement Backlog

Last updated: 2026-03-18

## Highest-value next enhancements

1. Replace watch-side optimistic reward projection with a phone-confirmed reward acknowledgement payload so XP and Ocean Drops always reflect final source-of-truth values.
2. Add localized watch resources beyond the base `Localizable.strings` files so the watch app matches the phone app’s supported languages.
3. Add post-prayer adhkar quick follow-up cards after a prayer check-in, sourced from trusted existing app content only.
4. Expand complication coverage for more families and add reload triggers when the phone publishes a fresh snapshot.
5. Persist an in-progress dhikr session across watch relaunches and day rollover with clearer recovery rules.
6. Add real-device QA automation notes for paired sync, unreachable-phone behavior, and watch-only cache recovery.
7. Wire level/growth presentation to a more explicit native presentation model if the phone app evolves beyond the current snapshot fields.
8. Add a guarded kids-mode watch presentation if the phone app later exposes profile-safe watch settings.

## Nice-to-have follow-ups

1. Add a richer watch home completion state with subtle ambient animation once all five prayers are complete.
2. Add watch notification actions for direct prayer check-in from reminders if iPhone notification plumbing is already trusted.
3. Add a dedicated post-sync diagnostics panel for QA builds only.
4. Add more dhikr presets driven from phone-side preferences rather than static native defaults.
