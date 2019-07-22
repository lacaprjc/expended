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

  // TODO: Make a function to take in an account and the fields to update
  Future update(Account account, Map<String, dynamic> fieldsToUpdate) async {
    final Finder finder = Finder(filter: Filter.byKey(account.id));
    await _accountStore.update(await _db, fieldsToUpdate, finder: finder);
  }

  Future delete(Account account) async {
    final Finder finder = Finder(filter: Filter.byKey(account.id));
    await _accountStore.delete(await _db, finder: finder);
  }

  Future<List<Account>> getAll() async {
    final Finder finder = Finder(sortOrders: [SortOrder('name')]);

    final List<RecordSnapshot> recordSnapshots = await _accountStore.find(await _db);

    return recordSnapshots.map((RecordSnapshot snapshot) {
      final Account account = Account.fromJson(snapshot.value);
      account.id = snapshot.key;
      print('Loaded ${account.name} with id: ${account.id}');
      // print(account.toJson());

      return account;
    }).toList();
  }
}