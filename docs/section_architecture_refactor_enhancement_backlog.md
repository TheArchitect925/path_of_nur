# Section Architecture Refactor Enhancement Backlog

## Follow-ups intentionally deferred

- Add a more explicit Qur'an section landing audit to reduce any remaining overlap between `/quran`, `/learn/hub/quran`, and older Learn-owned Qur'an aliases.
- Split the monolithic `settings_page.dart` category sections into smaller files once the new settings category map settles and no further IA churn is expected.
- Audit legacy Learn routes for safe removals after usage telemetry or QA confirms the new `/learn` landing covers the real entry paths.
- Add widget tests for the new section landing scaffolds and settings category hub navigation.
- Review section-specific Qur'anic verse selection for each new hub so every major landing uses the most thematically appropriate approved quote source.
- Consider moving the remaining `GrowthHabitsPage` inline action strings into localized menu/action helpers during the next focused Growth cleanup pass.
- Continue the Qur'an hub cleanup by localizing any remaining secondary tool or helper copy in adjacent Qur'an subpages so the whole section matches the hub standard consistently.
