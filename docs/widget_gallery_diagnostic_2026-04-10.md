# Widget Gallery Diagnostic

Date: 2026-04-10

## Findings

- The `PathOfNurHomeWidgets` extension is embedded in the installed simulator app bundle.
- The embedded extension bundle id is `com.shahab.pathOfNur.homewidgets`.
- The extension plist declares `com.apple.widgetkit-extension` correctly.
- The extension executable exists in the installed `.appex` bundle.
- The app group container resolves successfully for `group.com.pathofnur.watch`.
- A clean uninstall/reinstall still preserves the embedded widget extension.

## Likely remaining cause

- The remaining issue is likely WidgetKit gallery / simulator state or using the wrong add flow for lock screen widgets rather than missing widget target wiring.

## Follow-up options

1. Reboot the simulator and retry widget gallery enumeration.
2. Validate on a real iPhone, since simulator widget gallery behavior can be flaky.
3. If the issue persists, inspect SpringBoard / WidgetKit enumeration logs during the exact add-widget action.
