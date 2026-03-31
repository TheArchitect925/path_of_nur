# Revert Full-Viewport Fill Restore Content Backlog

Date: 2026-03-31

## Completed in this pass

- Reverted the shared `AppPageScaffold` body from the experimental `LayoutBuilder -> ConstrainedBox -> IntrinsicHeight` structure back to the stable `ListView` content tree.
- Preserved the existing shell/background ownership behavior from the earlier fix.
- Replaced the previous oversized bottom reserve with a tighter reserve based on the visible bottom bar height plus small breathing room.

## Follow-up enhancement options

- Run one simulator/device visual QA sweep on `Learn`, `Growth`, `Worship`, and `Qur'an` hub to confirm content is fully visible again and the lower remainder is acceptable on smaller iPhones.
- If a specific root page still feels too short after this rollback, address that page with page-owned content composition rather than another shared full-viewport experiment.
- Add a focused widget/regression test around `AppPageScaffold` so future shell passes do not reintroduce the collapsed shared-body behavior.
