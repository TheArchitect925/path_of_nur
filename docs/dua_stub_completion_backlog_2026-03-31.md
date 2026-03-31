# Dua Stub Completion Backlog

Date: 2026-03-31

This backlog tracks the next safe completion phases after the first Qur'anic dua batch.

## Current progress

- Phase 1 daily-life batch is now complete for the titled daily-life stubs:
  - morning/evening adhkar
  - sleep adhkar
  - food and host duas
  - clothing and washroom adhkar
  - simple daily dhikr entries
- Phase 2 prayer-and-worship batch is now complete for the titled worship stubs:
  - salah opening supplications
  - sujud duas
  - after-salah adhkar
  - wudu adhkar
  - adhan response
  - istikharah
  - Hajj and Umrah adhkar
- Phase 3 situational-and-travel batch is now complete for the titled travel and high-confidence situational stubs:
  - travel, return, lodging, weather, market, and town-entry duas
  - fear, anger, debt, grief, calamity, oppression, and distress duas
  - illness visitation, healing, and ruqyah duas
  - beneficial and lawful provision duas
- Phase 4 home-family-and-special-days batch is now complete for the titled family and occasion-based stubs:
  - spouse, children, newborn, marriage, household-protection, parent, relative, and host/guest duas
  - last-ten-nights, Eid, Dhul-Hijjah, Arafah, new-moon, rain, and eclipse entries
- Phase 5 forgiveness-and-growth batch is now complete for the titled growth stubs:
  - repentance and istighfar duas
  - gratitude, guidance, light, steadfastness, and character duas
  - beneficial knowledge, halal provision, and acceptance-of-deeds duas
- The daily-life generic `planned` placeholders remain unfilled because they still need curated product naming before source work can be done responsibly.
- The final `Planned Dua 138-152` placeholders also remain intentionally unfilled because they still do not map to clearly named source-backed entries.
- One weak-authenticity placeholder was not forced through as-is:
  - `Looking in the Mirror` was replaced with the stronger attested `Before Removing Clothes` clothing dhikr to keep the verified set aligned with authentic-source guardrails.
- Several worship placeholders were normalized into stronger source-backed entries instead of keeping non-fixed topic labels:
  - `Going Early to Jumu'ah` -> `On Friday: Send Blessings upon the Prophet`
  - `Seeing the Ka'bah` -> `At the Ka'bah: Good in This Life and the Next`
  - `After Finishing Qur'an` -> `Closing Dhikr after a Qur'an Reading Gathering`
- Several situational placeholders were normalized to avoid duplicate or misleading coverage:
  - `Need and Dependence on Allah` -> `Entrusting All Affairs to Allah`
  - `When Confused` -> `When Troubled by Doubt or Confusion`
  - `Master Supplication for Forgiveness` -> `Repentance and Seeking Forgiveness`
  - `Firmness in Trials` -> `Relief in Severe Distress`
  - `Protection from the Evil Eye` -> `When You Fear Giving the Evil Eye`
- Several home/family and special-days placeholders were normalized to stay source-safe:
  - `Tahnik and Barakah` -> `Reply to Newborn Congratulations`
  - `Protection for the Home` -> `Securing the Home at Night with Allah's Name`
  - `End of Ramadan` -> `Last Ten Nights: Ask for Pardon`
  - `First Ten Days of Dhul-Hijjah` -> `Takbir in the First Ten Days of Dhul-Hijjah`
- The final forgiveness-and-growth pass also made one indexing-safe focused normalization:
  - `Simple Istighfar` -> `Forgive Me and Accept My Repentance`

## Next completion priorities

- Curate real product names and source scope for `Planned Dua 138-152` before filling them.
- Run one final duplicate review across semantically overlapping duas that intentionally appear in multiple categories for discoverability.
- Run one consistency pass across all completed entries before release.

## Consistency enhancements

- Run a dedicated consistency pass across all complete duas so title style, source formatting, transliteration style, and tag quality are uniform.
- Decide whether all Qur'anic dua entries should use one shared translation style and transliteration style, then normalize the earlier complete entries to match.
- Decide whether category-level discoverability should keep a few intentional overlaps such as:
  - knowledge / provision / accepted deeds
  - halal provision
  - acceptance after worship
- Add a lightweight validation script for the dua dataset that checks:
  - no empty complete entries
  - every complete entry has source type and source ref
  - every complete entry has at least one tag
  - dataset counts match actual completion status totals

## Localization follow-up

- Keep dua content centralized in the seed dataset for now, but plan a structured export path so the English glosses and helper copy can move into localization resources later without scattering strings across widgets.

## Islamic content governance

- Run a final scholarly QA pass over newly completed entries before public release.
- Document the primary source used for each completed non-Qur'anic dua once those batches are added.
