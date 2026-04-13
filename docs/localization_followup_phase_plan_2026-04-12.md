# Localization Follow-up Phase Plan

Date: 2026-04-12

## Audit scope

- Reviewed the recent Hadith and Qur'an localization work in `lib/l10n/app_*.arb`
- Compared non-English locale values against `app_en.arb`
- Treated two conditions as missed work:
  - key missing from a locale file
  - exact same-as-English fallback text for user-facing strings

## Confirmed misses

### Phase 1 block

Status: completed 2026-04-12

These two keys were missing from every non-English locale and were added in this pass:

- `hadithReflectionCompletedQuiet`
- `hadithLessonCompletedQuiet`

### Phase 2 block

Status: completed 2026-04-12

These clusters were completed in all four priority locales we already touched most heavily: `ar`, `de`, `ur`, `hi`.

- Hadith grade explainer
  - `hadithGradeInfoDisclaimer`
  - `hadithGradeInfoCurrentBadge`
  - `hadithGradeInfoMuttafaqunAlayh`
  - `hadithGradeInfoSahih`
  - `hadithGradeInfoHasanSahih`
  - `hadithGradeInfoHasan`
  - `hadithGradeInfoWeak`
  - `hadithGradeInfoBalagh`
  - `hadithGradeInfoOtherTitle`
  - `hadithGradeInfoOther`
- Hadith narrator
  - `hadithNarratorFallbackSummary`
  - `hadithNarratorAliasesTitle`
  - `hadithNarratorInLibraryTitle`
  - `hadithNarratorStatHadith`
  - `hadithNarratorStatSources`
  - `hadithNarratorStatThemes`
  - `hadithNarratorStatCollections`
  - `hadithNarratorRoleCompanion`
  - `hadithNarratorRoleMotherOfBelievers`
  - `hadithNarratorRoleScholarCompanion`
  - `hadithNarratorSummaryAbuHurairah`
  - `hadithNarratorSummaryAishah`
  - `hadithNarratorSummaryAbdullahIbnUmar`
  - `hadithNarratorSummaryAnasIbnMalik`
  - `hadithNarratorSummaryJabirIbnAbdullah`
  - `hadithNarratorSummaryAbdullahIbnAbbas`
- Hadith reader settings
  - `hadithReaderDisplaySettingsAction`
- Qur'an hub recommendation reasons
  - `quranHubRecommendationReasonGuidedPath`
  - `quranHubRecommendationReasonDaily`
  - `quranHubRecommendationReasonMemorizationFocus`
  - `quranHubRecommendationReasonRecentStudy`
- Qur'an daily companion descriptions
  - `quranCompanionResumePathDescription`
  - `quranCompanionResumeBadge`
  - `quranCompanionContinueSurahDescription`
  - `quranCompanionThemeDescription`
  - `quranCompanionRelatedThemeDescription`
  - `quranCompanionPathwayDescription`
  - `quranCompanionStartHereDescription`
  - `quranCompanionTimeOfDayDescription`
  - `quranCompanionFridayDescription`
  - `quranCompanionReasonAfternoon`
  - `quranCompanionReasonNight`
  - `quranCompanionReasonRecent`
  - `quranCompanionReasonFocus`
  - `quranCompanionReasonJourney`
  - `quranCompanionReasonMomentum`
  - `quranCompanionReasonStart`
- Qur'an memorization review
  - `quranMemorizationReviewAllTitle`
  - `quranMemorizationReviewContinueTitle`
  - `quranMemorizationReviewDueTitle`
  - `quranMemorizationReviewEmpty`
  - `quranMemorizationReviewMeaningFallback`
  - `quranMemorizationReviewNeedsRevisionTitle`
  - `quranMemorizationReviewNeverReviewed`
  - `quranMemorizationReviewOpenListAction`
  - `quranMemorizationReviewOpenReaderAction`
  - `quranMemorizationReviewRecentTitle`
  - `quranMemorizationReviewRelatedStudyTitle`
  - `quranMemorizationReviewSavedTitle`
  - `quranMemorizationReviewSubtitle`
  - `quranMemorizationReviewThemesTitle`
  - `quranMemorizationReviewTitle`
  - `quranMemorizationReviewTodayTitle`
