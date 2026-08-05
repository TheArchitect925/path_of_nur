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
