# App Performance Audit Backlog

1. Completed 2026-04-13: Ran `flutter analyze` and cleared the blocking errors in test harnesses after new required parameters were introduced.
2. Completed 2026-04-13: Narrowed `worshipSummaryProvider` watches in the Home page to reduce rebuilds when unrelated summary fields change.

## Open QA Findings

- `flutter analyze` still reports unused private elements in `home_page.dart` and `prayer_section.dart`. These are not release blockers but should be cleaned up in a dedicated cleanup pass with archival per cleanup policy.

## Enhancement Options

1. Add targeted `select` usage for other large provider watches in Home/Journey dashboards to reduce rebuild churn during frequent provider updates.
2. Audit the Qur'an reader text-span and highlight pipeline (`quran_text_span.dart`) with a small benchmark and consider caching of repeated span fragments if QA shows long-surah scroll jank.
3. Add a lightweight widget-level performance regression test for the Home dashboard and Qur'an reader (time-to-first-frame and list build counts) to catch future regressions before release.
