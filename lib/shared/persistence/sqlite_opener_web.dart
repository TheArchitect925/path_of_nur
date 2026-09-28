import 'package:sqlite3/wasm.dart';

WasmSqlite3? _sqlite;

/// Loads `sqlite3.wasm` (served next to index.html, so it follows the base
/// href) and makes IndexedDB the default file system, so records survive a
/// reload. Falls back to memory when the browser refuses IndexedDB.
Future<void> prepareSqlite() async {
  if (_sqlite != null) return;
  final sqlite = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
  VirtualFileSystem fileSystem;
  try {
    fileSystem = await IndexedDbFileSystem.open(dbName: 'path_of_nur');
  } catch (_) {
    fileSystem = InMemoryFileSystem();
  }
  sqlite.registerVirtualFileSystem(fileSystem, makeDefault: true);
  _sqlite = sqlite;
}

WasmSqlite3 get _loaded =>
    _sqlite ?? (throw StateError('prepareSqlite() must finish first.'));

CommonDatabase openSqliteFile(String path) => _loaded.open(path);

CommonDatabase openSqliteInMemory() => _loaded.openInMemory();
