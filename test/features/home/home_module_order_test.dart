import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/home/domain/home_modules.dart';

void main() {
  group('default Home module order', () {
    test('the day closes with on-this-day, duas, then the sky', () {
      // Superseded the earlier "duas lead the content" order: Home now ends
      // on one arc of the day's context.
      final order = kDefaultHomeModuleOrder;
      expect(
        order.indexOf(HomeModule.onThisDay),
        lessThan(order.indexOf(HomeModule.duasNow)),
      );
      expect(
        order.indexOf(HomeModule.duasNow),
        lessThan(order.indexOf(HomeModule.celestial)),
      );
      expect(
        order.indexOf(HomeModule.celestial),
        order.length - 1,
        reason: 'tonight\'s sky closes Home',
      );
    });

    test('the prayer strip still opens Home', () {
      expect(kDefaultHomeModuleOrder.first, HomeModule.prayerStrip);
    });

    test('every module appears exactly once', () {
      expect(
        kDefaultHomeModuleOrder.toSet().length,
        kDefaultHomeModuleOrder.length,
      );
      expect(kDefaultHomeModuleOrder.toSet(), HomeModule.values.toSet());
    });
  });

  group('saved preferences', () {
    test('a customized order is respected, not overwritten by the default', () {
      // This user deliberately put the ayah above duas.
      final prefs = HomeModulePrefs.fromJson(<String, dynamic>{
        'order': ['prayer_strip', 'today', 'duas_now', 'garden'],
        'hidden': <String>[],
      });
      expect(
        prefs.order.indexOf(HomeModule.today),
        lessThan(prefs.order.indexOf(HomeModule.duasNow)),
        reason: 'changing the default must not reshuffle an explicit choice',
      );
    });

    test('modules missing from a saved order are appended', () {
      final prefs = HomeModulePrefs.fromJson(<String, dynamic>{
        'order': ['prayer_strip', 'today'],
        'hidden': <String>[],
      });
      expect(prefs.order.toSet(), HomeModule.values.toSet());
      expect(prefs.order.take(2),
          [HomeModule.prayerStrip, HomeModule.today]);
    });
  });
}
