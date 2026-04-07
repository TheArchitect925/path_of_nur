# Home and Learning Audit Backlog

Date: 2026-04-07

Context:
- Requested audit focused on Home and Learning stability, especially scroll behavior on home surfaces.

Recommended enhancements:
- Add a dedicated widget regression test that pumps `/home`, performs a long downward scroll, and asserts no uncaught exceptions while heavy cards like `OnThisDayHomeCard` and `CelestialCycleCard` are mounted.
- Add a second regression test for `/learn` that scrolls through the landing page with the guided paths section expanded and verifies no overflow or tap-target regressions.
- Consider moving the Home page from a single large `SingleChildScrollView` + `Column` to a sliver-based layout if scroll jank shows up in profiling, especially with multiple glass cards on screen at once.
- Profile the Home route in profile mode on a device or simulator while scrolling, with special attention to `NoorLiquidGlassContainer` surfaces and any shader-heavy cards.
- Make the home prayer-card test stricter over time by asserting the route/dialog state after the scroll-and-tap flow instead of relying on text only.

Notes:
- No product copy or localization keys were added in this audit pass.
