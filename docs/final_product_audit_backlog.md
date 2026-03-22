# Final Product Audit Backlog

Date: 2026-03-21

This backlog captures the highest-value follow-up items found during the final
product-wide stabilization pass.

## Launch blockers

- Localize the highest-traffic settings and accounts/sync surfaces end to end so
  users do not bounce between localized and English-only flows.
- Validate major notification, audio, and reminder behavior on real iPhone/iPad
  hardware, especially prayer reminders, reflection reminders, and Qur'an audio
  resume behavior.
- Run a real-device navigation QA sweep for canonical Learn, Journey, Qur'an,
  and Settings routes to confirm alias redirects and back behavior remain
  coherent.

## High priority

- Replace or explicitly retire the remaining partial/bridge learning journey
  content, especially `100-quranic-words`, so user-visible journey quality is
  consistently real rather than mixed.
- Localize curated historical related-content hook labels from data ownership
  instead of relying on English seed text fallback.
- Continue Learn IA consolidation so `/learn`, `/learn/legacy`,
  `/learn/journey-home`, `/learn/browse`, and section hubs do not keep
  overlapping longer than necessary.
- Add widget coverage for journey home and island flows, especially starter CTA,
  continue journey, and no-duplicate rendering behavior.

## Medium priority

- Audit and trim dead placeholder handling in the learning journey layer if no
  placeholder-target stages remain active in the registry.
- Expand contextual linking to more lesson/page types once shared metadata is
  trustworthy enough to avoid noisy recommendations.
- Localize additional journey and learning metadata still falling back to
  English registry copy in secondary locales.
- Review history archive empty/filter states and manual related-content overlap
  against contextual related-content sections for tighter UX.

## Nice to have

- Add lightweight route smoke tests for key named destinations in Learn and
  Journey.
- Add small destination badges or destination-type styling polish for related
  content sections once localization debt is lower.
- Replace remaining stale internal mapping notes or migration copy in seeded
  learning datasets with cleaner editorial wording.
