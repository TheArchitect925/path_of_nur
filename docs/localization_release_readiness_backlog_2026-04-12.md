# Localization Release Readiness Backlog

Date: 2026-04-12

## Immediate must-fix before the next translation batch

1. Completed 2026-04-12: Translated `hadithSearchMatchChapter` in every non-English locale.
2. Completed 2026-04-12: Translated the new Hadith provenance explainer keys in every non-English locale:
   - `hadithProvenanceInfoTitle`
   - `hadithProvenanceInfoBody`
   - `hadithProvenanceInfoStatusTitle`
   - `hadithProvenanceInfoPipelineBody`
3. Completed 2026-04-12: Translated the remaining Hadith reader continuity keys still same-as-English:
   - `hadithReaderBackToLane`
   - `hadithReaderChapterPosition`
   - `hadithReaderPosition`
4. Completed 2026-04-12: Finished the lower-coverage locale reader settings leftovers:
   - `hadithReaderDisplaySettingsTitle`
   - `hadithReaderDisplaySettingsSubtitle`

## Release-risk observations

1. Missing keys are no longer the problem; translation completeness is now the issue.
2. Tier A locales still have thousands of same-as-English values, so release polish is not yet close to done even in the strongest locales.
3. Tier B and Tier C locales still carry near-wholesale English fallback across large sections of the app.
4. The largest remaining debt families are Learn, Qur'an, Kids, Growth, Hadith, Onboarding, Accounts, Home, Arabic, and Worship.
5. The newest Hadith/Qur'an recent-scope fallback cluster is now fully closed, so the next release phase can move to shell/system surfaces without carrying fresh debt forward.

## Recommended operating rule for upcoming passes

1. Do not keep adding isolated one-key fixes without clearing a full surface family.
2. Treat every release translation pass as surface-owned:
   - shell/system
   - worship
   - learn/qur'an
   - kids/family
   - growth/journey
3. Re-run the full same-as-English audit after every phase, not only the recent-scope group audit.
4. Keep non-English locale files free of new English fallback text after each pass closes.

## Current Phase 2 checkpoint

1. Completed 2026-04-12: Tier A notification/system copy batch for `ar`, `de`, `ur`, and `hi`.
2. Remaining Phase 2 work:
   - remaining onboarding copy in Tier A after the core setup block
   - remaining settings copy in Tier A after the shell/theme batch
   - remaining deeper accounts/backup/restore copy in Tier A after the shell batch
   - experimental or lower-priority home shell copy in Tier A after the visible launch/dashboard batch
