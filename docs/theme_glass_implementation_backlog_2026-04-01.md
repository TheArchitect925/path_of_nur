# Theme Glass Implementation Backlog — 2026-04-01

This backlog prepares the winning glass style rollout without inventing a parallel theme system.

## Phase A — Cleanup Before Final Style

### 1. Remove stale preview-path references
- Reason: old docs still mention the deleted `glass_preview` folder and can mislead the rollout pass.
- Priority: high
- Likely files:
  - `docs/home_glass_preview_islands_2026-04-01.md`
  - any related memory/docs referencing `lib/features/home/presentation/glass_preview/`

### 2. Decide removal timing for the temporary homepage comparison section
- Reason: the comparison section is useful for selection, but it should not coexist indefinitely with the final implementation.
- Priority: high
- Likely files:
  - `lib/features/home/presentation/home_page.dart`
  - `lib/features/home/presentation/glass_variants/home_glass_variant_islands_section.dart`

### 3. Confirm legacy `calmBeautiful` handling
- Reason: the enum still exists, but runtime settings remap it to `defaultMode`, which can confuse QA and rollout logic.
- Priority: medium
- Likely files:
  - `lib/core/theme/app_theme.dart`
  - `lib/features/profile/application/profile_settings_provider.dart`

## Phase B — Core Shared Surface Implementation

### 4. Implement the winning glass treatment centrally in shared surfaces
- Reason: this is the main reuse point for cards, islands, pills, panels, and nav-family surfaces.
- Priority: high
- Likely files:
  - `lib/core/theme/app_surfaces.dart`
  - `lib/core/theme/app_theme.dart`

### 5. Tune shared glass tokens per theme mode
- Reason: the winning variant must behave correctly in `defaultMode`, `easyRead`, `dark`, `noorGlass`, and `midnightManuscript`.
- Priority: high
- Likely files:
  - `lib/core/theme/app_theme.dart`

### 6. Adjust background interplay only if needed
- Reason: the final glass look may require coordinated background tint/glow behavior, but this should stay centralized.
- Priority: medium
- Likely files:
  - `lib/core/theme/app_backgrounds.dart`
  - `lib/shared/widgets/global_background.dart`

### 7. Decide whether liquid glass is truly needed
- Reason: the in-house surface system may already be sufficient; true liquid rendering should be used only if it adds clear value.
- Priority: medium
- Likely files:
  - `lib/shared/widgets/noor_liquid_glass.dart`
  - `lib/shared/widgets/premium_card.dart`
  - `lib/core/theme/app_surfaces.dart`

## Phase C — Page-Level Harmonization

### 8. Harmonize homepage local warm-glass overrides against the shared system
- Reason: homepage currently adds the heaviest local styling on top of shared surfaces.
- Priority: high
- Likely files:
  - `lib/features/home/presentation/home_page.dart`
  - `lib/core/theme/app_surfaces.dart`

### 9. Reconcile Learn category islands with the winning shared treatment
- Reason: Learn islands are one of the best real shared test surfaces and already use the island variant.
- Priority: high
- Likely files:
  - `lib/features/learn/presentation/widgets/learn_category_card.dart`
  - `lib/shared/widgets/section_hub_scaffold.dart`

### 10. Audit shell navigation chrome after shared surface rollout
- Reason: the shell currently uses shared nav surface resolution plus local icon/fill/glow logic.
- Priority: medium
- Likely files:
  - `lib/shared/widgets/app_scaffold.dart`

### 11. Check Qur'an feature-local palette compatibility
- Reason: Qur'an summary pages use a feature-specific palette layer that must still feel coherent after the global shift.
- Priority: medium
- Likely files:
  - `lib/features/learn/quran/presentation/quran_summary_theme.dart`
  - `lib/features/learn/presentation/pages/quran_app_hub_page.dart`

### 12. Audit Salah page for post-rollout drift
- Reason: Salah still owns strong local appearance behavior and may remain visually disconnected if left untouched.
- Priority: medium
- Likely files:
  - `lib/features/salah/presentation/salah_page.dart`

## Phase D — QA / Regression Checks

### 13. Validate appearance settings behavior end to end
- Reason: glass/background/contrast toggles must still flow through the same runtime path.
- Priority: high
- Likely files:
  - `lib/app/app.dart`
  - `lib/features/profile/application/profile_settings_provider.dart`
  - `lib/features/profile/presentation/settings_page.dart`

### 14. Add shared surface regression tests
- Reason: future token changes should not silently break cards, islands, or nav-family surfaces.
- Priority: high
- Likely files:
  - `lib/core/theme/app_surfaces.dart`
  - `lib/shared/widgets/premium_card.dart`
  - `lib/shared/widgets/section_hub_scaffold.dart`
  - `lib/shared/widgets/app_scaffold.dart`

### 15. Run focused visual QA on key modes and surfaces
- Reason: the final style must remain readable in:
  - default light
  - Noor Glass
  - Midnight Manuscript
  - Dark
  - large text
  - disabled background
  - disabled transparency
- Priority: high
- Likely files:
  - no code change required unless issues are found

### 16. Remove the temporary homepage comparison section after verification
- Reason: final rollout should not leave demo code behind.
- Priority: high
- Likely files:
  - `lib/features/home/presentation/home_page.dart`
  - `lib/features/home/presentation/glass_variants/home_glass_variant_islands_section.dart`

## Recommended Rollout Order

1. Cleanup stale preview references and decide demo-section timing.
2. Implement the winning shared surface behavior.
3. Tune shared theme/background interplay.
4. Validate shared cards and Learn islands.
5. Harmonize homepage.
6. Harmonize nav shell if needed.
7. Audit Qur'an and Salah compatibility.
8. Remove temporary comparison code.

## Notes

- Do not create a new parallel theme system.
- Do not spread `liquid_glass_renderer` imports across feature pages.
- Keep settings ownership in the existing profile settings flow.
- Prefer central rollout before page-local restyling.
