import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';

class CircleEventPreview {
  const CircleEventPreview({
    required this.id,
    required this.title,
    required this.dateHint,
  });

  final String id;
  final String title;
  final String dateHint;
}

class CircleCalendarEvent {
  const CircleCalendarEvent({
    required this.id,
    required this.circleId,
    required this.title,
    required this.dateIso,
    required this.location,
    required this.capacity,
    required this.description,
    this.baseGoingCount = 0,
    this.baseInterestedCount = 0,
    this.createdByRole = CircleEventCreatorRole.user,
    this.createdByLabel,
    this.status = CircleEventStatus.approved,
    this.approvedByLabel,
    this.approvedAtIso,
    this.rejectedByLabel,
    this.rejectedAtIso,
    this.moderationReason,
  });

  final String id;
  final String circleId;
  final String title;
  final String dateIso;
  final String location;
  final int capacity;
  final String description;
  final int baseGoingCount;
  final int baseInterestedCount;
  final CircleEventCreatorRole createdByRole;
  final String? createdByLabel;
  final CircleEventStatus status;
  final String? approvedByLabel;
  final String? approvedAtIso;
  final String? rejectedByLabel;
  final String? rejectedAtIso;
  final String? moderationReason;

  DateTime get date => DateTime.tryParse(dateIso) ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'circleId': circleId,
    'title': title,
    'dateIso': dateIso,
    'location': location,
    'capacity': capacity,
    'description': description,
    'baseGoingCount': baseGoingCount,
    'baseInterestedCount': baseInterestedCount,
    'createdByRole': createdByRole.name,
    'createdByLabel': createdByLabel,
    'status': status.name,
    'approvedByLabel': approvedByLabel,
    'approvedAtIso': approvedAtIso,
    'rejectedByLabel': rejectedByLabel,
    'rejectedAtIso': rejectedAtIso,
    'moderationReason': moderationReason,
  };

  static CircleCalendarEvent? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final id = raw['id']?.toString();
    final circleId = raw['circleId']?.toString();
    final title = raw['title']?.toString();
    final dateIso = raw['dateIso']?.toString();
    final location = raw['location']?.toString();
    final description = raw['description']?.toString();
    if (id == null ||
        circleId == null ||
        title == null ||
        dateIso == null ||
        location == null ||
        description == null) {
      return null;
    }

    final role = CircleEventCreatorRole.values.firstWhere(
      (item) => item.name == raw['createdByRole']?.toString(),
      orElse: () => CircleEventCreatorRole.user,
    );
    final status = CircleEventStatus.values.firstWhere(
      (item) => item.name == raw['status']?.toString(),
      orElse: () => CircleEventStatus.approved,
    );

    return CircleCalendarEvent(
      id: id,
      circleId: circleId,
      title: title,
      dateIso: dateIso,
      location: location,
      capacity: (raw['capacity'] as num?)?.toInt() ?? 20,
      description: description,
      baseGoingCount: (raw['baseGoingCount'] as num?)?.toInt() ?? 0,
      baseInterestedCount: (raw['baseInterestedCount'] as num?)?.toInt() ?? 0,
      createdByRole: role,
      createdByLabel: raw['createdByLabel']?.toString(),
      status: status,
      approvedByLabel: raw['approvedByLabel']?.toString(),
      approvedAtIso: raw['approvedAtIso']?.toString(),
      rejectedByLabel: raw['rejectedByLabel']?.toString(),
      rejectedAtIso: raw['rejectedAtIso']?.toString(),
      moderationReason: raw['moderationReason']?.toString(),
    );
  }
}

enum CircleEventRsvpStatus { none, going, interested, notGoing }

enum CircleEventCreatorRole { user, mosqueModerator }

enum CircleEventStatus { draft, pendingReview, approved, rejected }

class CommunityEventCreationPermissions {
  const CommunityEventCreationPermissions({
    required this.canSubmitUserEvent,
    required this.canSubmitModeratorEvent,
    required this.moderatorRequirementMet,
  });

  final bool canSubmitUserEvent;
  final bool canSubmitModeratorEvent;
  final bool moderatorRequirementMet;
}

class CircleEventAttendance {
  const CircleEventAttendance({
    required this.goingCount,
    required this.interestedCount,
    required this.capacity,
  });

  final int goingCount;
  final int interestedCount;
  final int capacity;

  int get spotsLeft => (capacity - goingCount).clamp(0, capacity);
  bool get waitlistActive => goingCount >= capacity;
}

class CircleEventRosterPreview {
  const CircleEventRosterPreview({
    required this.goingNames,
    required this.interestedNames,
    required this.waitlistCount,
  });

  final List<String> goingNames;
  final List<String> interestedNames;
  final int waitlistCount;
}

class CircleActivityPreview {
  const CircleActivityPreview({
    required this.author,
    required this.text,
    required this.type,
  });

  final String author;
  final String text;
  final String type;
}

class CircleItem {
  const CircleItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.tags,
    required this.memberCount,
    required this.privateCircle,
    required this.activity,
    required this.events,
    required this.recommendationWeight,
    required this.city,
    required this.focus,
    required this.mosqueBuddyFriendly,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> tags;
  final int memberCount;
  final bool privateCircle;
  final List<CircleActivityPreview> activity;
  final List<CircleEventPreview> events;
  final int recommendationWeight;
  final String city;
  final String focus;
  final bool mosqueBuddyFriendly;
}

