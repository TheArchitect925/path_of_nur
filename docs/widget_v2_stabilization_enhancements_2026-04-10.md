# Widget V2 Stabilization Enhancements

## Recommended Follow-Ups

1. Run `pod install` in `ios/` and re-run the workspace build to clear the current CocoaPods sandbox sync blocker.
2. Add localized translations for the new spiritual widget strings in non-English `.arb` files once copy is approved.
3. Add a small native preview file or snapshot test coverage for the new spiritual widgets so layout regressions are easier to catch.
4. Consider splitting `PathOfNurHomeWidgets.swift` into smaller view files after the build is green to keep the extension bundle easier to maintain.
5. Add one workspace build check for `PathOfNurHomeWidgets` to CI so future Flutter payload additions stay in sync with the native widget bundle.
