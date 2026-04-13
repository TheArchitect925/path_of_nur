import '../domain/hadith_narrator_models.dart';

const seededHadithNarratorProfiles = <HadithNarratorProfile>[
  HadithNarratorProfile(
    id: 'abu_hurairah',
    displayName: 'Abu Hurairah',
    role: HadithNarratorRole.companion,
    summaryKind: HadithNarratorSummaryKind.abuHurairah,
    aliases: <String>['Abu Hurayrah'],
    matchAliases: <String>['abu hurairah', 'abu hurayrah'],
  ),
  HadithNarratorProfile(
    id: 'aishah_bint_abi_bakr',
    displayName: 'Aishah bint Abi Bakr',
    role: HadithNarratorRole.motherOfBelievers,
    summaryKind: HadithNarratorSummaryKind.aishah,
    aliases: <String>['Aishah', "'Aishah"],
    matchAliases: <String>['aishah', "'aishah", 'a ishah'],
  ),
  HadithNarratorProfile(
    id: 'abdullah_ibn_umar',
    displayName: 'Abdullah ibn Umar',
    role: HadithNarratorRole.companion,
    summaryKind: HadithNarratorSummaryKind.abdullahIbnUmar,
    aliases: <String>["Ibn Umar"],
    matchAliases: <String>['abdullah ibn umar', 'ibn umar'],
  ),
  HadithNarratorProfile(
    id: 'anas_ibn_malik',
    displayName: 'Anas ibn Malik',
    role: HadithNarratorRole.companion,
    summaryKind: HadithNarratorSummaryKind.anasIbnMalik,
    aliases: <String>['Anas'],
    matchAliases: <String>['anas ibn malik', 'anas'],
  ),
  HadithNarratorProfile(
    id: 'jabir_ibn_abdullah',
    displayName: 'Jabir ibn Abdullah',
    role: HadithNarratorRole.companion,
    summaryKind: HadithNarratorSummaryKind.jabirIbnAbdullah,
    aliases: <String>['Jabir'],
    matchAliases: <String>['jabir ibn abdullah', 'jabir'],
  ),
  HadithNarratorProfile(
    id: 'abdullah_ibn_abbas',
    displayName: 'Abdullah ibn Abbas',
    role: HadithNarratorRole.scholarCompanion,
    summaryKind: HadithNarratorSummaryKind.abdullahIbnAbbas,
    aliases: <String>["Ibn Abbas"],
    matchAliases: <String>['abdullah ibn abbas', 'ibn abbas'],
  ),
];