class MosqueBuddyPreferences {
  const MosqueBuddyPreferences({
    required this.maxDistanceKm,
    required this.prayerHabits,
    required this.interests,
    required this.availabilityWindows,
  });

  final int maxDistanceKm;
  final int prayerHabits;
  final Set<String> interests;
  final Set<String> availabilityWindows;

  MosqueBuddyPreferences copyWith({
    int? maxDistanceKm,
    int? prayerHabits,
    Set<String>? interests,
    Set<String>? availabilityWindows,
  }) {
    return MosqueBuddyPreferences(
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
      prayerHabits: prayerHabits ?? this.prayerHabits,
      interests: interests ?? this.interests,
      availabilityWindows: availabilityWindows ?? this.availabilityWindows,
    );
  }

  Map<String, dynamic> toJson() => {
    'maxDistanceKm': maxDistanceKm,
    'prayerHabits': prayerHabits,
    'interests': interests.toList(),
    'availabilityWindows': availabilityWindows.toList(),
  };

  static MosqueBuddyPreferences fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const MosqueBuddyPreferences(
        maxDistanceKm: 10,
        prayerHabits: 3,
        interests: {'Masjid', 'Learning'},
        availabilityWindows: {'Fajr', 'Isha'},
      );
    }
    Set<String> toSet(dynamic raw) {
      final out = <String>{};
      if (raw is List) {
        for (final item in raw) {
          final text = item.toString();
          if (text.trim().isNotEmpty) out.add(text);
        }
      }
      return out;
    }

    return MosqueBuddyPreferences(
      maxDistanceKm: (json['maxDistanceKm'] as num?)?.toInt() ?? 10,
      prayerHabits: (json['prayerHabits'] as num?)?.toInt() ?? 3,
      interests: toSet(json['interests']),
      availabilityWindows: toSet(json['availabilityWindows']),
    );
  }
}

class MosqueBuddyCandidate {
  const MosqueBuddyCandidate({
    required this.id,
    required this.name,
    required this.city,
    required this.distanceKm,
    required this.prayerHabits,
    required this.interests,
    required this.availabilityWindows,
  });

  final String id;
  final String name;
  final String city;
  final int distanceKm;
  final int prayerHabits;
  final Set<String> interests;
  final Set<String> availabilityWindows;
}

class CommunityReportEntry {
  const CommunityReportEntry({
    required this.id,
    required this.targetType,
    required this.targetId,
    required this.reason,
    required this.createdAtIso,
  });

  final String id;
  final String targetType;
  final String targetId;
  final String reason;
  final String createdAtIso;

  Map<String, dynamic> toJson() => {
    'id': id,
    'targetType': targetType,
    'targetId': targetId,
    'reason': reason,
    'createdAtIso': createdAtIso,
  };

  static CommunityReportEntry? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final id = raw['id']?.toString();
    final targetType = raw['targetType']?.toString();
    final targetId = raw['targetId']?.toString();
    final reason = raw['reason']?.toString();
    final createdAtIso = raw['createdAtIso']?.toString();
    if (id == null ||
        targetType == null ||
        targetId == null ||
        reason == null ||
        createdAtIso == null) {
      return null;
    }
    return CommunityReportEntry(
      id: id,
      targetType: targetType,
      targetId: targetId,
      reason: reason,
      createdAtIso: createdAtIso,
    );
  }
}

enum CommunityTrustLevel { newMember, trusted, steward }

class AccountabilityGroup {
  const AccountabilityGroup({
    required this.id,
    required this.title,
    required this.description,
    required this.privateGroup,
    required this.focus,
    required this.memberCount,
    required this.defaultCadence,
  });

  final String id;
  final String title;
  final String description;
  final bool privateGroup;
  final String focus;
  final int memberCount;
  final String defaultCadence;
}

class NearbyMosque {
  const NearbyMosque({
    required this.id,
    required this.name,
    required this.city,
    required this.distanceKm,
    required this.timetable,
  });

  final String id;
  final String name;
  final String city;
  final double distanceKm;
  final Map<String, String> timetable;
}