3. After Tier A shell/system completion, repeat the same release-shell sequence for Tier B, then Tier C.
4. Completed 2026-04-12: Tier A core onboarding setup copy batch for `ar`, `de`, `ur`, and `hi`.
5. Completed 2026-04-12: Tier A settings shell/theme batch for `ar`, `de`, `ur`, and `hi`.
6. Completed 2026-04-12: Tier A accounts shell batch for `ar`, `de`, `ur`, and `hi`.
7. Completed 2026-04-12: Tier A visible home shell/launch batch for `ar`, `de`, `ur`, and `hi`.
8. Completed 2026-04-12: Tier A accounts restore-preview and auto-backup batch for `ar`, `de`, `ur`, and `hi`.
9. Completed 2026-04-12: Tier A onboarding completion batch for `ar`, `de`, `ur`, and `hi`.
10. Completed 2026-04-12: Tier A settings/accounts scope-import-export batch for `ar`, `de`, `ur`, and `hi`.
11. Completed 2026-04-12: Tier A home preview/debug batch for `ar`, `de`, `ur`, and `hi`.
12. Completed 2026-04-12: Tier B notification/system copy batch for `tr`, `id`, and `bn`.
13. Completed 2026-04-12: Tier B onboarding core batch for `tr`, `id`, and `bn`.
14. Completed 2026-04-12: Tier B onboarding personalization batch for `tr`, `id`, and `bn`.
15. Completed 2026-04-12: Tier B settings shell batch for `tr`, `id`, and `bn`.
16. Completed 2026-04-12: Tier B notification actions batch for `tr`, `id`, and `bn`.
17. Completed 2026-04-12: Tier B accounts shell partial shared-label batch for `tr`, `id`, and `bn`.
18. Completed 2026-04-12: Tier B Bangla accounts deep batch 1.
19. Completed 2026-04-12: Tier B Bangla accounts deep batch 2.
20. Completed 2026-04-12: Tier B Bangla accounts deep batch 3.
21. Completed 2026-04-12: Tier B home shell batch for `tr`, `id`, and `bn`.
22. Completed 2026-04-12: Tier B home learning/journey batch for `tr`, `id`, and `bn`.
23. Completed 2026-04-12: Tier B home prayer/widget batch for `tr`, `id`, and `bn`.
24. Completed 2026-04-12: Tier B home glass-preview batch for `tr`, `id`, and `bn`.
25. Completed 2026-04-12: Tier B settings/accounts polish batch for `tr`, `id`, and `bn`.
26. Completed 2026-04-12: Tier B onboarding opening/theme/account-options batch for `tr`, `id`, and `bn`.
27. Completed 2026-04-12: Tier B onboarding terminology polish batch for `tr`, `id`, and `bn`.
28. Completed 2026-04-12: Tier B search-hints and loading batch for `tr`, `id`, and `bn`.
29. Completed 2026-04-12: Tier B profile/help shell batch for `tr`, `id`, and `bn`.
30. Completed 2026-04-12: Tier B help-guide completion batch for `tr`, `id`, and `bn`.
31. Completed 2026-04-12: Tier B shared all-search shell batch for `tr`, `id`, and `bn`.
32. Completed 2026-04-12: Tier B accessibility shell batch for `tr`, `id`, and `bn`.
33. Completed 2026-04-12: Tier B assistant shell batch for `tr`, `id`, and `bn`.
34. Completed 2026-04-12: Tier B history/contextual/nav shell batch for `tr`, `id`, and `bn`.
35. Completed 2026-04-12: Tier B Creation Explorer shell batch for `tr`, `id`, and `bn`.
36. Completed 2026-04-12: Tier C notifications/system copy batch for `fa`, `fa_AF`, and `ha`.
37. Completed 2026-04-12: Tier C shared all-search shell batch for `fa`, `fa_AF`, and `ha`.
38. Completed 2026-04-12: Tier C assistant shell batch for `fa`, `fa_AF`, and `ha`.
39. Completed 2026-04-12: Tier C accessibility shell batch for `fa`, `fa_AF`, and `ha`.
40. Completed 2026-04-12: Tier C Creation Explorer shell batch for `fa`, `fa_AF`, and `ha`.
41. Completed 2026-04-12: Tier C history/contextual/nav shell batch for `fa`, `fa_AF`, and `ha`.
42. Completed 2026-04-12: Tier C profile/loading shell batch for `fa`, `fa_AF`, and `ha`.
43. Completed 2026-04-12: Tier C help-guide shell batch for `fa`, `fa_AF`, and `ha`.
44. Completed 2026-04-12: Tier C settings shell batch for `fa`, `fa_AF`, and `ha`.
45. Completed 2026-04-12: Tier C onboarding core batch for `fa`, `fa_AF`, and `ha`.
46. Completed 2026-04-12: Tier C onboarding personalization batch 1 for `fa`, `fa_AF`, and `ha`.
47. Completed 2026-04-12: Tier C onboarding personalization batch 2 for `fa`, `fa_AF`, and `ha`.
48. Completed 2026-04-12: Tier C accounts core batch for `fa`, `fa_AF`, and `ha`.
49. Completed 2026-04-12: Tier C accounts remote-backup batch 1 for `fa`, `fa_AF`, and `ha`.
50. Completed 2026-04-12: Tier C accounts restore-preview batch 1 for `fa`, `fa_AF`, and `ha`.
51. Completed 2026-04-12: Tier C accounts restore-preview warning cleanup for `fa`, `fa_AF`, and `ha`.
52. Completed 2026-04-12: Tier C accounts remote-domain batch 1 for `fa`, `fa_AF`, and `ha`.
53. Completed 2026-04-12: Tier C accounts auto-backup batch 1 for `fa`, `fa_AF`, and `ha`.
54. Completed 2026-04-12: Tier C accounts scope batch 1 for `fa`, `fa_AF`, and `ha`.
55. Completed 2026-04-13: Tier C accounts auth/results batch for `fa`, `fa_AF`, and `ha`.
56. Completed 2026-04-13: Tier C accounts import/export batch for `fa`, `fa_AF`, and `ha`.
57. Completed 2026-04-13: Tier C accounts tail cleanup for `fa`, `fa_AF`, and `ha`.
58. Completed 2026-04-13: Tier C notifications/system copy batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
59. Completed 2026-04-13: Tier C shared all-search shell batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
60. Completed 2026-04-13: Tier C assistant shell batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
61. Completed 2026-04-13: Tier C accessibility shell batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
62. Completed 2026-04-13: Tier C Creation Explorer shell batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
63. Completed 2026-04-13: Tier C history/contextual/nav shell batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
64. Completed 2026-04-13: Tier C profile/loading shell batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
65. Completed 2026-04-13: Tier C help-guide shell batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
66. Completed 2026-04-13: Tier C settings shell helper/transition batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
67. Completed 2026-04-13: Tier C onboarding setup-core batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
68. Completed 2026-04-13: Tier C onboarding personalization batch 1 for `ku`, `ms`, `pa`, `ps`, and `tg`.
69. Completed 2026-04-13: Tier C onboarding personalization batch 2 for `ku`, `ms`, `pa`, `ps`, and `tg`.
70. Completed 2026-04-13: Tier C accounts core batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
71. Completed 2026-04-13: Tier C accounts remote-backup batch 1 for `ku`, `ms`, `pa`, `ps`, and `tg`.
72. Completed 2026-04-13: Tier C accounts restore-preview batch 1 for `ku`, `ms`, `pa`, `ps`, and `tg`.
73. Completed 2026-04-13: Tier C accounts restore-preview warning cleanup for `ku`, `ms`, `pa`, `ps`, and `tg`.
74. Completed 2026-04-13: Tier C accounts remote-domain batch 1 for `ku`, `ms`, `pa`, `ps`, and `tg`.
75. Completed 2026-04-13: Tier C accounts auto-backup batch 1 for `ku`, `ms`, `pa`, `ps`, and `tg`.
76. Completed 2026-04-13: Tier C accounts auth/results batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
77. Completed 2026-04-13: Tier C accounts scope batch 1 for `ku`, `ms`, `pa`, `ps`, and `tg`.
78. Completed 2026-04-13: Tier C accounts import/export batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
79. Completed 2026-04-13: Tier C accounts tail cleanup for `ku`, `ms`, `pa`, `ps`, and `tg`.
80. Completed 2026-04-13: Tier C onboarding opening/theme/account-options batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
81. Completed 2026-04-13: Tier C onboarding terminology/preferences batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
82. Completed 2026-04-13: Tier C settings theme-guidance batch for `ku`, `ms`, `pa`, `ps`, and `tg`.
83. Completed 2026-04-13: Tier C settings theme-label cleanup for `ku`, `ms`, `pa`, `ps`, and `tg`.
84. Completed 2026-04-13: Tier C Malay settings prayer-label cleanup.
85. Completed 2026-04-13: Tier C settings fresh audit pass for `ku`, `ms`, `pa`, `ps`, and `tg`.
86. Completed 2026-04-13: Tier C Kurdish settings shell batch 1.
87. Completed 2026-04-13: Tier C Kurdish settings prayer/admin batch 2.
88. Completed 2026-04-13: Tier C Kurdish settings tail cleanup.
89. Completed 2026-04-13: Tier C `pa` / `ps` / `tg` settings-onboarding tail audit.
90. Completed 2026-04-13: Tier C Hadith shell batch for `pa`, `ps`, and `tg`.
91. Completed 2026-04-13: Tier C Hadith reader-metadata and empty-state batch for `pa`, `ps`, and `tg`.
92. Completed 2026-04-13: Tier C Hadith path/progress batch for `pa`, `ps`, and `tg`.
93. Completed 2026-04-13: Tier C Hadith reflection-home and review-due batch for `pa`, `ps`, and `tg`.
94. Completed 2026-04-13: Tier C Hadith quiz/theme-card/path-streak batch for `pa`, `ps`, and `tg`.
95. Completed 2026-04-13: Tier C Hadith short labels and narrator-count batch for `pa`, `ps`, and `tg`.
96. Completed 2026-04-13: Tier C Hadith reflection interaction batch for `pa`, `ps`, and `tg`.
97. Completed 2026-04-13: Tier C Hadith reflection taxonomy and pack-title batch for `pa`, `ps`, and `tg`.
98. Completed 2026-04-13: Tier C Hadith source-browse and completion-status batch for `pa`, `ps`, and `tg`.
99. Completed 2026-04-13: Tier C Hadith fresh audit checkpoint for `pa`, `ps`, and `tg`.
100. Completed 2026-04-13: Tier C kids dua My Day batch for `pa`, `ps`, and `tg`.
101. Completed 2026-04-13: Tier C kids dua library/practice shell batch for `pa`, `ps`, and `tg`.
102. Completed 2026-04-13: Tier C kids dua starter-lessons and reward batch for `pa`, `ps`, and `tg`.
103. Completed 2026-04-13: Tier C kids dua stickers/light/reminders batch for `pa`, `ps`, and `tg`.
104. Completed 2026-04-13: Tier C kids dua stories batch for `pa`, `ps`, and `tg`.
105. Completed 2026-04-13: Tier C kids dua interaction/tools batch for `pa`, `ps`, and `tg`.
106. Completed 2026-04-13: Tier C kids dua drawing/parent-view batch for `pa`, `ps`, and `tg`.
107. Completed 2026-04-13: Tier C `pa` / `ps` / `tg` fresh audit checkpoint after the kids dua completion run.
108. Completed 2026-04-13: Tier C `arabicLearning` shell batch for `pa`, `ps`, and `tg`.
109. Completed 2026-04-13: Tier C `arabicLearning` quick-resume and mini-practice batch for `pa`, `ps`, and `tg`.
110. Completed 2026-04-13: Tier C Qur’an bridge opening batch for `pa`, `ps`, and `tg`.
111. Completed 2026-04-13: Tier C short-surah action/card batch for `pa`, `ps`, and `tg`.
112. Completed 2026-04-13: Tier C Qur’an bridge progression/help batch for `pa`, `ps`, and `tg`.
113. Completed 2026-04-13: Tier C Qur’an readiness descriptive/help batch for `pa`, `ps`, and `tg`.
114. Completed 2026-04-13: Tier C Qur’an guided-passage batch for `pa`, `ps`, and `tg`.
115. Completed 2026-04-13: Tier C `arabicLearning` pack-tail cleanup for `pa`, `ps`, and `tg`.
116. Completed 2026-04-13: Tier C `arabicLearning` fresh audit checkpoint for `pa`, `ps`, and `tg`.
117. Completed 2026-04-13: Tier C learning landing-shell opening batch for `pa`, `ps`, and `tg`.
118. Completed 2026-04-13: Tier C learning landing-shell continuation batch for `pa`, `ps`, and `tg`.
119. Completed 2026-04-13: Tier C worship landing-shell opening batch for `pa`, `ps`, and `tg`.
120. Completed 2026-04-13: Tier C worship tracking/fasting handoff batch for `pa`, `ps`, and `tg`.
121. Completed 2026-04-13: Tier C worship reminders mini-shell batch for `pa`, `ps`, and `tg`.
122. Completed 2026-04-13: Tier C worship reminders devices-tail cleanup for `pa`, `ps`, and `tg`.
123. Completed 2026-04-13: Tier C worship Qibla shell batch for `pa`, `ps`, and `tg`.
124. Completed 2026-04-13: Tier C worship Qibla direction/location batch for `pa`, `ps`, and `tg`.
125. Completed 2026-04-13: Tier C worship Qibla iPad-availability tail cleanup for `pa`, `ps`, and `tg`.
126. Completed 2026-04-13: Tier C worship shell/prayer-tracking cleanup batch for `pa`, `ps`, and `tg`.
127. Completed 2026-04-13: Tier C worship fresh audit checkpoint for `pa`, `ps`, and `tg`.
128. Completed 2026-04-13: Tier C search hints batch for `pa`, `ps`, and `tg`.
129. Completed 2026-04-13: Tier C settings/accounts summary-tail batch for `pa`, `ps`, and `tg`.
130. Completed 2026-04-13: Tier C home opening shell batch for `pa`, `ps`, and `tg`.
131. Completed 2026-04-13: Tier C home summary labels batch for `pa`, `ps`, and `tg`.
132. Completed 2026-04-13: Tier C home journey/learn/welcome batch for `pa`, `ps`, and `tg`.
133. Completed 2026-04-13: Tier C home helpers batch for `pa`, `ps`, and `tg`.
134. Completed 2026-04-13: Tier C home widgets batch for `pa`, `ps`, and `tg`.
135. Completed 2026-04-13: Tier C home glass-preview batch for `pa`, `ps`, and `tg`.
136. Completed 2026-04-13: Tier C home fresh audit checkpoint for `pa`, `ps`, and `tg`.
137. Completed 2026-04-13: Tier C learning journey shell batch for `pa`, `ps`, and `tg`.
138. Completed 2026-04-13: Tier C learning journey browse/home batch for `pa`, `ps`, and `tg`.
139. Completed 2026-04-13: Tier C learning journey islands/detail/tool shell batch for `pa`, `ps`, and `tg`.
140. Completed 2026-04-13: Tier C learning journey Today Light batch for `pa`, `ps`, and `tg`.
141. Completed 2026-04-13: Tier C learning journey recitation-meanings prose batch for `pa`, `ps`, and `tg`.
142. Completed 2026-04-13: Tier C learning journey reading-basics prose batch for `pa`, `ps`, and `tg`.
143. Completed 2026-04-13: Tier C learning journey Seerah opening prose batch for `pa`, `ps`, and `tg`.
144. Completed 2026-04-13: Tier C learning journey Seerah Makkah/Hijrah prose batch for `pa`, `ps`, and `tg`.
145. Completed 2026-04-13: Tier C learning journey Seerah Madinah/leadership prose batch for `pa`, `ps`, and `tg`.
146. Completed 2026-04-13: Tier C learning journey Seerah final-sermon prose batch for `pa`, `ps`, and `tg`.
147. Completed 2026-04-13: Tier C learning journey Dhikr opening/morning prose batch for `pa`, `ps`, and `tg`.
148. Completed 2026-04-13: Tier C learning journey Dhikr evening/after-salah prose batch for `pa`, `ps`, and `tg`.
149. Completed 2026-04-13: Tier C learning journey Dhikr routine/istighfar prose batch for `pa`, `ps`, and `tg`.
150. Completed 2026-04-13: Tier C learning journey Dhikr salawat prose batch for `pa`, `ps`, and `tg`.
151. Completed 2026-04-13: Tier C learning journey Dhikr fresh audit checkpoint for `pa`, `ps`, and `tg`.
152. Completed 2026-04-13: Tier C learning journey faith books/prophets prose batch for `pa`, `ps`, and `tg`.
153. Completed 2026-04-13: Tier C learning journey faith judgment/qadr prose batch for `pa`, `ps`, and `tg`.
154. Completed 2026-04-13: Tier C learning journey stage reading prose batch for `pa`, `ps`, and `tg`.
155. Completed 2026-04-13: Tier C learning journey stage Ramadan batch for `pa`, `ps`, and `tg`.
156. Completed 2026-04-13: Tier C learning journey stage fiqh batch for `pa`, `ps`, and `tg`.
157. Completed 2026-04-13: Tier C learning journey stage timeline batch for `pa`, `ps`, and `tg`.
158. Completed 2026-04-13: Tier C learning journey stage stories batch for `pa`, `ps`, and `tg`.

