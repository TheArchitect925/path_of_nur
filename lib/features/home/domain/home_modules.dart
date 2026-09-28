/// The reorderable/hideable sections of the Mihrab Home. The salah hero,
/// the greeting, and the conditional occasion/mode cards are pinned and are
/// deliberately not modules.
enum HomeModule {
  prayerStrip('prayer_strip'),
  today('today'),
  garden('garden'),
  duasNow('duas_now'),
  onThisDay('on_this_day'),
  celestial('celestial');

  const HomeModule(this.storageId);

  /// Stable id persisted in `home.modules.v1`; never rename.
  final String storageId;

  static HomeModule? fromStorageId(String id) {
    for (final module in HomeModule.values) {
      if (module.storageId == id) return module;
    }
    return null;
  }
}

const List<HomeModule> kDefaultHomeModuleOrder = <HomeModule>[
  HomeModule.prayerStrip,
  HomeModule.today,
  HomeModule.garden,
  // The day's context closes Home in one arc: what happened on this day,
  // the duas that suit right now, then tonight's sky.
  HomeModule.onThisDay,
  HomeModule.duasNow,
  HomeModule.celestial,
];

class HomeModulePrefs {
  const HomeModulePrefs({
    this.order = kDefaultHomeModuleOrder,
    this.hidden = const <HomeModule>{},
  });

  /// Full ordering over every module, visible or hidden.
  final List<HomeModule> order;
  final Set<HomeModule> hidden;

  List<HomeModule> get visible =>
      order.where((module) => !hidden.contains(module)).toList(growable: false);

  bool isVisible(HomeModule module) => !hidden.contains(module);

  HomeModulePrefs copyWith({List<HomeModule>? order, Set<HomeModule>? hidden}) {
    return HomeModulePrefs(
      order: order ?? this.order,
      hidden: hidden ?? this.hidden,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'order': order.map((module) => module.storageId).toList(),
    'hidden': hidden.map((module) => module.storageId).toList(),
  };

  /// Unknown ids are dropped; modules missing from a stored order are
  /// appended in default position so new modules appear after app updates.
  factory HomeModulePrefs.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const HomeModulePrefs();
    final storedOrder = (json['order'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .map(HomeModule.fromStorageId)
        .whereType<HomeModule>()
        .toList();
    for (final module in kDefaultHomeModuleOrder) {
      if (!storedOrder.contains(module)) storedOrder.add(module);
    }
    final hidden = (json['hidden'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .map(HomeModule.fromStorageId)
        .whereType<HomeModule>()
        .toSet();
    return HomeModulePrefs(order: storedOrder, hidden: hidden);
  }
}
