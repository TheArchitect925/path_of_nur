===== PHASE 9 — RECOVER EXCLUDED HADITH ENTRIES INTO VERIFIED PUBLIC CORPUS =====

PRIMARY OBJECTIVE === RECOVER AS MANY EXCLUDED HADITH ENTRIES AS POSSIBLE BY FIXING TRUST-CRITICAL METADATA GAPS WITHOUT BREAKING VERIFIED-ONLY SURFACING

CONTEXT
Current corpus:
- 986 verified entries
- 361 excluded entries due to missing trust-critical metadata

GOAL
Recover excluded entries safely by filling missing fields:
- grade
- source reference
- source URL
- narrator
- verification flags

IMPLEMENT

A. AUDIT EXCLUDED ENTRIES
- Identify why each entry failed:
  - missing grade
  - missing source reference
  - missing narrator
  - missing verification flags

B. RECOVERY RULES
- Only recover entries where:
  - source is trustworthy
  - reference can be confirmed
  - grading can be safely assigned

C. DO NOT FABRICATE
- If metadata cannot be confirmed → keep excluded

D. UPDATE PIPELINE
- Re-run normalization + release-gate
- Ensure recovered entries pass canonical checks

E. OUTPUT
- new verified count
- recovered count
- remaining excluded count
- breakdown by failure reason

DELIVERABLES
- Executive summary
- recovery statistics
- updated dataset counts
- validation + test results

At the end confirm:
- recovered entries are verified
- no trust rules were weakened
