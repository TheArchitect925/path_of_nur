import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import '../domain/home_modules.dart';

const String _homeModulePrefsKey = 'home.modules.v1';

final homeModulePrefsProvider =
    NotifierProvider<HomeModulePrefsNotifier, HomeModulePrefs>(
      HomeModulePrefsNotifier.new,
    );

class HomeModulePrefsNotifier extends Notifier<HomeModulePrefs> {
  @override
  HomeModulePrefs build() {
    final store = ref.watch(localStoreProvider);
    return HomeModulePrefs.fromJson(store.getJsonMap(_homeModulePrefsKey));
  }

  void setVisible(HomeModule module, bool visible) {
    final hidden = Set<HomeModule>.from(state.hidden);
    if (visible) {
      hidden.remove(module);
    } else {
      hidden.add(module);
    }
    _persist(state.copyWith(hidden: hidden));
  }

  /// Reorders within the VISIBLE list (the edit screen's reorderable list).
  /// Indices follow [ReorderableListView.onReorderItem] semantics: [toIndex]
  /// is already adjusted for the removed item. Hidden modules keep their
  /// relative slot at the end of the order.
  void reorderVisible(int fromIndex, int toIndex) {
    final visible = state.visible.toList();
    if (fromIndex < 0 || fromIndex >= visible.length) return;
    final target = toIndex.clamp(0, visible.length - 1);
    final moved = visible.removeAt(fromIndex);
    visible.insert(target, moved);
    final hiddenInOrder = state.order
        .where((module) => state.hidden.contains(module))
        .toList();
    _persist(state.copyWith(order: <HomeModule>[...visible, ...hiddenInOrder]));
  }

  void _persist(HomeModulePrefs next) {
    state = next;
    ref.read(localStoreProvider).setJsonMap(_homeModulePrefsKey, next.toJson());
  }
}
