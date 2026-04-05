# Home Surface Harmonization Backlog — 2026-04-02

## Next visual QA options

### Tighten Home sacred quote parity further
- Reason: Home now uses the shared `QuranQuoteBlock`, but we may still want to tune spacing, scale, or interaction feel once visual QA comes back.
- Priority: high
- Files likely involved:
  - `lib/features/home/presentation/home_page.dart`
  - `lib/shared/widgets/quran_quote_block.dart`
  - `lib/shared/widgets/quran_sacred_block_chrome.dart`

### Decide whether Home feature cards should keep distinct accent atmospheres
- Reason: `On This Day` and `Celestial Cycle` now use shared Frosted Glass instead of `homepageWarmGlass`, but their inner accent layers may still be tuned further after QA.
- Priority: high
- Files likely involved:
  - `lib/features/history/presentation/widgets/on_this_day_home_card.dart`
  - `lib/features/celestial/presentation/widgets/celestial_cycle_card.dart`

### Review remaining local Home micro-surfaces
- Reason: the biggest structural Home drift is fixed, but smaller icon containers, chips, and welcome-card internals may still be worth tightening later if they feel off in QA.
- Priority: medium
- Files likely involved:
  - `lib/features/home/presentation/home_page.dart`

### Tune global Qur'an sacred glow strength
- Reason: the shared floating golden glow is now centralized for `QuranQuoteBlock` and `QuranReferenceBlock`, so future QA adjustments should happen there rather than per page.
- Priority: high
- Files likely involved:
  - `lib/shared/widgets/quran_sacred_block_chrome.dart`
  - `lib/shared/widgets/quran_quote_block.dart`
  - `lib/shared/widgets/quran_reference_block.dart`

### Tune Qur'an sacred gold palette balance
- Reason: the shared sacred chrome now uses sanctuary ivory-gold, champagne gold, and antique-gold shadow tint, so follow-up QA may call for warmer, brighter, or calmer balancing.
- Priority: high
- Files likely involved:
  - `lib/shared/widgets/quran_sacred_block_chrome.dart`

### Continue Qur'an hub harmonization
- Reason: the main ayah-focused cards and shared verse preview are now harmonized, but `QuranAppHubPage` still has custom Qur'an summary/theme/pathway island cards and companion recommendation surfaces that may deserve a second pass after QA.
- Priority: high
- Files likely involved:
  - `lib/features/learn/presentation/pages/quran_app_hub_page.dart`
  - `lib/features/learn/presentation/pages/learn_quran_hub_page.dart`
  - `lib/features/learn/quran/presentation/quran_summary_theme.dart`

### Review Qur'an hub intent/tool utility cards after sacred pass
- Reason: the sacred navigation and companion cards are now aligned more closely with Dense Sanctuary, so the next likely contrast question is whether the intent/tool utility cards should remain Frosted for balance or move closer to the Qur'an-specific visual family.
- Priority: medium
- Files likely involved:
  - `lib/features/learn/presentation/pages/quran_app_hub_page.dart`

## 2026-04-03 Today's Content follow-up options
- Let the new Home `Today's content` section remember its expanded/collapsed state locally if you want it to reopen the way the user left it.
- Add a small count or status summary to the collapsed row, such as how many items are available today.
- If the inner stack feels long, split the section visually into `Qur'an today` and `Learning today` subsections while keeping one parent accordion.
- Decide whether the Home next-salah card should keep the temporary Option 1 vs 2 comparison or promote the winning treatment into a reusable shared utility-card pattern.
- The Home next-salah card now uses the chosen `Noor Glass` default treatment as the single runtime version. Future visual tweaks should apply to that default card directly.

## 2026-04-03 Home Noor Glass rollout follow-up options
- Promote the new `NoorGlassCard` wrapper into the next reusable Home hero card families if the full homepage visual QA feels successful.
- Tune accent preservation on the prayer timing pills if any individual salah color feels too muted once viewed across different wallpaper/background combinations.
- Decide whether the remaining nested Home micro-surfaces should stay on `NoorLiquidGlassMode.fake` for safety or whether a few high-value hero surfaces deserve real liquid glass.
- Consider extracting the finalized Home next-salah `Noor Glass` structure into a shared widget if the Salah page is going to reuse the same presentation later.
