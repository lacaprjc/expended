import 'dart:async';
import 'package:expended/misc/formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'dart:io';

class AppDatabase {
  // singleton instance
  static final AppDatabase _singleton = AppDatabase._();
  static const String DATABASE_FILENAME = 'accounts.db';

  // singleton accessor
  static AppDatabase get instance => _singleton;

  // sync -> async
  Completer<Database> _dbOpenCompleter;

  // private constructor
  AppDatabase._();

  Database _database;

  Future<Database> get database async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer<Database>();
      _openDatabase();
    }

    return _dbOpenCompleter.future;
  }

  Future backupDatabaseToFolder(String folder) async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    final databasePath = join(appDocumentDirectory.path, DATABASE_FILENAME);

    final backupPath = join(
        folder, 'Expended_${Formatter.dateFormat.format(DateTime.now())}.db');

    File databaseFile = File.fromUri(Uri.file(databasePath));
    return await databaseFile.copy(backupPath);
  }

  Future reopenDatabase() async {
    _dbOpenCompleter = Completer<Database>();
    return await _openDatabase();
  }

  Future _openDatabase() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    final databasePath = join(appDocumentDirectory.path, DATABASE_FILENAME);
    _database = await databaseFactoryIo.openDatabase(databasePath);
    // print(_database.path);
    print('Current contents of db: \n$_database');
    _dbOpenCompleter.complete(_database);
  }
}
