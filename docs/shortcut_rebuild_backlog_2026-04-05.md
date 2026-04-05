# Shortcut Rebuild Backlog

Date: 2026-04-05

## Completed in this pass
- Removed live shortcut pill/dock usage from the main pages:
  - Home
  - Learn
  - Worship
  - Growth
  - Qur'an hub
- Left the shared shortcut infrastructure in place so a replacement system can be rebuilt cleanly without reintroducing the current issues.

## Rebuild goals
- Reintroduce shortcuts with a simpler ownership model
- Avoid floating overlay semantics issues on Home
- Standardize behavior before styling
- Validate layout on small screens and long localized labels
- Prefer page-owned static placements before reintroducing animated/floating docks

## Suggested next steps
1. Define the new shortcut information architecture: which pages should have shortcuts and how many.
2. Decide whether shortcuts should be inline cards, a compact action row, or a bottom utility tray.
3. Build one replacement implementation on Home first and QA it before rolling out to Learn/Worship/Growth/Qur'an.
4. Add widget coverage for layout and tap behavior before broad rollout.
