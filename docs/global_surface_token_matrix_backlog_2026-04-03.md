# Global Surface Token Matrix Backlog

Date: 2026-04-03

## Recommended next enhancements

1. Add semantic shared wrappers for the most repeated local UI patterns:
   - hero utility card
   - action pill
   - summary pill
   - metric tile
   - section panel

2. Audit and migrate the remaining local `ChoiceChip` / `ActionChip` / `Chip` usage to shared wrappers instead of one-off conversions.

3. Add a small developer-facing preview/demo page that renders each surface family across:
   - card
   - panel
   - pill
   - feature tile
   - navigation bar
   - dense sanctuary

4. Add widget tests for the surface matrix so future theme changes cannot quietly remove the intended Noor / midnight / no-glass behaviors.

5. Decide whether `Noor Glass` should stay a family name even though it is now visually more premium-solid than translucent, or whether the product-facing naming should be adjusted later while keeping the technical family stable.

6. Add a future `accent-colorway` layer only after the shared wrappers are more complete. That is the right place to support broad recolor requests such as red, emerald, or sapphire without redoing page QA from scratch.
