# Claude instructions for the Path of Nur repo

## Smoke tests → MCSnow (write at the end of every shipping session)

**Obligation.** At the end of any session that ships a user-testable change (a new screen / RPC / flow, or a bug fix with an observable outcome — skip pure refactors/renames), update **`SMOKE_TESTS.md`** (repo root) so the work can be imported into the **MCSnow** app as **epics → stories → smoke test cases** (then assigned to users/customers to run; progress + feedback feed the AIOPS module). **Append** rows; **never renumber** existing IDs.

**This project:** `product=path-of-nur`, ID prefix `key=PON`.

**Format.** Top of file:
```
# Path of Nur — Smoke Tests
<!-- mcsnow-import: product=path-of-nur; key=PON; mode=full -->
```
Then `## Backlog` (two tables) + a `## Smoke Tests` table:
```
## Backlog
### Epics
| Epic ID | Title | Status |            (status: proposed|in_progress|done|cancelled)
| PON-E-<slug> | … | done |
### Stories
| Story ID | Epic ID | Title | Points | Status |   (status: backlog|ready|todo|in_progress|in_review|blocked|done|cancelled)
| PON-S-<slug> | PON-E-<slug> | … | 3 | done |

## Smoke Tests
| ID | Title | Steps / expected | Result | Notes |
| PON-T-001 | … | steps + expected | ⬜ | epic:PON-E-<slug> · story:PON-S-<slug> · sprint:YYYY-MM-DD |
```
- **ID** stable, never reused (`PON-T-NNN`). **Result** always `⬜` — run results are captured inside MCSnow, not here.
- **Notes** are ` · `-separated: `epic:<id>` (groups the test), `story:<id>` (**required** — attaches the case to a work item), `sprint:<YYYY-MM-DD>`, optional `phase:<label>`; any other text becomes the case description. Every test is auto-tagged `smoke`.

**When the stories came from MCSnow.** If the session implements stories handed down from the MCSnow app (they already have IDs like `AGM-123`), set `mode=tests-only`, drop the `## Backlog` section, and point each test's `story:` at the existing MCSnow id. Only test cases are emitted — no new epics/stories.

**Hand-off.** The human copies the file into `Developer/MCSnow/Import/`; MCSnow converts + imports it (`tools/convert_smoke_to_json.dart`). Imports upsert on ID, so re-exports are safe.

## Copy and voice (every English string you write)

Follow **`docs/voice_and_copy_guide.md`** (gentle, calm, kind, Islamic — as rules, not adjectives). Before committing strings run `python3 tools/copy_lint.py` (it reads the ARB and the English prose in Dart content files and the history JSON: Qur’an, ’, ﷺ, US spelling and no Arabic script inside English hold there too; a deliberate exception carries `// copy-lint: allow <rule>` on its line); `test/app/copy_lint_ratchet_test.dart` fails CI when any rule's count rises, or falls without `python3 tools/copy_lint.py --write-baseline`. Never raise a baseline by hand. Every rewritten English key is re-translated for de/ar/ur in the same commit: `python3 tools/translate_arb.py --source lib/l10n/app_en.arb --outdir lib/l10n --languages de ar ur --changed-since HEAD`, then `flutter gen-l10n`. Keys no Dart file references are dead copy: `python3 tools/prune_dead_l10n_keys.py`.
