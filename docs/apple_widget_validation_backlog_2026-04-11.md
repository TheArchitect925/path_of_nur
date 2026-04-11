# Apple Widget Validation Backlog

Date: 2026-04-11
Task: Fix App Store validation issue for `PathOfNurHomeWidgets`

## Enhancement options

1. Add a repeatable repo-side validation command that checks widget/watch extension version alignment in `ios/Runner.xcodeproj/project.pbxproj` before archive.
2. Add a small Apple-target audit script that verifies Swift extension targets include the expected `@main` entrypoint patterns before release validation.
3. Capture one fresh signed archive validation note after this fix so the repo has proof that the widget extension now passes App Store validation.
