import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  UserProfileNotifier() : super(const UserProfileState(name: 'Shahab', sex: UserSex.brother));

  void updateName(String value) {
    if (value.trim().isEmpty) return;
    state = state.copyWith(name: value.trim());
  }

  void updateSex(UserSex sex) {
    state = state.copyWith(sex: sex);
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfileState>(
      (ref) => UserProfileNotifier(),
    );