const stagedCircles = <CircleItem>[
  CircleItem(
    id: 'hiking',
    title: 'Hiking Circle',
    description: 'Nature walks, reflection, and mindful movement.',
    category: 'Nature',
    tags: ['hiking', 'reflection', 'outdoors'],
    memberCount: 124,
    privateCircle: false,
    recommendationWeight: 86,
    city: 'Toronto',
    focus: 'Outdoor reflection + fitness',
    mosqueBuddyFriendly: true,
    activity: [
      CircleActivityPreview(
        author: 'Ameen',
        text: 'Shared a sunrise reflection trail note.',
        type: 'post',
      ),
    ],
    events: [
      CircleEventPreview(
        id: 'hike-1',
        title: 'Weekend Reflection Walk',
        dateHint: 'Saturday',
      ),
    ],
  ),
  CircleItem(
    id: 'study',
    title: 'Study Circle',
    description: 'Weekly learning goals and gentle accountability.',
    category: 'Learning',
    tags: ['study', 'quran', 'hadith'],
    memberCount: 268,
    privateCircle: false,
    recommendationWeight: 92,
    city: 'Mississauga',
    focus: 'Weekly study and accountability',
    mosqueBuddyFriendly: true,
    activity: [
      CircleActivityPreview(
        author: 'Safa',
        text: 'Posted a 7-day learning checkpoint.',
        type: 'checkpoint',
      ),
    ],
    events: [
      CircleEventPreview(
        id: 'study-1',
        title: 'Weekly Topic Roundup',
        dateHint: 'Tonight',
      ),
    ],
  ),
  CircleItem(
    id: 'photography',
    title: 'Photography Circle',
    description: 'Observe signs in creation through photo journaling.',
    category: 'Creativity',
    tags: ['photo', 'nature', 'journal'],
    memberCount: 96,
    privateCircle: false,
    recommendationWeight: 80,
    city: 'Vaughan',
    focus: 'Photo observation and journaling',
    mosqueBuddyFriendly: false,
    activity: [
      CircleActivityPreview(
        author: 'Rayyan',
        text: 'Shared moon observation with reflection notes.',
        type: 'observation',
      ),
    ],
    events: [
      CircleEventPreview(
        id: 'photo-1',
        title: 'Night & Day Photo Prompt',
        dateHint: 'This week',
      ),
    ],
  ),
  CircleItem(
    id: 'parents',
    title: 'Parenting Circle',
    description: 'Supportive reminders and practical family reflections.',
    category: 'Family',
    tags: ['parents', 'family', 'patience'],
    memberCount: 201,
    privateCircle: true,
    recommendationWeight: 78,
    city: 'Brampton',
    focus: 'Parenting support and family routines',
    mosqueBuddyFriendly: true,
    activity: [
      CircleActivityPreview(
        author: 'Noor',
        text: 'Shared bedtime gratitude routine for children.',
        type: 'tip',
      ),
    ],
    events: [
      CircleEventPreview(
        id: 'parent-1',
        title: 'Family Reflection Session',
        dateHint: 'Sunday',
      ),
    ],
  ),
  CircleItem(
    id: 'mosque-buddy',
    title: 'Masjid Buddy Forum',
    description:
        'Find local brothers/sisters for masjid prayers, classes, and safe community meetups.',
    category: 'Community',
    tags: ['masjid', 'buddy', 'community', 'salah'],
    memberCount: 332,
    privateCircle: false,
    recommendationWeight: 95,
    city: 'Greater Toronto Area',
    focus: 'Masjid attendance + community support',
    mosqueBuddyFriendly: true,
    activity: [
      CircleActivityPreview(
        author: 'Hafsa',
        text: 'Posted a Fajr carpool request near downtown.',
        type: 'meetup',
      ),
      CircleActivityPreview(
        author: 'Yusuf',
        text: 'Shared weekend sports meetup after Dhuhr.',
        type: 'sports',
      ),
    ],
    events: [
      CircleEventPreview(
        id: 'buddy-1',
        title: 'Jumu\'ah buddy check-in',
        dateHint: 'Friday',
      ),
      CircleEventPreview(
        id: 'buddy-2',
        title: 'Evening masjid walk group',
        dateHint: 'Wednesday',
      ),
    ],
  ),
];

final stagedCircleCalendarEvents = <CircleCalendarEvent>[
  CircleCalendarEvent(
    id: 'event-fajr-carpool',
    circleId: 'mosque-buddy',
    title: 'Fajr Carpool + Breakfast',
    dateIso: DateTime.now()
        .add(const Duration(days: 1, hours: 6))
        .toIso8601String(),
    location: 'Downtown Toronto Masjid',
    capacity: 12,
    description:
        'Coordinate safe pickups for Fajr and short post-prayer check-in.',
    baseGoingCount: 9,
    baseInterestedCount: 3,
  ),
  CircleCalendarEvent(
    id: 'event-jumuah-walk',
    circleId: 'mosque-buddy',
    title: 'Jumu\'ah Walk Group',
    dateIso: DateTime.now()
        .add(const Duration(days: 3, hours: 12))
        .toIso8601String(),
    location: 'Mississauga Community Mosque',
    capacity: 24,
    description:
        'Meet before khutbah, walk from parking together, and return as a group.',
    baseGoingCount: 18,
    baseInterestedCount: 5,
  ),
  CircleCalendarEvent(
    id: 'event-study-circle',
    circleId: 'study',
    title: 'Weekly Tafsir Focus Session',
    dateIso: DateTime.now()
        .add(const Duration(days: 2, hours: 19))
        .toIso8601String(),
    location: 'Islamic Learning Hub, Room B',
    capacity: 40,
    description:
        'Structured one-hour tafsir reading with partner reflection prompts.',
    baseGoingCount: 29,
    baseInterestedCount: 6,
  ),
  CircleCalendarEvent(
    id: 'event-family-circle',
    circleId: 'parents',
    title: 'Family Salah Habit Workshop',
    dateIso: DateTime.now()
        .add(const Duration(days: 5, hours: 15))
        .toIso8601String(),
    location: 'Brampton Family Centre',
    capacity: 28,
    description:
        'Practical routines for bedtime dhikr and family prayer consistency.',
    baseGoingCount: 22,
    baseInterestedCount: 4,
  ),
  CircleCalendarEvent(
    id: 'event-hike-reflect',
    circleId: 'hiking',
    title: 'Sunrise Reflection Trail',
    dateIso: DateTime.now()
        .add(const Duration(days: 6, hours: 7))
        .toIso8601String(),
    location: 'Rouge Urban Trail',
    capacity: 18,
    description:
        'Easy-level hike with short reflection breaks and gratitude journaling.',
    baseGoingCount: 17,
    baseInterestedCount: 4,
  ),
];

