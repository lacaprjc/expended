import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabase {
  // singleton instance
  static final AppDatabase _singleton = AppDatabase._();

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

  Future _openDatabase() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    final databasePath = join(appDocumentDirectory.path, 'accounts.db');
    _database = await databaseFactoryIo.openDatabase(databasePath);
    print(_database.path);
    _dbOpenCompleter.complete(_database);
  }
}