# Assets Structure

Use this directory for all bundled app resources.

## Folders

- `assets/images/backgrounds/`: page and scene backgrounds.
- `assets/images/avatars/`: profile and character images.
- `assets/images/illustrations/`: decorative and feature illustrations.
- `assets/icons/`: custom PNG/SVG icon assets.
- `assets/audio/ambient/`: loops like rain, birds, nature.
- `assets/audio/effects/`: clicks, confirmations, small UI sounds.
- `assets/video/`: local video clips.
- `assets/animations/lottie/`: `.json` lottie files.
- `assets/animations/rive/`: `.riv` animation files.
- `assets/fonts/`: custom font files (if added, also register under `flutter.fonts` in `pubspec.yaml`).
- `assets/data/`: static JSON/text seed files.

## Naming Convention

Use lowercase snake_case and short semantic names.

Examples:
- `assets/images/backgrounds/home_mist_v1.jpg`
- `assets/audio/ambient/garden_birds_loop.mp3`
- `assets/icons/quran_outline.png`

## Notes

- Keep source files optimized (compressed images/audio).
- Prefer reusable shared assets over duplicated files.
- For large media, consider remote hosting if app size becomes too large.
