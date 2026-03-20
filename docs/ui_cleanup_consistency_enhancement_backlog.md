# UI Cleanup Consistency Enhancement Backlog

1. Replace remaining hardcoded English strings in the Qur'an and World landing hubs with localized keys so the cleaned surfaces match the rest of the app's localization coverage.
2. Add a small persisted preference for the Learn/Qur'an shortcuts dock if you want it to remember expanded state after repeated use.
3. Add focused widget tests for the Learn shortcuts dock collapsed/expanded behavior and the World explore action grid under larger text scaling.
4. Review the remaining Home search copy that still references the old overview language and tighten it to the simplified homepage structure.
5. If final Islamic icon mapping evolves, audit additional Learn tools and stage surfaces for icon consistency beyond the island cards.

- Add a compact one-tap date picker on the Home Salah card so users can jump farther than yesterday/tomorrow without opening the full Worship prayer calendar.
- Consider reusing the persisted prayer calendar display preference inside the Worship prayer date picker sheet so Home and Worship always open in the same calendar mode by default.
- Audit feature-local `AppColors.onSurface` / `AppColors.onSurfaceSubtle` usage inside `PremiumCard`-based screens so the new shared glass contrast tokens can cover the last hardcoded in-card text colors without widget-by-widget restyling.
