# iPhone Home + Lock Screen Widgets V1.5 — Enhancement Backlog

Date: 2026-04-10

## Recommended next improvements

- Add the `PathOfNurHomeWidgets` target to `Runner.xcodeproj` and create a shared scheme so the new Home + Lock Screen widgets can be built and validated end to end.
- Add non-English native `Localizable.strings` resources for widget gallery labels/descriptions and any later native-only fallback copy.
- Add a richer next-prayer accessory circular design once on-device testing confirms how much timer text remains legible at the chosen deployment target.
- Consider a dedicated compact prayer-phase payload if we want the circular lock-screen widget to show a more truthful prayer-window progress ring instead of a conservative approximation.
- Add a StandBy-optimized large/rectangular prayer summary once the Home + Lock Screen target is fully wired.
- Add focused payload-builder tests for countdown label formatting, date-line rendering, and prayer-state mapping.
- Consider a shared widget checksum to skip redundant writes when snapshots have not meaningfully changed.
- Revisit the app group identifier after the widget target is wired; `group.com.pathofnur.watch` works for reuse today, but a broader shared app/widget group may be cleaner long-term.
- Explore using the same snapshot data for future Apple Watch / iPhone lock-screen consistency so prayer and dhikr state stay visually aligned across companions.
