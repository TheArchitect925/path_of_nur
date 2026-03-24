# Qur’an Readiness Bridge Expansion Backlog

Last updated: 2026-03-24

## Enhancement options

- Add one recitation-quality bundled snippet-audio pack for the expanded bridge so the bridge can prefer real recitation for the highest-value snippets instead of relying on phrase-pack overlap or fallback behavior.
- Add a tiny post-completion handoff from the expanded bridge into one curated short-surah study surface, most likely a beginner-safe Al-Fatihah or Al-Ikhlas continuation.
- Add widget-level coverage for level switching inside [quran_readiness_bridge_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/presentation/quran_readiness_bridge_page.dart) so future UI polish cannot silently break level navigation.
- Add one shared “known words in this snippet” explainer row that groups multiple familiar shared-word links more explicitly once the bridge grows beyond the current eight-snippet pack.
- Run on-device QA for small screens, large text, VoiceOver, and TalkBack with the new three-level progression layout and ayah-context highlighting.
