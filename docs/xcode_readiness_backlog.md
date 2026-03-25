# Xcode Readiness Backlog

- Reduce third-party Apple build warnings from CocoaPods packages such as `share_plus`, `flutter_tts`, `camera_avfoundation`, `audio_service`, and `sign_in_with_apple` when dependency upgrades are safe.
- Decide whether the extra dark/universal app icon files in `ios/Runner/Assets.xcassets/AppIcon.appiconset` should be fully assigned or intentionally pruned in a dedicated asset-cleanup pass.
- Add a small documented Xcode local workflow note that uses a real installed simulator identifier instead of assuming `OS=latest`, since local simulator inventories can drift between Xcode versions.
- Investigate whether `build/ios/Debug-iphonesimulator` should be cleaned automatically before some Xcode builds to reduce the recurring “stale file outside allowed root paths” warnings.
