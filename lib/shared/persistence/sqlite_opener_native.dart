import 'package:sqlite3/common.dart';
import 'package:sqlite3/sqlite3.dart';

/// FFI loads SQLite on first use, so there is nothing to prepare.
Future<void> prepareSqlite() async {}

CommonDatabase openSqliteFile(String path) => sqlite3.open(path);

CommonDatabase openSqliteInMemory() => sqlite3.openInMemory();
