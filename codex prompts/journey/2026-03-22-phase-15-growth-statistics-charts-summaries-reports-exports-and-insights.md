Growth Statistic Charts

===== PHASE 15 PROMPT — GROWTH STATISTICS CHARTS, SUMMARIES, REPORTS, EXPORTS, AND INSIGHTS =====

PRIMARY OBJECTIVE === BUILDING GROWTH STATISTICS CHARTS, WEEKLY/MONTHLY SUMMARIES, REPORTS, EXPORT/SHARING, REWARDS INSIGHTS, AND “BEST DAY” INSIGHTS ON THE STATISTICS PAGE

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready enhancement phase built on top of the existing Growth and Statistics systems. DO NOT rebuild the Growth system. DO NOT remove working user stats, XP, drops, journeys, habits, reflections, dhikr totals, Qur’an reading stats, prayer stats, ocean progress, or garden progression. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all existing stats, progress, XP, drops, streaks, journeys, reflections, habits, dhikr history, prayer history, Qur’an reading history, and ocean/garden data
- Do not delete or reset records
- Do not fabricate fake insights when real data is unavailable
- Keep the statistics page calm, clean, and readable
- Prefer simple useful charts over heavy complex analytics
- Build on top of the existing Statistics page and existing data models where possible
- Keep calculations centralized and production-safe
- Avoid package churn unless a chart library is already in place or a very small safe addition is truly necessary
- No destructive migrations
- At the end, provide a concise audit summary

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

Create and link Growth Statistic Charts into the Statistics page, including:

1. Weekly trends
2. Monthly trends
3. Reports
4. Export / sharing
5. Rewards insights
6. Weekly / Monthly summaries
7. Simple charts
8. “Your best day” insights

The result should feel like a meaningful personal growth dashboard, not a cluttered analytics console.

--------------------------------------------------
A. AUDIT (MANDATORY FIRST STEP)
--------------------------------------------------

Audit the current Statistics page and all related Growth data sources before editing.

Inspect:
- current Statistics page structure
- current Growth metrics already shown there
- Journey Stats section
- Ocean Dashboard section
- Qur’an Reading metrics
- Times & Reflection metrics
- Total Adhkar Completed metrics
- any prayer, dhikr, journey, XP, drops, habits, reflections, learning, or Qur’an reading history models
- any existing chart widgets or data visualization components already in the app
- any export/share infrastructure already present elsewhere in the app
- any summary card patterns that can be reused
- any existing “best streak”, “best day”, or similar insights already computed

Audit these questions:
- What historical data is already stored and accessible for trends?
- What date granularity is available: daily, weekly, monthly, per-event?
- Which data sources are reliable enough for charting right now?
- Which summary metrics are already computed versus needing safe aggregation?
- Is there already a share/export helper in the app?
- What charting capability already exists in the codebase?
- Which stats are most meaningful to surface weekly/monthly without overcomplication?
- What can be computed safely without risky retroactive migrations?

--------------------------------------------------
B. DEFINE THE STATISTICS PAGE STRUCTURE
--------------------------------------------------

Expand the Statistics page so it becomes a clear dashboard with sections such as:

- Summary
- Trends
- Insights
- Reports / Export
- Existing sections:
  - Qur’an Reading
  - Times & Reflection
  - Total Adhkar Completed
  - Journey Stats
  - Ocean Dashboard

Requirements:
- keep the page organized and not overcrowded
- ensure the new charts and insights feel like part of the page, not bolted on
- preserve existing useful metrics already surfaced
- use islands/sections/cards consistent with the app design language
- do not bury the most useful items too deep

Prefer a structure that gives:
- quick high-level summary first
- trends/charts next
- deeper insights and actions after

--------------------------------------------------
C. WEEKLY / MONTHLY SUMMARIES
--------------------------------------------------

Add Weekly and Monthly summary sections/cards.

These should provide concise rollups for the user’s growth activity, using real available data where supported, such as:
- prayers completed
- dhikr totals
- Qur’an reading activity
- habits completed
- reflection activity
- drops gained
- XP gained
- journey progress movement
- any other truly supported growth metrics

Requirements:
- summaries must be real and data-backed
- weekly and monthly views should be easy to understand
- do not overwhelm with too many numbers
- present concise headline metrics with a calm summary style
- if some metrics are unavailable historically, omit them gracefully rather than faking them

