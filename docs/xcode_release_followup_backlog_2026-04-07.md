# Xcode Release Follow-up Backlog

Date: 2026-04-07
Area: iOS / Xcode release

## Enhancement options

- Run a full `flutter analyze` sweep before final archive/export if we want a broader pre-release confidence pass beyond the focused files touched in this session.
- Create a signed Xcode archive and validate the resulting build in Organizer before App Store Connect upload.
- Verify release metadata in Xcode one more time for:
  - version `1.2.12`
  - build `32`
- Run one last small-device QA pass on Home, Learn, Qur'an, and shell navigation because those surfaces changed visually in this release prep cycle.
