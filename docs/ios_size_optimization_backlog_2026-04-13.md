# iOS Size Optimization Backlog

Last updated: 2026-04-13

## Current Local Snapshot

- Release iOS app bundle: about `200 MB`
- Main Flutter payload: `build/ios/Release-iphoneos/Runner.app/Frameworks/App.framework` at about `172 MB`
- Bundled Flutter assets: about `112 MB` under `flutter_assets/assets`

## Biggest Size Drivers

1. `assets/images/prophets/` about `65 MB`
2. `assets/images/backgrounds/` about `43 MB`
3. `assets/images/wudu/` about `26 MB`
4. `assets/audio/` about `8.4 MB`
5. `assets/icons/` about `3.8 MB`
6. iOS asset catalog `Assets.car` about `8.1 MB`

## Recommended Enhancements

1. Recompress large PNG hero/background images into lower-weight WebP where Flutter rendering and visual quality remain acceptable.
   Expected impact: high
   Notes: prioritize `assets/images/backgrounds/*`, `assets/images/prophets/*`, and `assets/images/wudu/*`

2. Resize oversized raster assets to their real maximum display size before bundling.
   Expected impact: high
   Notes: several images are multiple megabytes and likely exceed in-app render dimensions

3. Audit unused bundled assets and remove anything not referenced by the shipped app.
   Expected impact: high
   Notes: broad asset directory registration in `pubspec.yaml` can keep legacy media bundled

4. Split heavy optional educational image sets from launch-critical surfaces and load them on demand from local seed packs or a later downloadable content path.
   Expected impact: high
   Notes: good candidates are prophet story art and step-by-step visual lesson packs

5. Optimize iOS app icon and asset catalog source images before regeneration.
   Expected impact: medium
   Notes: `Assets.car` is unusually large at about `8.1 MB`

6. Review whether both static and variable Arabic font files need to ship together.
   Expected impact: low to medium
   Notes: current bundle includes regular Arabic fonts plus variable font files in assets

7. Remove or downsample any duplicated audio variants that do not meaningfully improve the user experience.
   Expected impact: low to medium
   Notes: adhan and salah clips are not the main driver, but there is still room to trim

8. Run Flutter size analysis on the AOT snapshot to identify code/package weight beyond media assets.
   Expected impact: medium
   Notes: helps quantify plugin/framework and Dart code contribution after asset cleanup

## Suggested Execution Order

1. Asset usage audit
2. Background/prophet/wudu image recompression and resizing
3. iOS icon catalog optimization
4. Font duplication audit
5. Flutter code-size analysis

## Notes

- This backlog is intentionally implementation-focused and does not change core architecture.
- Any future user-facing content changes should stay localization-ready, but this size pass itself is mostly media and build-output work.
- Search/indexing impact: none unless content packaging is later moved to an on-demand system.
