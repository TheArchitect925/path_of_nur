# Release Version Bump Backlog

Date: 2026-04-11

## Enhancement options

1. Add a small scripted release check that verifies `pubspec.yaml`, iOS project versions, and Android signing readiness before every release cut.
2. Move Android release keystore validation into a clearer preflight task so `flutter build appbundle --release` fails earlier with a friendlier checklist.
3. Add a lightweight release notes template keyed off the new app version so each bump has a matching rollout summary.
