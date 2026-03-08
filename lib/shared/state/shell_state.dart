import 'package:flutter_riverpod/flutter_riverpod.dart';

final shellCurrentLocationProvider = StateProvider<String>((_) => '/home');

final homeVerseVersionProvider = StateProvider<int>((_) => 0);