const stagedEventGoingRoster = <String, List<String>>{
  'event-fajr-carpool': ['A.K.', 'M.R.', 'S.H.', 'Y.A.'],
  'event-jumuah-walk': ['H.F.', 'R.K.', 'N.S.', 'B.A.', 'I.T.'],
  'event-study-circle': ['S.Q.', 'A.Z.', 'K.M.', 'F.H.'],
  'event-family-circle': ['N.A.', 'U.R.', 'M.K.'],
  'event-hike-reflect': ['A.Y.', 'R.S.', 'Z.K.'],
};

const stagedEventInterestedRoster = <String, List<String>>{
  'event-fajr-carpool': ['H.N.', 'L.R.'],
  'event-jumuah-walk': ['T.M.', 'W.A.', 'C.H.'],
  'event-study-circle': ['J.K.', 'D.S.'],
  'event-family-circle': ['P.R.'],
  'event-hike-reflect': ['S.A.', 'M.Z.'],
};

const stagedBuddyCandidates = <MosqueBuddyCandidate>[
  MosqueBuddyCandidate(
    id: 'buddy-amina',
    name: 'Amina',
    city: 'Toronto',
    distanceKm: 4,
    prayerHabits: 5,
    interests: {'Masjid', 'Qur\'an', 'Sports'},
    availabilityWindows: {'Fajr', 'Maghrib'},
  ),
  MosqueBuddyCandidate(
    id: 'buddy-yusuf',
    name: 'Yusuf',
    city: 'Mississauga',
    distanceKm: 8,
    prayerHabits: 4,
    interests: {'Masjid', 'Study', 'Volunteering'},
    availabilityWindows: {'Dhuhr', 'Isha'},
  ),
  MosqueBuddyCandidate(
    id: 'buddy-maryam',
    name: 'Maryam',
    city: 'Brampton',
    distanceKm: 13,
    prayerHabits: 3,
    interests: {'Family', 'Learning', 'Community'},
    availabilityWindows: {'Asr', 'Maghrib'},
  ),
  MosqueBuddyCandidate(
    id: 'buddy-ibrahim',
    name: 'Ibrahim',
    city: 'Vaughan',
    distanceKm: 6,
    prayerHabits: 5,
    interests: {'Masjid', 'Hiking', 'Community'},
    availabilityWindows: {'Fajr', 'Isha'},
  ),
];

const stagedAccountabilityGroups = <AccountabilityGroup>[
  AccountabilityGroup(
    id: 'group-prayer',
    title: 'Salah Consistency Circle',
    description: 'Private daily prayer check-ins and gentle encouragement.',
    privateGroup: true,
    focus: 'Salah',
    memberCount: 23,
    defaultCadence: 'Daily',
  ),
  AccountabilityGroup(
    id: 'group-fajr',
    title: 'Fajr Accountability Group',
    description: 'Fajr wakeup support and weekly streak targets.',
    privateGroup: true,
    focus: 'Fajr',
    memberCount: 17,
    defaultCadence: 'Daily',
  ),
  AccountabilityGroup(
    id: 'group-habits',
    title: 'Habit Builder Group',
    description:
        'Track Qur\'an, dhikr, and reflections with trust-based reporting.',
    privateGroup: true,
    focus: 'Habits',
    memberCount: 31,
    defaultCadence: 'Weekly',
  ),
];

const stagedNearbyMosques = <NearbyMosque>[
  NearbyMosque(
    id: 'mosque-downtown',
    name: 'Downtown Islamic Centre',
    city: 'Toronto',
    distanceKm: 2.4,
    timetable: {
      'Fajr': '5:36 AM',
      'Dhuhr': '1:15 PM',
      'Asr': '4:47 PM',
      'Maghrib': '7:12 PM',
      'Isha': '8:43 PM',
    },
  ),
  NearbyMosque(
    id: 'mosque-mississauga',
    name: 'Mississauga Jami Masjid',
    city: 'Mississauga',
    distanceKm: 6.1,
    timetable: {
      'Fajr': '5:34 AM',
      'Dhuhr': '1:14 PM',
      'Asr': '4:45 PM',
      'Maghrib': '7:10 PM',
      'Isha': '8:41 PM',
    },
  ),
  NearbyMosque(
    id: 'mosque-brampton',
    name: 'Brampton Community Masjid',
    city: 'Brampton',
    distanceKm: 9.3,
    timetable: {
      'Fajr': '5:32 AM',
      'Dhuhr': '1:13 PM',
      'Asr': '4:43 PM',
      'Maghrib': '7:08 PM',
      'Isha': '8:39 PM',
    },
  ),
];

class CirclesState {
  const CirclesState({
    required this.joinedIds,
    required this.favoritedIds,
    required this.savedIds,
    required this.selectedCategory,
    required this.eventRsvpById,
    required this.buddyPreferences,
    required this.reports,
    required this.trustScore,
    required this.joinedAccountabilityGroupIds,
    required this.accountabilityCheckins,
    required this.importedMosqueIds,
    required this.selectedMosqueId,
    required this.createdEvents,
  });

  final Set<String> joinedIds;
  final Set<String> favoritedIds;
  final Set<String> savedIds;
  final String selectedCategory;
  final Map<String, CircleEventRsvpStatus> eventRsvpById;
  final MosqueBuddyPreferences buddyPreferences;
  final List<CommunityReportEntry> reports;
  final int trustScore;
  final Set<String> joinedAccountabilityGroupIds;
  final Map<String, int> accountabilityCheckins;
  final Set<String> importedMosqueIds;
  final String? selectedMosqueId;
  final List<CircleCalendarEvent> createdEvents;