Possible output patterns:
- This week
- This month
- Compared to previous week/month if data exists safely

Only include comparisons where they are reliable.

--------------------------------------------------
D. SIMPLE CHARTS
--------------------------------------------------

Add simple charts to the Statistics page.

Target:
- readable
- minimal
- calm
- mobile-friendly
- performant

Possible chart types:
- line chart for trends over time
- bar chart for daily/weekly totals
- small sparkline-style summaries if they fit existing UI patterns

Use only the simplest chart types needed to communicate:
- weekly trends
- monthly trends
- growth over time
- activity distribution

Requirements:
- do not build complex analytics dashboards
- do not add cluttered legends and controls unless needed
- charts should use real data only
- empty/insufficient-data states should be graceful
- avoid making the page feel visually noisy

Prefer one good chart per concept over many tiny charts.

--------------------------------------------------
E. WEEKLY TRENDS
--------------------------------------------------

Create weekly trend views/cards/charts using available daily activity data.

Possible weekly trend metrics:
- daily prayers completed
- daily dhikr totals
- daily Qur’an reading activity
- daily drops gained
- daily XP gained
- daily habit completion count

Requirements:
- weekly trend should help the user understand their recent consistency
- choose the strongest and most reliable metrics rather than charting everything
- do not fabricate derived metrics if the raw data is weak
- make the trend readable at a glance

--------------------------------------------------
F. MONTHLY TRENDS
--------------------------------------------------

Create monthly trend views/cards/charts using available weekly or daily rollup data.

Possible monthly trend metrics:
- weekly totals across the month
- monthly progress accumulation
- overall activity rhythm
- month-to-date summary

Requirements:
- keep it simple and legible
- monthly trend should feel broader and less noisy than weekly
- use aggregation appropriate to the data volume
- avoid overly dense daily points if the UI becomes cluttered

--------------------------------------------------
G. “YOUR BEST DAY” INSIGHTS
--------------------------------------------------

Add a “Your Best Day” insight feature.

Goal:
- identify a meaningful best day based on supported growth data
- present it in a motivating but grounded way

Examples of valid “best day” logic depending on real available data:
- highest combined growth score in a day
- highest prayer completion + dhikr + Qur’an reading day
- most drops earned in a day
- strongest habit completion day
- highest XP day if XP is reliable and safe to use for this

Requirements:
- define one clear calculation method centrally
- do not use arbitrary noisy logic spread across the UI
- be honest about what “best day” means
- if insufficient data exists, show a graceful fallback instead of fake insight
- ideally include the date and a short explanation of why it was their best day

Keep the insight encouraging and understandable.

--------------------------------------------------
H. REWARDS INSIGHTS
--------------------------------------------------

Add Rewards Insights to the Statistics page.

This should help users understand how their activity connects to progression systems such as:
- XP gained
- drops gained
- journey progress
- milestones reached
- habit consistency rewards
- prayer/dhikr contribution to growth systems where supported

Requirements:
- use existing reward systems already modeled in the app
- do not invent new reward formulas in this phase unless required for safe reporting of existing behavior
- make the insights understandable, not overly game-like
- explain real contribution patterns where possible, for example:
  - what contributed most this week
  - where the user gained the most XP/drops
  - what habit or action area is driving growth

Do not overload this section with too much text.

--------------------------------------------------
I. REPORTS
--------------------------------------------------

Add a Reports concept to the Statistics page.

This can be lightweight and should build on the new summaries/charts/insights rather than being a separate giant subsystem.

Possible report views:
- weekly report
- monthly report
- growth snapshot
- activity summary

Requirements:
- reports should feel like structured summaries, not enterprise BI
- keep them mobile-friendly
- reuse existing aggregated data where possible
- the page may surface report cards and/or a report detail view if needed
- avoid creating a huge reporting engine in this phase

If a report detail page is needed, keep it simple and consistent with the app.

--------------------------------------------------
J. EXPORT / SHARING
--------------------------------------------------

Add export/sharing support for growth statistics in a safe, practical way.

Possible export/share targets:
- weekly summary
- monthly summary
- simple stats snapshot
- chart + summary card if already supported cleanly

