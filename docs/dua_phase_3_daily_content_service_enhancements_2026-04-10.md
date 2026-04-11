# Dua Phase 3 Enhancements

Date: 2026-04-10

## Recommended next steps

1. Connect the new daily dua bundle into the existing Dua hub daily tab so the app stops using the current local random picker.
2. Add explicit post-salah and prayer-boundary callers from existing worship flows so `after_salah` and `before_salah` contexts can be passed intentionally instead of inferred loosely.
3. Add a tiny caller-owned weather bridge only if a stable repo-wide weather signal already exists; keep weather optional otherwise.
4. Introduce a dedicated surfaced-history state for displayed daily duas if product QA shows `recentIds` from detail-page opens is too indirect for long-term rotation.
5. Add one lightweight debug panel or developer log view for selection reasons so future widget/watch work can validate ranking behavior quickly.
6. Add bundle-shaping rules for richer in-app use, such as preferring one primary contextual dua plus one general trusted fallback instead of simply taking the top N.
7. Add a future-safe compact prompt formatter for widget/watch surfaces once a consumer is ready, instead of letting each surface compress translations differently.
8. Consider a `preferredTrustFloor` policy object if future surfaces need different trust rules, for example `verified_strong` only on watch and lock screen but `verified_general` allowed in app.
9. Add a small dedicated test for Ramadan and Friday provider-derived context so the auto-built selection context stays stable if prayer/date logic changes later.
10. If product wants stronger Laylat al-Qadr surfacing later, pass that signal explicitly from a dedicated Islamic-date policy instead of inferring it too aggressively from the date alone.

## Non-blocking notes

- The current service intentionally does not auto-infer `after_salah` because the repo’s available prayer context is better at current/next windows than completed-prayer moments.
- Weather remains caller-driven by design unless a stable weather source is introduced.
- No UI strings were added in this phase, so localization was intentionally untouched.