  CirclesState copyWith({
    Set<String>? joinedIds,
    Set<String>? favoritedIds,
    Set<String>? savedIds,
    String? selectedCategory,
    Map<String, CircleEventRsvpStatus>? eventRsvpById,
    MosqueBuddyPreferences? buddyPreferences,
    List<CommunityReportEntry>? reports,
    int? trustScore,
    Set<String>? joinedAccountabilityGroupIds,
    Map<String, int>? accountabilityCheckins,
    Set<String>? importedMosqueIds,
    String? selectedMosqueId,
    List<CircleCalendarEvent>? createdEvents,
    bool clearSelectedMosque = false,
  }) {
    return CirclesState(
      joinedIds: joinedIds ?? this.joinedIds,
      favoritedIds: favoritedIds ?? this.favoritedIds,
      savedIds: savedIds ?? this.savedIds,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      eventRsvpById: eventRsvpById ?? this.eventRsvpById,
      buddyPreferences: buddyPreferences ?? this.buddyPreferences,
      reports: reports ?? this.reports,
      trustScore: trustScore ?? this.trustScore,
      joinedAccountabilityGroupIds:
          joinedAccountabilityGroupIds ?? this.joinedAccountabilityGroupIds,
      accountabilityCheckins:
          accountabilityCheckins ?? this.accountabilityCheckins,
      importedMosqueIds: importedMosqueIds ?? this.importedMosqueIds,
      selectedMosqueId: clearSelectedMosque
          ? null
          : (selectedMosqueId ?? this.selectedMosqueId),
      createdEvents: createdEvents ?? this.createdEvents,
    );
  }

  Map<String, dynamic> toJson() => {
    'joinedIds': joinedIds.toList(),
    'favoritedIds': favoritedIds.toList(),
    'savedIds': savedIds.toList(),
    'selectedCategory': selectedCategory,
    'eventRsvpById': {
      for (final entry in eventRsvpById.entries) entry.key: entry.value.name,
    },
    'buddyPreferences': buddyPreferences.toJson(),
    'reports': reports.map((item) => item.toJson()).toList(),
    'trustScore': trustScore,
    'joinedAccountabilityGroupIds': joinedAccountabilityGroupIds.toList(),
    'accountabilityCheckins': accountabilityCheckins,
    'importedMosqueIds': importedMosqueIds.toList(),
    'selectedMosqueId': selectedMosqueId,
    'createdEvents': createdEvents.map((item) => item.toJson()).toList(),
  };

  static CirclesState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CirclesState(
        joinedIds: {},
        favoritedIds: {},
        savedIds: {},
        selectedCategory: 'All',
        eventRsvpById: {},
        buddyPreferences: MosqueBuddyPreferences(
          maxDistanceKm: 10,
          prayerHabits: 3,
          interests: {'Masjid', 'Learning'},
          availabilityWindows: {'Fajr', 'Isha'},
        ),
        reports: [],
        trustScore: 30,
        joinedAccountabilityGroupIds: {},
        accountabilityCheckins: {},
        importedMosqueIds: {},
        selectedMosqueId: null,
        createdEvents: [],
      );
    }

    Set<String> parseSet(dynamic raw) {
      final out = <String>{};
      if (raw is List) {
        for (final item in raw) {
          out.add(item.toString());
        }
      }
      return out;
    }

    final eventRsvp = <String, CircleEventRsvpStatus>{};
    final rawRsvp = json['eventRsvpById'];
    if (rawRsvp is Map) {
      for (final entry in rawRsvp.entries) {
        final value = CircleEventRsvpStatus.values.firstWhere(
          (item) => item.name == entry.value?.toString(),
          orElse: () => CircleEventRsvpStatus.none,
        );
        eventRsvp[entry.key.toString()] = value;
      }
    }

    final reports = <CommunityReportEntry>[];
    final rawReports = json['reports'];
    if (rawReports is List) {
      for (final row in rawReports) {
        final parsed = CommunityReportEntry.fromJson(row);
        if (parsed != null) reports.add(parsed);
      }
    }

    final checkins = <String, int>{};
    final rawCheckins = json['accountabilityCheckins'];
    if (rawCheckins is Map) {
      for (final entry in rawCheckins.entries) {
        checkins[entry.key.toString()] = (entry.value as num?)?.toInt() ?? 0;
      }
    }

    final createdEvents = <CircleCalendarEvent>[];
    final rawCreatedEvents = json['createdEvents'];
    if (rawCreatedEvents is List) {
      for (final row in rawCreatedEvents) {
        final parsed = CircleCalendarEvent.fromJson(row);
        if (parsed != null) createdEvents.add(parsed);
      }
    }

    return CirclesState(
      joinedIds: parseSet(json['joinedIds']),
      favoritedIds: parseSet(json['favoritedIds']),
      savedIds: parseSet(json['savedIds']),
      selectedCategory: json['selectedCategory']?.toString() ?? 'All',
      eventRsvpById: eventRsvp,
      buddyPreferences: MosqueBuddyPreferences.fromJson(
        json['buddyPreferences'] as Map<String, dynamic>?,
      ),
      reports: reports,
      trustScore: (json['trustScore'] as num?)?.toInt() ?? 30,
      joinedAccountabilityGroupIds: parseSet(
        json['joinedAccountabilityGroupIds'],
      ),
      accountabilityCheckins: checkins,
      importedMosqueIds: parseSet(json['importedMosqueIds']),
      selectedMosqueId: json['selectedMosqueId']?.toString(),
      createdEvents: createdEvents,
    );
  }
}

