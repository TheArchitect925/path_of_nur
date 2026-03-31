# Empty Viewport Gap Above Bottom Nav Backlog

Date: 2026-03-31

## Completed in this pass

- Replaced the shared `AppPageScaffold` body `ListView` with a viewport-aware `LayoutBuilder -> SingleChildScrollView -> ConstrainedBox(minHeight) -> IntrinsicHeight -> Column` composition.
- Kept the existing bottom-nav reserve intact while making short-content main pages fill the available viewport height before the floating bottom/nav area.
- Left the background system unchanged in this pass.

## Follow-up enhancement options

- Run one simulator/device QA sweep on `Learn`, `Worship`, `Growth`, and `Qur'an` roots to confirm the shorter-page composition looks intentional on small and tall iPhones.
- If any page still feels visually top-heavy after the structural fix, adjust that page's own section ordering or card grouping rather than reworking the shared shell again.
- Consider a focused widget test around `AppPageScaffold` short-content layout so future shell work does not reintroduce the unused-viewport gap.