## Updated remaining Phase 2 work

1. Remaining Tier B shell/system work after the notification/system, onboarding, settings, notification-action, Bangla accounts deep batches 1-3, the visible home shell batch, the home learning/journey batch, the home prayer/widget batch, the home glass-preview batch, the Tier B settings/accounts polish batch, the Tier B onboarding opening/theme/account-options batch, the Tier B onboarding terminology polish batch, the Tier B search-hints and loading batch, the Tier B profile/help shell batch, the Tier B help-guide completion batch, the Tier B shared all-search shell batch, the Tier B accessibility shell batch, the Tier B assistant shell batch, the Tier B history/contextual/nav shell batch, and the Tier B Creation Explorer shell batch.
2. Tier C shell/system release work after the notifications/system copy batches for `fa`, `fa_AF`, `ha`, `ku`, `ms`, `pa`, `ps`, and `tg`, the shared all-search shell batch, the assistant shell batch, the accessibility shell batch, the Creation Explorer shell batch, the history/contextual/nav shell batch, the profile/loading shell batches for `fa`, `fa_AF`, `ha`, `ku`, `ms`, `pa`, `ps`, and `tg`, the help-guide shell batches for `fa`, `fa_AF`, `ha`, `ku`, `ms`, `pa`, `ps`, and `tg`, the settings shell helper/transition batch, settings theme-guidance batch, settings theme-label cleanup batch for `ku`, `ms`, `pa`, `ps`, and `tg`, the Malay prayer-label cleanup, the fresh settings audit pass, the Kurdish settings shell batch 1 plus Kurdish settings prayer/admin batch 2 and Kurdish settings tail cleanup, the `pa` / `ps` / `tg` settings-onboarding tail audit, the Hadith shell batch plus the Hadith reader-metadata and empty-state batch plus the Hadith path/progress batch plus the Hadith reflection-home and review-due batch plus the Hadith quiz/theme-card/path-streak batch plus the Hadith short labels and narrator-count batch plus the Hadith reflection interaction batch plus the Hadith reflection taxonomy and pack-title batch plus the Hadith source-browse and completion-status batch plus the fresh Hadith audit checkpoint, the kids dua My Day batch plus the kids dua library/practice shell batch plus the kids dua starter-lessons and reward batch plus the kids dua stickers/light/reminders batch plus the kids dua stories batch plus the kids dua interaction/tools batch plus the kids dua drawing/parent-view batch plus the fresh `pa` / `ps` / `tg` kids-dua completion audit checkpoint, the completed first `arabicLearning` shell batch plus the completed quick-resume / mini-practice continuation batch plus the completed `arabicLearning` pack-tail cleanup plus the completed `arabicLearning` fresh audit checkpoint plus the completed Qur’an bridge opening batch plus the completed short-surah action/card batch plus the completed Qur’an bridge progression/help batch plus the completed Qur’an readiness descriptive/help batch plus the completed Qur’an guided-passage batch plus the completed learning landing-shell opening batch plus the completed learning landing-shell continuation batch plus the completed learning journey shell batch plus the completed worship landing-shell opening batch plus the completed worship tracking/fasting handoff batch plus the completed worship reminders mini-shell batch plus the completed worship reminders devices-tail cleanup plus the completed worship Qibla shell batch plus the completed worship Qibla direction/location batch plus the completed worship Qibla iPad-availability tail cleanup plus the completed worship shell/prayer-tracking cleanup batch plus the completed worship fresh audit checkpoint plus the completed search hints batch plus the completed settings/accounts summary-tail batch plus the completed home opening shell batch plus the completed home summary labels batch plus the completed home journey/learn/welcome batch plus the completed home helpers batch plus the completed home widgets batch plus the completed home glass-preview batch plus the completed home fresh audit checkpoint for `pa`, `ps`, and `tg`, the completed onboarding setup-core, onboarding personalization batches 1-2, onboarding opening/theme/account-options batch, and onboarding terminology/preferences batch for `ku`, `ms`, `pa`, `ps`, and `tg`, the broader remaining work now shifted away from those tiny settings/onboarding tails into the wider remaining `learning*`, `quran*`, `kids*`, `worship*`, and other major families for `pa`, `ps`, and `tg`, the completed onboarding core and personalization batches 1-2 for `fa`, `fa_AF`, and `ha`, the completed accounts core batches for `fa`, `fa_AF`, `ha`, `ku`, `ms`, `pa`, `ps`, and `tg`, the completed accounts remote-backup batch 1, accounts restore-preview batch 1, restore-preview warning cleanup, remote-domain batch 1, auto-backup batch 1, auth/results batch, scope batch 1, import/export batch, and tail cleanup for `ku`, `ms`, `pa`, `ps`, and `tg`, plus the remaining accounts tail cleanup for `fa`, `fa_AF`, and `ha`.

## Enhancement options

1. Add a full-app audit tool mode that outputs same-as-English counts by broad surface family and locale tier, not just by one manually defined group.
2. Add a release dashboard doc with per-locale remaining fallback counts so translation progress is easy to track during the release push.
3. Add a production-surface allowlist so internal/editorial-only strings can be audited separately from true release blockers.
