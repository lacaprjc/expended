import 'package:expended/database/db.dart';
import 'package:expended/model/account.dart';
import 'package:sembast/sembast.dart';

class AccountDao {
  static const String ACCOUNT_STORE_NAME = 'Accounts';

  final StoreRef _accountStore = intMapStoreFactory.store(ACCOUNT_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Account account) async {
    await _accountStore.add(await _db, account.toJson());
  }

  Future update(Account account) async {
    final Finder finder = Finder(filter: Filter.byKey(account.id));
    await _accountStore.update(await _db, account.toJson(), finder: finder);
  }

  Future delete(Account account) async {
    final Finder finder = Finder(filter: Filter.byKey(account.id));
    await _accountStore.delete(await _db, finder: finder);
  }

  Future<List<Account>> getAll() async {
    final Finder finder = Finder(sortOrders: [SortOrder('name')]);

    final List<RecordSnapshot> recordSnapshots = await _accountStore.find(await _db, finder: finder);

    return recordSnapshots.map((RecordSnapshot snapshot) {
      final Account account = Account.fromJson(snapshot.value);
      print('Loaded ' + account.name);

      account.id = snapshot.key;
      return account;
    }).toList();
  }
}