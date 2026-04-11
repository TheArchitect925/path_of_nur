# iPhone Home Widgets V1 — Enhancement Backlog

Date: 2026-04-10

## Recommended next improvements

- Add the new `PathOfNurHomeWidgets` extension target to `ios/Runner.xcodeproj` so the WidgetKit bundle is buildable without manual Xcode steps.
- Consider moving the shared widget app group from `group.com.pathofnur.watch` to a more neutral shared identifier such as an app-wide widgets/sync group, then update watch + widget consumers together.
- Add non-English native widget `Localizable.strings` resources so the widget gallery display names and descriptions match app locale coverage.
- Add optional Qur'an home widget support once the first four widgets are validated on device.
- Add a small theme-aware payload flag if we want widgets to react to major appearance families in a controlled way.
- Add a targeted iOS QA checklist for:
  - prayer-boundary refresh timing
  - midnight rollover
  - stale snapshot fallback
  - widget tap deep-link routing
  - app group read/write verification on real device
- Consider a shared snapshot checksum or last-written hash to skip identical widget writes and reduce redundant refresh calls.
- Add focused tests around the Flutter-side payload builder so date lines, countdown labels, dhikr totals, and journey summaries stay stable through future refactors.
- Explore Lock Screen / accessory widget variants after the Home Screen bundle is fully wired and device-validated.
