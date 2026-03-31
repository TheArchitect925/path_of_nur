===== PHASE X PROMPT — MAIN PAGE BACKGROUND SHELL FIX =====

PRIMARY OBJECTIVE === FIXING THE ROOT CAUSE OF PARTIAL BACKGROUND COVERAGE ON MAIN PAGES

You are working in the existing Flutter codebase for Path of Nūr.

Problem:
The Home page renders the scenic/shared background correctly across the full page.
Other main pages such as Dhikr/Learn and similar top-level pages are rendering the background incorrectly:
- the scenic background starts lower in the page
- the top portion uses a flatter/plain background
- the decorative background appears attached to the content area instead of the full page shell

Important:
This is a structural shell/background ownership issue.
Do NOT attempt more color, opacity, or decoration tweaks without first comparing widget trees.

Execution rules:
1. Audit first before editing.
2. Treat the Home page as the known-good reference.
3. Compare Home against at least 3 broken main pages.
4. Find the exact structural difference in:
   - Scaffold/body structure
   - Stack usage
   - Positioned.fill background usage
   - SafeArea placement
   - scroll view placement
   - where the scenic/shared background is attached
5. Fix the root cause, not symptoms.
6. Do not rebuild unrelated page content.
7. Keep the implementation production-ready and maintainable.
8. Run analyzer on changed files and summarize results.

