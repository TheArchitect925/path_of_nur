# Phase 25E Enhancement Backlog

Last updated: 2026-03-23

## Recommended next enhancements

- Replace the remaining hardcoded copy inside [learn_quran_hub_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/presentation/pages/learn_quran_hub_page.dart) with generated localization so the scoped `/quran/learning` surface is consistent with the rest of the canonical Qur’an area.
- Audit older Learn Journey tool links that still describe `Qur’an Study` and update their wording to `Qur’an Learning` where that matches the approved canonical ownership direction.
- Decide whether the scoped `/quran/learning` surface should eventually be renamed in code from `LearnQuranHubPage` to a Qur’an-owned name once compatibility pressure is lower.
- Add one narrow route test that verifies `/learn/hub/quran`, `/learn/hub/quran/learning`, and `/learn/hub/quranic-arabic` redirect to the canonical `/quran*` paths rather than acting as separate surfaced owners.
- Revisit secondary Learn surfaces such as [quran_hub_section.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/presentation/quran_hub_section.dart) and remove any remaining parallel-hub wording after the broader Learn ownership phase is approved.
