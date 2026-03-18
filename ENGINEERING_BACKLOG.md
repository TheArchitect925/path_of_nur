# Engineering Backlog

Last updated: 2026-03-17

- Add a simulator startup smoke test that covers the Learning Journey home so launch-time integration regressions are caught before manual `flutter run`.
- Add a widget test for Continue Journey, Today’s Light, and stage completion state on the new Learning Journey surfaces.
- Investigate the non-fatal simulator log `This FlutterEngine was already invoked.` and confirm whether it is caused by a plugin bootstrap path or an expected duplicate engine warm-up.
