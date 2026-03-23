# translate_arb.py Backlog

Date: 2026-03-23

## Completed in this pass

- Added [tools/translate_arb.py](/Users/shahabmansoor/Developer/path_of_nur/tools/translate_arb.py) as a repo-local OpenAI-backed ARB translation helper.
- Made the script safe to keep in the repo even when `openai` is not installed locally by using a runtime import instead of a top-level hard dependency.
- Verified:
  - `python3 -m py_compile tools/translate_arb.py`
  - `python3 tools/translate_arb.py --help`

## Current limitation

- The script is present and runnable, but this environment does not currently have the `openai` Python package installed.
- Actual translation runs also require `OPENAI_API_KEY`.

## Enhancement options

1. Add a `--resume-existing` mode so existing structurally valid locale entries can be reused instead of retranslating entire files.
2. Add a `--validate-only` mode that runs key and placeholder checks without calling the API.
3. Add temp-file output support so generated translations can be reviewed before replacing canonical locale files.
4. Add explicit ICU-message handling tests for plural/select/selectordinal strings.
5. Add a wrapper script that combines `translate_arb.py`, `localization_validate.py`, `flutter gen-l10n`, and `flutter analyze` into one controlled workflow.
