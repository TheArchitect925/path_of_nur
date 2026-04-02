# Home Glass Preview Backlog

Date: 2026-04-01

## Enhancement options

- Add a tiny preview-only compact/expanded toggle if you want denser side-by-side comparison without increasing homepage height too much.
- Add one temporary debug-only switch to force `fake` vs `liquid` rendering inside the preview section if you want to compare fallback behavior on the same device.
- Add screenshots from iPhone light mode, Noor Glass mode, and Midnight Manuscript mode so the strongest candidates can be reviewed outside the simulator/device.
- Promote the top 2 or 3 selected styles into a second preview pass on one real home card family before touching any shared surface primitives.
- Normalize the strongest preview styles into named app-owned specs inside `noor_liquid_glass.dart` once a direction is chosen, so broader rollout can stay controlled.
- Fix the existing non-constant `IconData` tree-shake issue in Learn before any wider liquid-glass adoption, since iOS release packaging already exposed that as a separate polish item.

## Do-not-break notes

- keep the preview isolated to the home presentation layer
- do not replace the shared global surface system yet
- do not spread `liquid_glass_renderer` imports across feature pages
- keep `/quran/*`, Learn, and kids route ownership unchanged
- remove this preview cleanly before a production-wide surface migration if the chosen direction changes