class CirclesNotifier extends StateNotifier<CirclesState> {
  CirclesNotifier(this._store)
    : super(CirclesState.fromJson(_store.getJsonMap(_key)));

  static const _key = 'community.circles';
  final LocalStore _store;

  void toggleJoin(String id) {
    final next = Set<String>.from(state.joinedIds);
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    state = state.copyWith(joinedIds: next);
    _save();
  }

  void toggleFavorite(String id) {
    final next = Set<String>.from(state.favoritedIds);
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    state = state.copyWith(favoritedIds: next);
    _save();
  }

  void toggleSaved(String id) {
    final next = Set<String>.from(state.savedIds);
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    state = state.copyWith(savedIds: next);
    _save();
  }

  void selectCategory(String category) {
    state = state.copyWith(selectedCategory: category);
    _save();
  }

  void setEventRsvp(String eventId, CircleEventRsvpStatus rsvp) {
    final event = _eventById(eventId);
    var resolved = rsvp;
    if (event != null && rsvp == CircleEventRsvpStatus.going) {
      final currentStatus =
          state.eventRsvpById[eventId] ?? CircleEventRsvpStatus.none;
      final currentlyGoing = currentStatus == CircleEventRsvpStatus.going;
      final projectedGoing = event.baseGoingCount + (currentlyGoing ? 0 : 1);
      if (projectedGoing > event.capacity) {
        resolved = CircleEventRsvpStatus.interested;
      }
    }
    final next = Map<String, CircleEventRsvpStatus>.from(state.eventRsvpById)
      ..[eventId] = resolved;
    state = state.copyWith(eventRsvpById: next);
    _save();
  }

  void setBuddyPreferences(MosqueBuddyPreferences preferences) {
    state = state.copyWith(buddyPreferences: preferences);
    _save();
  }

  void addReport({
    required String targetType,
    required String targetId,
    required String reason,
  }) {
    final next = [
      CommunityReportEntry(
        id: 'report-${DateTime.now().millisecondsSinceEpoch}',
        targetType: targetType,
        targetId: targetId,
        reason: reason,
        createdAtIso: DateTime.now().toIso8601String(),
      ),
      ...state.reports,
    ];
    final trustDelta = reason == 'safety' ? -2 : -1;
    state = state.copyWith(
      reports: next.take(30).toList(),
      trustScore: (state.trustScore + trustDelta).clamp(0, 100),
    );
    _save();
  }

  void toggleAccountabilityGroup(String groupId) {
    final next = Set<String>.from(state.joinedAccountabilityGroupIds);
    if (next.contains(groupId)) {
      next.remove(groupId);
    } else {
      next.add(groupId);
    }
    state = state.copyWith(joinedAccountabilityGroupIds: next);
    _save();
  }

  void checkInAccountabilityGroup(String groupId) {
    final next = Map<String, int>.from(state.accountabilityCheckins);
    next[groupId] = (next[groupId] ?? 0) + 1;
    state = state.copyWith(accountabilityCheckins: next);
    _save();
  }

  void toggleMosqueImported(String mosqueId) {
    final next = Set<String>.from(state.importedMosqueIds);
    if (next.contains(mosqueId)) {
      next.remove(mosqueId);
      state = state.copyWith(
        importedMosqueIds: next,
        clearSelectedMosque: state.selectedMosqueId == mosqueId,
      );
    } else {
      next.add(mosqueId);
      state = state.copyWith(
        importedMosqueIds: next,
        selectedMosqueId: mosqueId,
      );
    }
    _save();
  }

  void selectMosque(String mosqueId) {
    state = state.copyWith(selectedMosqueId: mosqueId);
    _save();
  }

  void createEvent({
    required String circleId,
    required String title,
    required DateTime date,
    required String location,
    required int capacity,
    required String description,
    CircleEventCreatorRole role = CircleEventCreatorRole.user,
    String? creatorLabel,
  }) {
    final trustLevel = _trustLevelForScore(state.trustScore);
    final canModeratorCreate =
        trustLevel == CommunityTrustLevel.steward &&
        state.importedMosqueIds.isNotEmpty;
    final resolvedRole =
        role == CircleEventCreatorRole.mosqueModerator && canModeratorCreate
        ? CircleEventCreatorRole.mosqueModerator
        : CircleEventCreatorRole.user;

    final item = CircleCalendarEvent(
      id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
      circleId: circleId,
      title: title.trim(),
      dateIso: date.toIso8601String(),
      location: location.trim(),
      capacity: capacity.clamp(5, 500),
      description: description.trim(),
      createdByRole: resolvedRole,
      createdByLabel: creatorLabel?.trim().isEmpty == true
          ? null
          : creatorLabel?.trim(),
      status: resolvedRole == CircleEventCreatorRole.user
          ? CircleEventStatus.pendingReview
          : CircleEventStatus.approved,
    );
    state = state.copyWith(createdEvents: [item, ...state.createdEvents]);
    _save();
  }

  void approveEvent(String eventId) {
    _updateCreatedEventStatus(
      eventId,
      CircleEventStatus.approved,
      actorLabel: 'Community Steward',
    );
  }

  void rejectEvent(String eventId) {
    _updateCreatedEventStatus(
      eventId,
      CircleEventStatus.rejected,
      actorLabel: 'Community Steward',
      reason: 'Policy or safety concern',
    );
  }

