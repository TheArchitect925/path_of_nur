# Pill Unification Backlog

## Remaining semantic/control exceptions
- `lib/shared/widgets/segmented_pill_control.dart`: keep as a segmented control, but align any remaining internal visual drift with the shared pill base if needed.
- Selection/filter chips that carry state semantics should stay control widgets rather than being replaced blindly with action buttons.

## High-value follow-up conversions
- Home and Salah page pill-style action buttons that still use local layouts.
- Worship selection pills that should share the base pill shell while preserving selected-state behavior.
- Remaining journey, celestial, and kids lesson meta pills that still own local color/fill rules.

## Potential improvement
- Add a small shared selected-state wrapper on top of `AppLayeredGlassPill` for choice pills so selected/unselected controls stop reimplementing color logic page by page.
