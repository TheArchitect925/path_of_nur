import '../state/user_profile_state.dart';

const String brotherProfileLogoAsset = 'assets/icons/brotherlogo.PNG';
const String sisterProfileLogoAsset = 'assets/icons/sisterlogo.png';

String resolveProfileLogoAsset(UserSex sex) {
  switch (sex) {
    case UserSex.brother:
      return brotherProfileLogoAsset;
    case UserSex.sister:
      return sisterProfileLogoAsset;
  }
}