  void _updateCreatedEventStatus(
    String eventId,
    CircleEventStatus status, {
    String? actorLabel,
    String? reason,
  }) {
    final nowIso = DateTime.now().toIso8601String();
    final next = state.createdEvents.map((event) {
      if (event.id != eventId) return event;
      return CircleCalendarEvent(
        id: event.id,
        circleId: event.circleId,
        title: event.title,
        dateIso: event.dateIso,
        location: event.location,
        capacity: event.capacity,
        description: event.description,
        baseGoingCount: event.baseGoingCount,
        baseInterestedCount: event.baseInterestedCount,
        createdByRole: event.createdByRole,
        createdByLabel: event.createdByLabel,
        status: status,
        approvedByLabel: status == CircleEventStatus.approved
            ? actorLabel
            : event.approvedByLabel,
        approvedAtIso: status == CircleEventStatus.approved
            ? nowIso
            : event.approvedAtIso,
        rejectedByLabel: status == CircleEventStatus.rejected
            ? actorLabel
            : event.rejectedByLabel,
        rejectedAtIso: status == CircleEventStatus.rejected
            ? nowIso
            : event.rejectedAtIso,
        moderationReason: status == CircleEventStatus.rejected
            ? reason
            : event.moderationReason,
      );
    }).toList();
    state = state.copyWith(createdEvents: next);
    _save();
  }

  void _save() {
    _store.setJsonMap(_key, state.toJson());
  }

  CircleCalendarEvent? _eventById(String id) {
    for (final event in _allEvents()) {
      if (event.id == id) return event;
    }
    return null;
  }

  List<CircleCalendarEvent> _allEvents() {
    return [...stagedCircleCalendarEvents, ...state.createdEvents];
  }
}

final circlesProvider = StateNotifierProvider<CirclesNotifier, CirclesState>(
  (ref) => CirclesNotifier(ref.watch(localStoreProvider)),
);

final circleCategoriesProvider = Provider<List<String>>((ref) {
  final set = <String>{'All'};
  for (final circle in stagedCircles) {
    set.add(circle.category);
  }
  return set.toList();
});

final filteredCirclesProvider = Provider<List<CircleItem>>((ref) {
  final selected = ref.watch(circlesProvider).selectedCategory;
  if (selected == 'All') return stagedCircles;
  return stagedCircles.where((circle) => circle.category == selected).toList();
});

final joinedCirclesProvider = Provider<List<CircleItem>>((ref) {
  final joined = ref.watch(circlesProvider).joinedIds;
  return stagedCircles.where((circle) => joined.contains(circle.id)).toList();
});

final favoritedCirclesProvider = Provider<List<CircleItem>>((ref) {
  final ids = ref.watch(circlesProvider).favoritedIds;
  return stagedCircles.where((circle) => ids.contains(circle.id)).toList();
});

final recommendedCirclesProvider = Provider<List<CircleItem>>((ref) {
  final circles = ref.watch(filteredCirclesProvider);
  final sorted = [...circles]
    ..sort((a, b) => b.recommendationWeight.compareTo(a.recommendationWeight));
  return sorted.take(3).toList();
});

final circleEventsProvider = Provider<List<CircleCalendarEvent>>((ref) {
  final created = ref.watch(circlesProvider).createdEvents;
  final approvedCreated = created
      .where((event) => event.status == CircleEventStatus.approved)
      .toList();
  final list = [...stagedCircleCalendarEvents, ...approvedCreated]
    ..sort((a, b) => a.date.compareTo(b.date));
  return list;
});

final pendingCircleEventsProvider = Provider<List<CircleCalendarEvent>>((ref) {
  final created = ref.watch(circlesProvider).createdEvents;
  final list =
      created
          .where((event) => event.status == CircleEventStatus.pendingReview)
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
  return list;
});

final rejectedCircleEventsProvider = Provider<List<CircleCalendarEvent>>((ref) {
  final created = ref.watch(circlesProvider).createdEvents;
  final list =
      created
          .where((event) => event.status == CircleEventStatus.rejected)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
  return list;
});

final reportCountByEventProvider = Provider<Map<String, int>>((ref) {
  final reports = ref.watch(circlesProvider).reports;
  final counts = <String, int>{};
  for (final report in reports) {
    if (report.targetType != 'event') continue;
    counts[report.targetId] = (counts[report.targetId] ?? 0) + 1;
  }
  return counts;
});

final circleEventsByCircleProvider =
    Provider.family<List<CircleCalendarEvent>, String>((ref, circleId) {
      return ref
          .watch(circleEventsProvider)
          .where((event) => event.circleId == circleId)
          .toList();
    });

final upcomingEventsProvider = Provider<List<CircleCalendarEvent>>((ref) {
  final now = DateTime.now();
  return ref
      .watch(circleEventsProvider)
      .where(
        (event) => event.date.isAfter(now.subtract(const Duration(hours: 1))),
      )
      .toList();
});

final circleEventsForMonthProvider =
    Provider.family<List<CircleCalendarEvent>, DateTime>((ref, month) {
      return ref.watch(circleEventsProvider).where((event) {
        return event.date.year == month.year && event.date.month == month.month;
      }).toList();
    });

final circleEventsForDayProvider =
    Provider.family<List<CircleCalendarEvent>, DateTime>((ref, day) {
      return ref.watch(circleEventsProvider).where((event) {
        final date = event.date;
        return date.year == day.year &&
            date.month == day.month &&
            date.day == day.day;
      }).toList();
    });

