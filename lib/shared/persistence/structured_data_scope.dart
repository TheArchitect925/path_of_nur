import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/accounts_sync/application/accounts_sync_controller.dart';
import 'app_database.dart';

final structuredDataScopeProvider = Provider<String>((ref) {
  final activeProfileId = ref.watch(
    accountsSyncControllerProvider.select((state) => state.activeProfileId),
  );
  ref.watch(profileScopeVersionProvider);
  return activeProfileId ?? defaultStructuredDataScopeId;
});
