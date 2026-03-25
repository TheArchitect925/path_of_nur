# Release Versioning Backlog

- Confirm whether watch and tvOS target version metadata should be explicitly bumped in the same pass as Runner for the next release cut.
- Add a small preflight check that compares `pubspec.yaml` and iOS project marketing/build versions so release bumps cannot drift again.
- Consider a scripted release-version bump helper if version updates continue happening manually across multiple Apple targets.
