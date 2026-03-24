import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/shared/profile/profile_logo_assets.dart';
import 'package:path_of_nur/shared/state/user_profile_state.dart';

void main() {
  test('profile logo assets resolve to the canonical bundled paths', () {
    expect(resolveProfileLogoAsset(UserSex.brother), brotherProfileLogoAsset);
    expect(resolveProfileLogoAsset(UserSex.sister), sisterProfileLogoAsset);
    expect(brotherProfileLogoAsset, 'assets/icons/brotherlogo.PNG');
    expect(sisterProfileLogoAsset, 'assets/icons/sisterlogo.png');
  });
}
