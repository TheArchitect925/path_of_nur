# Global Container Glass Backlog

Date: 2026-04-07
Area: Shared surfaces / app-wide container unification

## Enhancement options

- Extract a single shared `loadingScreenGlassShellSpec` helper so `AppHeroGlassShell`, `AppLayeredSectionGlassCard`, and future shell-like containers all read from one exact source of truth.
- Split `NoorGlassCard` into two clearer responsibilities:
  - section/card surfaces that should align with `AppHeroGlassShell`
  - pill/button surfaces that intentionally stay lighter and separate
- Add a small audit script that reports shared surface wrapper usage counts so future UI passes can measure whether new pages are staying on the canonical container path.
- Run a visual QA pass on Home, Learn, Journey, Qur'an, Settings, Celestial, and Salah after any shared `NoorGlassCard` refactor, because those are the most likely places where nested inner panels may still need intentional divergence.
