# Home vs Shared Page Background Audit Backlog

Date: 2026-03-31

## Audit conclusion

- Home is structurally different from the other root pages because it does not use `AppPageScaffold`.
- The shell-level wallpaper in `AppShellScaffold` predates today's work and was not introduced by today's fixes.
- The most likely regression introduced today was changing `AppPageScaffold` to stop always rendering its own `GlobalBackground`, which changed the established shared-page visual layering.

## Completed in this pass

- Restored the original shared-page background rendering behavior in `AppPageScaffold`.
- Kept the separate bottom-scroll clearance fix because it is unrelated to the background regression.

## Enhancement options

- If the shared pages still need refinement after this restore, compare opacity/contrast at the card level instead of changing background ownership again.
- Add a lightweight visual regression checklist for Home versus shared-root pages before future shell/scaffold changes.
