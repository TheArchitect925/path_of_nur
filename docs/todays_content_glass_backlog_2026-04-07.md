# Today's Content Glass Backlog

Date: 2026-04-07
Area: Home / Today's Content

## Enhancement options

- Add a shared, non-theme helper for the loading-screen glass spec so Home, Learn, Journey, and other curated hero surfaces can reuse one exact config without copy-pasting shell parameters.
- Audit inner spacing on smaller phones now that the Home Today cards use the larger loading-screen padding, and tighten only if any card starts feeling vertically heavy.
- Review whether the Home Today `ExpansionTile` should keep its default expand/collapse motion or switch to a lighter interaction to reduce layered-glass flicker during open/close.
- If we continue this treatment elsewhere, apply it route-by-route instead of globally so we preserve surface hierarchy and avoid flattening all cards into the same visual weight.

## Visual bug note

- Home `Today's Content` should keep one outer `AppHeroGlassShell` and avoid nesting additional hero-shell cards inside it.
- Nested hero glass on the Home ayah/recommendation cards caused visible tint mismatch bands and more obvious flashing while scrolling because multiple liquid-glass layers were compositing against each other.
