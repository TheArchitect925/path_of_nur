# Unified Real iOS Glass Follow-up

Date: 2026-04-07

1. Audit standalone `AppHeroGlassShell` consumers on Learn and History to decide which should stay primary-glass cards and which should step down to the new panel level for calmer hierarchy.
2. Review `quran_quote_block.dart` separately because Qur'an quote surfaces are intentionally special, but they should still avoid nested primary-glass children around supporting metadata.
3. Run real-device QA on Home, Learn, Worship, and Qur'an with the mini player visible to confirm the clipped blur remains stable during fast scrolling and page transitions.
4. Evaluate whether the bottom app nav should also move from its current hero-shell usage onto the navigation-bar preset in the unified renderer for even tighter consistency.
