String? mapAppDeepLink(Uri uri) {
  if (uri.scheme != 'pathofnur') return null;

  final path = _normalizedPath(uri);
  final host = uri.host.toLowerCase();

  if (path.startsWith('/home')) return '/home';
  if (path.startsWith('/worship')) return '/worship';
  if (path == '/prayer' || path.startsWith('/prayer/')) {
    return '/worship/prayer';
  }
  if (path == '/dhikr' || path.startsWith('/dhikr/')) {
    return '/worship/dhikr';
  }

  if (host == 'growth' || path.startsWith('/growth')) {
    final growthPath = host == 'growth'
        ? uri.path
        : path.substring('/growth'.length);
    if (growthPath == '/today') return '/journey/today';
    if (growthPath == '/reflection') return '/journey/reflection';
    if (growthPath == '/journey') return '/journey/progress';
    if (growthPath == '/habits') return '/journey/habits';
    if (growthPath.startsWith('/habit/')) {
      final id = growthPath.substring('/habit/'.length);
      if (id.isNotEmpty) return '/journey/habit/$id';
    }
  }

  if (path.startsWith('/progress')) return '/journey/progress';
  if (path.startsWith('/journey')) return path;
  if (path.startsWith('/quran')) {
    return path == '/quran/read' ? '/quran/surah/1' : path;
  }
  if (path.startsWith('/learn')) return path;
  if (path.startsWith('/ocean')) return '/journey/ocean';
  if (path.startsWith('/garden')) return '/journey/garden';
  if (path.startsWith('/tracking')) return '/journey/statistics';

  if (host == 'quran' && uri.path == '/read') {
    return '/quran/surah/1';
  }

  if (path == "/") {
    return '/home';
  }

  return null;
}

String _normalizedPath(Uri uri) {
  if (uri.path.isNotEmpty) {
    return uri.path;
  }
  if (uri.host.isNotEmpty) {
    return '/${uri.host}';
  }
  return '/';
}
