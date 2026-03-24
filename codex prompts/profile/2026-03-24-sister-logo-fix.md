===== PHASE 1 PROMPT — SISTER LOGO FIX =====

PRIMARY OBJECTIVE === BUILDING SISTER PROFILE LOGO FIX

You are working in the existing Flutter codebase for “Path of Nūr”.

TASK TYPE:
Targeted bug fix + asset resolution hardening.

CRITICAL RULE:
Do NOT let the system go haywire.
Do NOT delete or remove records, profile data, or unrelated logic.
Do NOT rebuild systems — only fix and stabilize.

--------------------------------------------------

ISSUE:
When user is set as “Sister”, the logo does NOT show.

Known asset:
assets/icons/sisterlogo.png

--------------------------------------------------

EXECUTION PLAN

A. AUDIT FIRST (NO CHANGES YET)

Find:
- where user gender/profile is stored
- how “Sister” is represented (string, enum, etc.)
- where logo/icon is resolved
- where Image.asset is used
- any asset helper/service/constants
- pubspec.yaml asset registration

Identify root cause:
- wrong path
- missing asset registration
- case mismatch
- incorrect mapping (female vs sister)
- fallback overriding correct value
- widget rendering wrong branch

--------------------------------------------------

B. FIX ROOT CAUSE (MINIMAL CHANGE)

Implement ONLY the necessary fix:

Ensure correct mapping:
assets/icons/sisterlogo.png

Fix:
- mapping logic (string/enum mismatch)
- incorrect path
- pubspec.yaml registration
- wrong conditional branch

Do NOT introduce hacks or duplicate logic.

--------------------------------------------------

C. HARDEN ASSET RESOLUTION

If mapping is fragile:

Create ONE clear source of truth:

Example:
const String sisterLogo = 'assets/icons/sisterlogo.png';

Optional helper:
String resolveUserLogo(String gender) {
  switch (gender.toLowerCase()) {
    case 'sister':
      return sisterLogo;
    case 'brother':
      return 'assets/icons/brotherlogo.png';
    default:
      return 'assets/icons/defaultlogo.png';
  }
}

Ensure:
- no duplicated mappings
- no silent failures

--------------------------------------------------

D. VERIFY ASSET REGISTRATION

Check pubspec.yaml:

flutter:
  assets:
    - assets/icons/

Fix indentation if needed (YAML is strict).
Ensure assets folder is at project root.

IMPORTANT:
Run:
flutter pub get

If needed:
flutter clean

Common issue:
incorrect path or indentation prevents assets from loading

--------------------------------------------------

E. FIX RENDERING SAFELY

Where logo is rendered:

Use:
Image.asset(
  resolveUserLogo(user.gender),
  fit: BoxFit.contain,
  errorBuilder: (context, error, stackTrace) {
    return Image.asset('assets/icons/defaultlogo.png');
  },
)

Ensure:
- Sister case hits correct branch
- fallback only used if truly invalid

--------------------------------------------------

F. VALIDATE ALL SURFACES

Confirm logo works in:
- onboarding
- profile/settings
- homepage header
- any avatar/logo usage

Confirm NO regressions for:
- Brother
- default users

--------------------------------------------------

G. CLEANUP (SAFE ONLY)

Remove ONLY:
- clearly dead/duplicate mapping logic
- conflicting constants

Do NOT remove:
- working logic
- unrelated files

--------------------------------------------------

VALIDATION CHECKLIST

- Sister logo renders correctly
- Path resolves to:
  assets/icons/sisterlogo.png
- pubspec.yaml is correct
- no regression for Brother/default
- no duplicate mapping logic remains
- analyzer passes

--------------------------------------------------

DELIVERABLES

1. Files changed
2. Root cause
3. Fix implemented
4. Validation results

FINAL AUDIT SUMMARY:
- what was broken
- what was fixed
- remaining risks (if any)
- confirmation system is stable for launch

--------------------------------------------------

SUCCESS CRITERIA

User = Sister → correct logo shows everywhere consistently

--------------------------------------------------

“Indeed, Allah does not look at your forms… but your hearts and deeds.”
(Sahih Muslim)

===== END =====
