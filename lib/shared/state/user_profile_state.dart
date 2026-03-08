import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../persistence/local_store.dart';

enum UserSex { brother, sister }

class UserProfileState {
  const UserProfileState({required this.name, required this.sex});

  final String name;
  final UserSex sex;

  UserProfileState copyWith({String? name, UserSex? sex}) {
    return UserProfileState(
      name: name ?? this.name,
      sex: sex ?? this.sex,
    );
  }
}

class UserProfileNotifier extends StateNotifier<UserProfileState> {
  UserProfileNotifier(this._store)
      : super(const UserProfileState(name: 'Shahab', sex: UserSex.brother)) {
    _load();
  }

  final LocalStore _store;

  void updateName(String value) {
    if (value.trim().isEmpty) return;
    state = state.copyWith(name: value.trim());
    _save();
  }

  void updateSex(UserSex sex) {
    state = state.copyWith(sex: sex);
    _save();
  }

  void _load() {
    final data = _store.getJsonMap('profile.user');
    if (data == null) return;
    final name = (data['name'] as String?)?.trim();
    final sexName = data['sex'] as String?;
    UserSex? sex;
    for (final item in UserSex.values) {
      if (item.name == sexName) {
        sex = item;
        break;
      }
    }
    state = UserProfileState(
      name: (name == null || name.isEmpty) ? state.name : name,
      sex: sex ?? state.sex,
    );
  }

  void _save() {
    _store.setJsonMap('profile.user', {
      'name': state.name,
      'sex': state.sex.name,
    });
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfileState>(
      (ref) => UserProfileNotifier(ref.watch(localStoreProvider)),
    );
