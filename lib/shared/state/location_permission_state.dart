import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionState {
  const LocationPermissionState({
    required this.status,
    required this.isLoading,
  });

  final PermissionStatus status;
  final bool isLoading;

  bool get isGranted => status.isGranted || status.isLimited;
  bool get isPermanentlyDenied => status.isPermanentlyDenied;

  LocationPermissionState copyWith({
    PermissionStatus? status,
    bool? isLoading,
  }) {
    return LocationPermissionState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LocationPermissionNotifier
    extends StateNotifier<LocationPermissionState> {
  LocationPermissionNotifier()
      : super(
          const LocationPermissionState(
            status: PermissionStatus.denied,
            isLoading: false,
          ),
        ) {
    refreshStatus();
  }

  Future<void> refreshStatus() async {
    if (!_supportsPermissionHandlerLocation()) {
      state = state.copyWith(status: PermissionStatus.denied);
      return;
    }
    final status = await Permission.locationWhenInUse.status;
    state = state.copyWith(status: status);
  }

  Future<void> requestWhileUsingApp() async {
    if (!_supportsPermissionHandlerLocation()) {
      state = state.copyWith(
        status: PermissionStatus.denied,
        isLoading: false,
      );
      return;
    }
    state = state.copyWith(isLoading: true);
    final status = await Permission.locationWhenInUse.request();
    state = state.copyWith(status: status, isLoading: false);
  }

  Future<void> openSystemSettings() async {
    await openAppSettings();
  }
}

final locationPermissionProvider = StateNotifierProvider<
    LocationPermissionNotifier, LocationPermissionState>(
  (ref) => LocationPermissionNotifier(),
);

bool _supportsPermissionHandlerLocation() {
  if (kIsWeb) return false;
  return defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;
}
