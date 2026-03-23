# Phase 25A Post-Change Audit Backlog

- Repair the red high-signal regression slice before broadening scope again:
  - `test/app/quran_route_integrity_test.dart`
  - `test/features/journey/growth_home_ia_test.dart`
  - `test/features/learn/salah/wudu_trainer_page_test.dart`
  - `test/features/learn/learn_placeholder_containment_test.dart`
- Replace the live runtime-localization shim copy on active Qur'an, Growth, Games, Wudu, and Kids Arabic surfaces with generated ARB-backed localization.
- Decide whether `LearnQuranHubPage` should remain a live parallel study hub or be demoted further behind canonical `/quran*` ownership.
- Normalize Browse All / explorer naming and labels where tests currently drift from runtime-localized live copy.
- Unify writing-system ownership across Learn Notes, Saved Reflections, and Journal before adding more retention features.
