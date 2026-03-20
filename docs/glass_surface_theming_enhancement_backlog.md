# Glass Surface Theming Enhancement Backlog

- Migrate the app shell bottom navigation bar onto `AppSurfaceTheme` if the product later wants the shell chrome to follow the same glass/solid toggle more strictly.
- Add widget tests for `PremiumCard`, `SegmentedPillControl`, and `SectionHubActionCard` under both glass-enabled and glass-disabled appearance settings.
- Audit remaining highly custom feature surfaces in kids learning, celestial metrics, and creation explorer to decide which should join the canonical glass family versus remain deliberately specialized.

2. Consider adding a small live preview swatch in Appearance so users can see the current glass transparency level before leaving Settings.
3. Consider adding light/dark preview thumbnails for the full `0%` and `100%` glass transparency endpoints so users understand how extreme values affect container visibility before they drag the slider.
