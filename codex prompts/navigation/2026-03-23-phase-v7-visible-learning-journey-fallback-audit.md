# Phase V7 Prompt — Visible Learning Journey Fallback Audit

Run the visible Learning Journey fallback audit after V6.

Focus only on visible Learning Journey fallback actions that still use `learnLegacy`.

Return a summary that explicitly includes:

1. Visible fallback links/actions found
   - list each visible Learning Journey fallback action using `learnLegacy`
   - say where it appears in the UI

2. Safe visible replacements made
   - old visible fallback action
   - exact canonical route replacement
   - why that replacement is semantically correct

3. Visible fallback actions intentionally preserved
   - list each preserved visible fallback
   - explain why it remains broad fallback

4. Deferred visible items
   - ambiguous visible fallback links not changed

5. Validation
   - analyzer results
   - tests run
   - any visible-action routing tests added or updated

Do not return the V6 hidden metadata summary again.
Do not focus on hidden catalog items unless directly relevant to a visible fallback action.
