# Non-Home Bottom Overlay Clipping Backlog

Date: 2026-03-31

## Completed in this pass

- Added a reusable `PageLayoutConfig` to the shared non-Home page scaffold path.
- Switched the shared non-Home scaffold body to manual bottom-nav inset handling with `SafeArea(bottom: false)` so bottom spacing is controlled in one place.
- Clipped page-owned `GlobalBackground` layers for standard pages so they stop before the bottom-nav area instead of bleeding behind it.
- Left Home untouched; it still owns its existing immersive layout outside the shared scaffold path.

## Follow-up enhancement options

- Run a focused simulator/device QA pass on `Qur'an`, `Learn`, `Worship`, and `Growth` roots to confirm the new manual inset and clipped background feel correct on devices with and without a home indicator.
- If any non-Home page still needs a stronger immersive treatment later, opt it into `PageLayoutConfig.immersive` explicitly instead of changing the shared standard behavior.
- Add a small widget regression test around `AppPageScaffold` standard mode so future shell tweaks do not reintroduce bottom overlap or background bleed.
