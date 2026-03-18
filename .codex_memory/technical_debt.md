# Technical Debt

Last updated: 2026-03-17

## Highest-friction debt

1. Learn information architecture overlap
2. localization debt on active surfaces
3. route sprawl with compatibility aliases and mixed ownership
4. content verification / placeholder quality variance
5. limited automated coverage relative to app scope

## Specific unfinished seams

- Settings and Accounts Sync still contain many hardcoded strings.
- `/learn`, `/learn/legacy`, `/learn/hub/*`, and `/quran*` overlap in user-facing ownership.
- Journey registry and lesson system are more mature than before, but some paths still rely on transitional mapping notes or legacy related-tool links.
- Dua system intentionally mixes complete and stub content.
- Watch/tv/macos release claims are not aligned to code presence yet and must continue following docs.
- Root README is still boilerplate and hides the actual product shape.

## Technical caution areas

- dirty working tree: treat unrelated edits as user-owned
- localization generation: avoid breaking generated l10n flow
- route migrations: preserve aliases when they still protect existing deep links
- sync copy/claims: keep local-first posture accurate