- Qur'an reference-detail sheet
  - `quranReferenceDetailCategoryCharacterLesson`
  - `quranReferenceDetailCategoryDivineLife`
  - `quranReferenceDetailCategoryHadith`
  - `quranReferenceDetailCategoryLearningJourney`
  - `quranReferenceDetailCategoryLearningPath`
  - `quranReferenceDetailCategoryProphet`
  - `quranReferenceDetailCategoryQuranInsight`
  - `quranReferenceDetailCategoryQuranReference`
  - `quranReferenceDetailCategoryWorldLesson`
  - `quranReferenceDetailCategoryWorshipLesson`
  - `quranReferenceDetailOpenCharacterLesson`
  - `quranReferenceDetailOpenDivineLifeLesson`
  - `quranReferenceDetailOpenHadithLesson`
  - `quranReferenceDetailOpenLearningJourney`
  - `quranReferenceDetailOpenLearningPath`
  - `quranReferenceDetailOpenProphetStory`
  - `quranReferenceDetailOpenQuranInsight`
  - `quranReferenceDetailOpenWorldLesson`
  - `quranReferenceDetailOpenWorshipLesson`
  - `quranReferenceDetailPreviewTitle`
  - `quranReferenceDetailReasonCharacterLesson`
  - `quranReferenceDetailReasonDivineLife`
  - `quranReferenceDetailReasonHadith`
  - `quranReferenceDetailReasonKnowledgeCharacter`
  - `quranReferenceDetailReasonKnowledgeHadith`
  - `quranReferenceDetailReasonKnowledgeJourney`
  - `quranReferenceDetailReasonKnowledgeLifeLesson`
  - `quranReferenceDetailReasonKnowledgeQuran`
  - `quranReferenceDetailReasonKnowledgeReflection`
  - `quranReferenceDetailReasonKnowledgeSeerah`
  - `quranReferenceDetailReasonKnowledgeSignsWorld`
  - `quranReferenceDetailReasonKnowledgeTheme`
  - `quranReferenceDetailReasonKnowledgeWorship`
  - `quranReferenceDetailReasonLearningJourney`
  - `quranReferenceDetailReasonLearningPath`
  - `quranReferenceDetailReasonProphet`
  - `quranReferenceDetailReasonQuranInsight`
  - `quranReferenceDetailReasonQuranReferenceLinked`
  - `quranReferenceDetailReasonWorldLesson`
  - `quranReferenceDetailReasonWorshipLesson`
  - `quranReferenceDetailSourceOwnerTitle`
  - `quranReferenceDetailWhyRelatedTitle`
