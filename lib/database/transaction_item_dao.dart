import 'package:expended/database/db.dart';
import 'package:expended/model/transaction_item.dart';
import 'package:sembast/sembast.dart';

class TransactionItemDao {
  static const String TRANSACTION_ITEM_STORE_NAME = 'Transactions';

  final StoreRef _transactionStore = intMapStoreFactory.store(TRANSACTION_ITEM_STORE_NAME);
  int forAccount;

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(TransactionItem transaction) async {
    await _transactionStore.add(await _db, transaction.toJson());
  }

  Future update(TransactionItem transaction) async {
    final Finder finder = Finder(filter: Filter.byKey(transaction.id));
    await _transactionStore.update(await _db, transaction.toJson(), finder: finder);
  }

  Future delete(TransactionItem transaction) async {
    final Finder finder = Finder(filter: Filter.byKey(transaction.id));
    await _transactionStore.delete(await _db, finder: finder);
  }

  Future<TransactionItem> getById(int id) async {
    final Finder finder = Finder(filter: Filter.byKey(id));
    final RecordSnapshot recordSnapshot = await _transactionStore.findFirst(await _db, finder: finder);
    return TransactionItem.fromJson(recordSnapshot.value);
  }

  Future<List<TransactionItem>> getAll() async {
    final Finder finder = Finder(sortOrders: [SortOrder('date')]);

    final List<RecordSnapshot> recordSnaspshots = await _transactionStore.find(await _db, finder: finder);

    return recordSnaspshots.map((RecordSnapshot snapshot) {
      final TransactionItem transaction = TransactionItem.fromJson(snapshot.value);
      print('Loaded item ${transaction.name} for ${transaction.amount}');

      transaction.id = snapshot.key;
      return transaction;
    }).toList();
  }

  Future<List<TransactionItem>> getAllFromAccount(int accountId) async {
    final Finder finder = Finder(filter: Filter.byKey(accountId), sortOrders: [SortOrder('date')]);

    final List<RecordSnapshot> recordSnaspshots = await _transactionStore.find(await _db, finder: finder);

    return recordSnaspshots.map((RecordSnapshot snapshot) {
      final TransactionItem transaction = TransactionItem.fromJson(snapshot.value);
      print('Loaded item ${transaction.name} for ${transaction.amount} with id: ${transaction.id}');

      transaction.id = snapshot.key;
      return transaction;
    }).toList();
  }
}