final circleEventAttendanceProvider =
    Provider.family<CircleEventAttendance, String>((ref, eventId) {
      final events = ref.watch(circleEventsProvider);
      final state = ref.watch(circlesProvider);
      CircleCalendarEvent? event;
      for (final item in events) {
        if (item.id == eventId) {
          event = item;
          break;
        }
      }
      if (event == null) {
        return const CircleEventAttendance(
          goingCount: 0,
          interestedCount: 0,
          capacity: 1,
        );
      }
      final status = state.eventRsvpById[eventId] ?? CircleEventRsvpStatus.none;
      var going = event.baseGoingCount;
      var interested = event.baseInterestedCount;
      if (status == CircleEventRsvpStatus.going) {
        going += 1;
      } else if (status == CircleEventRsvpStatus.interested) {
        interested += 1;
      }
      return CircleEventAttendance(
        goingCount: going,
        interestedCount: interested,
        capacity: event.capacity,
      );
    });

final circleEventRosterPreviewProvider =
    Provider.family<CircleEventRosterPreview, String>((ref, eventId) {
      final attendance = ref.watch(circleEventAttendanceProvider(eventId));
      final status = ref.watch(
        circlesProvider.select(
          (state) => state.eventRsvpById[eventId] ?? CircleEventRsvpStatus.none,
        ),
      );
      final baseGoing = stagedEventGoingRoster[eventId] ?? const <String>[];
      final baseInterested =
          stagedEventInterestedRoster[eventId] ?? const <String>[];

      final going = <String>[...baseGoing];
      final interested = <String>[...baseInterested];

      if (status == CircleEventRsvpStatus.going && !going.contains('You')) {
        going.insert(0, 'You');
      }
      if (status == CircleEventRsvpStatus.interested &&
          !interested.contains('You')) {
        interested.insert(0, 'You');
      }

      final waitlistCount = attendance.waitlistActive
          ? attendance.interestedCount
          : 0;

      return CircleEventRosterPreview(
        goingNames: going.take(5).toList(),
        interestedNames: interested.take(5).toList(),
        waitlistCount: waitlistCount,
      );
    });

final mosqueBuddyMatchesProvider = Provider<List<MosqueBuddyCandidate>>((ref) {
  final prefs = ref.watch(circlesProvider).buddyPreferences;
  final scored = <({MosqueBuddyCandidate candidate, int score})>[];

  for (final candidate in stagedBuddyCandidates) {
    if (candidate.distanceKm > prefs.maxDistanceKm) continue;

    var score = 0;
    score += (6 - (candidate.prayerHabits - prefs.prayerHabits).abs()).clamp(
      0,
      6,
    );

    final sharedInterests = candidate.interests
        .where((interest) => prefs.interests.contains(interest))
        .length;
    score += sharedInterests * 4;

    final sharedAvailability = candidate.availabilityWindows
        .where((item) => prefs.availabilityWindows.contains(item))
        .length;
    score += sharedAvailability * 3;

    score += (prefs.maxDistanceKm - candidate.distanceKm).clamp(0, 15);

    scored.add((candidate: candidate, score: score));
  }

  scored.sort((a, b) => b.score.compareTo(a.score));
  return scored.map((item) => item.candidate).take(8).toList();
});

final communityTrustLevelProvider = Provider<CommunityTrustLevel>((ref) {
  final trust = ref.watch(circlesProvider).trustScore;
  return _trustLevelForScore(trust);
});

final communityEventCreationPermissionsProvider =
    Provider<CommunityEventCreationPermissions>((ref) {
      final state = ref.watch(circlesProvider);
      final trustLevel = ref.watch(communityTrustLevelProvider);
      final moderatorRequirementMet =
          trustLevel == CommunityTrustLevel.steward &&
          state.importedMosqueIds.isNotEmpty;
      return CommunityEventCreationPermissions(
        canSubmitUserEvent: true,
        canSubmitModeratorEvent: moderatorRequirementMet,
        moderatorRequirementMet: moderatorRequirementMet,
      );
    });

final accountabilityGroupsProvider = Provider<List<AccountabilityGroup>>((ref) {
  return stagedAccountabilityGroups;
});

final joinedAccountabilityGroupsProvider = Provider<List<AccountabilityGroup>>((
  ref,
) {
  final ids = ref.watch(circlesProvider).joinedAccountabilityGroupIds;
  return stagedAccountabilityGroups
      .where((group) => ids.contains(group.id))
      .toList();
});

final nearbyMosquesProvider = Provider<List<NearbyMosque>>((ref) {
  return stagedNearbyMosques;
});

final selectedMosqueProvider = Provider<NearbyMosque?>((ref) {
  final state = ref.watch(circlesProvider);
  final mosques = ref.watch(nearbyMosquesProvider);
  final selectedId = state.selectedMosqueId;
  if (selectedId == null || selectedId.isEmpty) {
    return state.importedMosqueIds.isEmpty
        ? null
        : mosques.firstWhere(
            (mosque) => state.importedMosqueIds.contains(mosque.id),
            orElse: () => mosques.first,
          );
  }
  for (final mosque in mosques) {
    if (mosque.id == selectedId) return mosque;
  }
  return null;
});

CommunityTrustLevel _trustLevelForScore(int trust) {
  if (trust >= 75) return CommunityTrustLevel.steward;
  if (trust >= 40) return CommunityTrustLevel.trusted;
  return CommunityTrustLevel.newMember;
}
