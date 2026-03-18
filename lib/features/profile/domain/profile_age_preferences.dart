enum ProfileAgeRange { child, teen, adult }

enum KidsUiThemeMode { auto, on, off }

bool resolveKidsUiThemeEnabled({
  required ProfileAgeRange ageRange,
  required KidsUiThemeMode mode,
}) {
  switch (mode) {
    case KidsUiThemeMode.auto:
      return ageRange == ProfileAgeRange.child;
    case KidsUiThemeMode.on:
      return true;
    case KidsUiThemeMode.off:
      return false;
  }
}
