# Localization Phase 9 Enhancement Backlog

Date: 2026-03-31

## High-value next improvements

- Replace the broad same-as-English fallback that still remains in many non-English locales now that the structural missing-key debt has been cleared.
- Prioritize real translations for the highest-visibility active keys in `app_ar.arb`, `app_hi.arb`, `app_id.arb`, `app_tr.arb`, `app_bn.arb`, `app_fa*.arb`, `app_ha.arb`, `app_ku.arb`, `app_ms.arb`, `app_pa.arb`, `app_ps.arb`, and `app_tg.arb`.
- Add a small localization integrity script to report both `missing` and `same-as-English` counts per locale so future parity sweeps are easier to target.
- Review whether some stable Islamic terms should intentionally remain cross-locale, and document that policy so they are not repeatedly counted as debt.
- Run a final release-facing manual spot check on the highest-traffic localized surfaces after Phase 10, especially FAQ, Learn landing, Qur'an helper pages, Salah helper pages, and kids/family wrappers.
