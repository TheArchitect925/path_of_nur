# Theme System and Kids Letters Cleanup Backlog

Date: 2026-03-19
Topic: shared Kids/Adult visual system follow-up

## Next Enhancement Options

- Migrate remaining raw fallback states in Growth detail pages onto `AppPageScaffold` so empty and unavailable states do not visually drift.
- Replace repeated kids warm-surface card decorations in the Kids Arabic pages with one small shared kids surface helper.
- Audit the remaining Qur'anic Arabic section strings and card treatments so the whole section matches the shared adult shell as tightly as the migrated pages do now.
- Add a lightweight UI regression pass for chevron removal on tappable cards so future cleanup work does not reintroduce trailing arrows by habit.

## Notes

- This pass intentionally kept the migration narrow and shell-focused.
- Intentional immersive exceptions should stay explicit rather than quietly reintroducing page-local theme systems.
