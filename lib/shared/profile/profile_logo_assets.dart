import '../state/user_profile_state.dart';

const String brotherProfileLogoAsset = 'assets/icons/brotherlogo.webp';
const String sisterProfileLogoAsset = 'assets/icons/sisterlogo.webp';

String resolveProfileLogoAsset(UserSex sex) {
  switch (sex) {
    case UserSex.brother:
      return brotherProfileLogoAsset;
    case UserSex.sister:
      return sisterProfileLogoAsset;
  }
}
