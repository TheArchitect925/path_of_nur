# Page Shell Visual Consistency Follow-ups

- Date: 2026-03-19
- Scope: follow-up cleanup options after migrating active FAQ and Qur'anic Arabic pages onto the shared `AppPageScaffold`

## Next Options

- Migrate the remaining older Qur'anic Arabic lesson/listen-only pages onto the shared shell if they are still active user-facing surfaces.
- Audit older detail pages that still use raw `Scaffold` plus local headers, especially:
  - Salah surah detail
  - Growth path detail
  - baby name detail
  - divine life lesson detail
- Standardize older page-level loading and error states onto shared shell patterns where it can be done without broad localization churn.
- Review remaining active raw-scaffold pages that are intentionally different and explicitly classify them as:
  - immersive/atmospheric
  - interactive/session-driven
  - cleanup candidate