- Qur'an themes and topic map
  - `quranTopicsTitle`
  - `quranThemeMapBrowseSubtitle`
  - `quranThemeMapTopicNotFound`
  - `quranThemeMapAyahsLabel`
  - `quranThemeMapSurahsLabel`
  - `quranThemeMapLearningLinksLabel`
  - `quranThemeMapBestModeLabel`
  - `quranThemeMapRepresentativeAyahsTitle`
  - `quranThemeMapWhyItMattersTitle`
  - `quranThemeMapStudyFocusTitle`
  - `quranThemeMapStudyThemeAction`
  - `quranThemeMapOpenPathAction`
  - `quranThemeMapRelatedSurahsTitle`
  - `quranThemeMapRelatedLearningTitle`
  - `quranThemePatienceTitle`
  - `quranThemeGratitudeTitle`
  - `quranThemeMercyTitle`
  - `quranThemeFamilyTitle`
  - `quranThemeAkhirahTitle`
  - `quranThemeAkhirahDescription`
  - `quranThemeSignsInCreationTitle`
  - `quranThemeSignsInCreationDescription`
  - `quranThemeProphetsTitle`
  - `quranThemeProphetsDescription`
  - `quranThemeTrustInAllahTitle`
  - `quranThemeRepentanceTitle`
  - `quranThemeRemembranceTitle`
  - `quranThemeRemembranceDescription`
  - `quranThemeSincerityTitle`
  - `quranThemeSincerityDescription`
  - `quranThemePrayerTitle`
  - `quranThemePrayerDescription`
  - `quranThemeCharityTitle`
  - `quranThemeCharityDescription`
  - `quranThemeJusticeTitle`
  - `quranThemeJusticeDescription`
  - `quranThemeHumilityTitle`
  - `quranThemeHumilityDescription`
  - `quranThemePatienceWhyItMatters`
  - `quranThemePatienceStudyFocus`
  - `quranThemeGratitudeWhyItMatters`
  - `quranThemeGratitudeStudyFocus`
  - `quranThemeMercyWhyItMatters`
  - `quranThemeMercyStudyFocus`
  - `quranThemeFamilyWhyItMatters`
  - `quranThemeFamilyStudyFocus`
  - `quranThemeTrustInAllahWhyItMatters`
  - `quranThemeTrustInAllahStudyFocus`
  - `quranThemeRepentanceWhyItMatters`
  - `quranThemeRepentanceStudyFocus`
  - `quranThemeRemembranceWhyItMatters`
  - `quranThemeRemembranceStudyFocus`
  - `quranThemeSincerityWhyItMatters`
  - `quranThemeSincerityStudyFocus`
  - `quranThemeDiscoveryHeroEyebrow`
  - `quranThemeDiscoveryHeroTitle`
  - `quranThemeDiscoveryHeroSubtitle`
  - `quranThemeDiscoveryFeaturedThemesTitle`
  - `quranThemeDiscoveryBrowseByCategoryTitle`
  - `quranThemeDiscoveryMoreThemesTitle`
  - `quranThemeDiscoveryBrowseMoreThemesAction`
  - `quranThemeDiscoveryExploreThemeAction`
  - `quranThemeDiscoverySearchHint`
  - `quranThemeDiscoveryPageTitle`
  - `quranThemeDiscoveryPageSubtitle`
  - `quranThemeDiscoveryIslandTitle`
  - `quranThemeDiscoveryIslandSubtitle`
  - `quranThemeDiscoveryMissingThemeTitle`
  - `quranThemeDiscoveryMissingThemeSubtitle`
  - `quranThemeDiscoveryNoResultsTitle`
  - `quranThemeDiscoveryNoResultsSubtitle`
  - `quranThemeDiscoveryCategoryBelief`
  - `quranThemeDiscoveryCategoryWorship`
  - `quranThemeDiscoveryCategoryCharacter`
  - `quranThemeDiscoveryCategoryStoriesProphets`
  - `quranThemeDiscoveryCategorySocietyEthics`
  - `quranThemeDiscoveryCategorySignsReflection`
  - `quranThemeDiscoveryCategoryAkhirah`
  - `quranThemeDiscoveryKeyAyahReferencesTitle`
  - `quranThemeDiscoveryRelatedSurahsTitle`
  - `quranThemeDiscoveryReflectionTitle`

### Phase 3 block

Status: completed 2026-04-12

Repeat the same cluster completion for the lower-coverage locales:

- `bn`
- `fa`
- `fa_AF`
- `ha`
- `id`
- `ku`
- `ms`
- `pa`
- `ps`
- `tg`
- `tr`

These locales had the same narrator / grade / companion / theme-map gaps, and this pass completed that recent-scope cluster across them.

### Phase 4 block

Status: completed 2026-04-12

Completed the broader adjacent Hadith/Qur'an localization debt by surface instead of by raw key count:

1. Hadith browse and search
2. Hadith source browse and reader continuity
3. Qur'an memorization/review
4. Qur'an daily companion and personalization
5. Qur'an themes/topic discovery
6. Qur'an reference detail and learning-path handoff surfaces

Phase 4 completion notes:

- Replaced the remaining same-as-English fallback text across the targeted surface set in:
  - `ar`
  - `de`
  - `ur`
  - `hi`
  - `bn`
  - `fa`
  - `fa_AF`
  - `ha`
  - `id`
  - `ku`
  - `ms`
  - `pa`
  - `ps`
  - `tg`
  - `tr`
- Repaired ICU placeholder corruption introduced during machine-assisted translation on dynamic keys such as counts, destination labels, source/chapter summaries, and Qur'an companion titles.
- Regenerated localizations successfully with `flutter gen-l10n` after the placeholder repair pass.
- The only exact same-as-English value intentionally left in the audited surface set is the neutral placeholder-only composition `hadithSourceBrowseEntrySubtitle`, which is just `{reference} • {grade}` and contains no English wording.

## Recommended delivery order

1. Phase 1 now
2. Phase 2 next
3. Phase 3 after Phase 2 stabilizes
4. Phase 4 complete
4. Phase 4 only after the recent-scope misses are closed