Requirements:
- preserve privacy and user control
- do not export raw internal/debug data
- keep export/share output clean and human-readable
- if native share is already used elsewhere, reuse that pattern
- if export file generation is too heavy for this phase, provide a well-structured shareable summary first and clearly document any limits

Possible outputs:
- share text summary
- image/snapshot card if already supported safely
- exportable report if architecture supports it cleanly

Choose the safest production-ready scope.

--------------------------------------------------
K. DATA AGGREGATION / CALCULATION LAYER
--------------------------------------------------

Centralize trend and summary calculations in a safe layer.

Requirements:
- avoid scattering calculations through UI widgets
- create reusable aggregation helpers/providers/services where appropriate
- weekly/monthly summaries should derive from the same trusted aggregation layer
- “best day” and rewards insights should not duplicate incompatible logic
- keep this layer testable

Possible responsibilities:
- daily rollups
- weekly rollups
- monthly rollups
- best-day computation
- contribution/reward summaries
- chart-ready series generation

Do not over-engineer beyond the needs of this phase.

--------------------------------------------------
L. EMPTY / INSUFFICIENT DATA STATES
--------------------------------------------------

Handle cases where the user does not yet have enough data.

Requirements:
- charts should not look broken when data is sparse
- insights should degrade gracefully
- summaries should still be helpful for new users
- do not show fake “best day” or fake trends if there is not enough data
- use calm and motivating fallback copy

Examples:
- not enough data for monthly trends yet
- no reflections logged yet
- no recent activity in one category

--------------------------------------------------
M. PERFORMANCE / UX SAFETY
--------------------------------------------------

Charts and summaries must remain performant.

Requirements:
- avoid expensive recalculation on every rebuild
- cache/derive data through providers/controllers where appropriate
- keep the Statistics page scroll smooth
- do not make the page visually or technically heavy
- ensure charts render correctly across likely small/medium screen sizes

--------------------------------------------------
N. DATA SAFETY
--------------------------------------------------

This phase must preserve:
- all existing stats/history
- XP totals
- drops totals
- journey progress
- dhikr logs
- prayer logs
- Qur’an reading history
- habits/reflections/journal signals if used in summaries
- ocean/community data
- garden progression

Requirements:
- no destructive migrations
- no record rewriting just to enable charts
- backwards compatibility for older records with incomplete metadata
- omit unsupported insights gracefully instead of corrupting data

--------------------------------------------------
O. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- weekly summary aggregation
- monthly summary aggregation
- chart data series generation
- “best day” insight computation
- rewards insight computation where introduced
- insufficient-data fallback states
- Statistics page renders new sections correctly
- export/share summary generation works safely
- existing Statistics data still renders correctly

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current Statistics page structure
   - available historical data sources
   - charting/export constraints found

3. Statistics page update summary
   - new sections added
   - final layout/order
   - how existing sections were preserved

4. Charts summary
   - weekly trends
   - monthly trends
   - chart types used
   - data sources used

5. Insights summary
   - Weekly / Monthly summaries
   - Rewards insights
   - “Your best day” logic

6. Reports / export summary
   - what report/share/export functionality was added
   - output format chosen
   - privacy/scope notes

7. Data safety summary
   - model/aggregation changes
   - backwards compatibility notes
   - confirmation that no user stats/progress were lost

8. Validation
   - analyzer/tests run
   - results

9. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - remaining follow-ups
   - technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Statistics page includes weekly/monthly summaries
- Statistics page includes simple weekly/monthly trend charts
- Statistics page includes reports
- Statistics page includes export/sharing support
- Statistics page includes rewards insights
- Statistics page includes a real “Your best day” insight
- all insights are based on real available data
- empty/low-data states are graceful
- no user stats/progress/data are lost
- the Statistics page feels more production-ready and useful, not cluttered

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the entire statistics or growth system
- create a heavy analytics dashboard
- fabricate data or insights
- reset or rewrite historical records unsafely
- add cluttered or overly technical charts
- broaden into a full redesign of Growth pages beyond what is needed for the Statistics page

Stay focused on Growth statistics charts, summaries, reports, export/sharing, rewards insights, and best-day insights.

--------------------------------------------------

“And whoever does an atom’s weight of good will see it.” — Qur’an 99:7

===== END PHASE 15 PROMPT =====
