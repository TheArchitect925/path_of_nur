# Onboarding Age Range Cleanup Enhancements

- Consider renaming the underlying `OnboardingAgeRange` enum values in a dedicated migration pass if you want the stored names to match the user-facing bands.
- Audit any analytics or export/reporting code that may later surface raw onboarding enum names so they do not leak the legacy band naming.
- If profile settings later expose the same four visible age bands, add a single shared converter/helper to avoid drift between onboarding labels and settings labels.
