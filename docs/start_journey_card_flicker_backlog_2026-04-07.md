# Start Journey Card Flicker Backlog

Date: 2026-04-07
Surface: Learning Journey detail stage cards

## Enhancement options

- Run a focused profile on the journey detail page in Flutter DevTools to confirm whether liquid-glass compositing or list-wide rebuilds remain the dominant scroll cost.
- Consider adding an opt-in repaint-isolation flag to `AppHeroGlassShell` if other long scrolling glass lists show the same behavior.
- Review whether heavy scroll lists should prefer a less expensive glass mode while moving and restore full liquid treatment only when idle, but only if the repaint-boundary fix is not enough.
- If this vintage poster direction lands well, extract a shared non-glass "editorial journey card" component so future journey lists can reuse the same stable scroll-friendly surface.
