import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:expended/database/transaction_item_dao.dart';
import 'package:expended/model/transaction_item.dart';
import './bloc.dart';

class TransactionItemBloc extends Bloc<TransactionItemEvent, TransactionItemState> {
  TransactionItemDao _transactionDao = TransactionItemDao();

  @override
  TransactionItemState get initialState => TransactionInitial();

  @override
  Stream<TransactionItemState> mapEventToState(
    TransactionItemEvent event,
  ) async* {
    if (event is LoadTransactions) {
      _transactionDao.forAccount = event.accountId;
      yield TransactionsLoading();
    } else if (event is AddTransaction) {
      await _transactionDao.insert(event.transaction);
    } else if (event is UpdateTransaction) {
      await _transactionDao.update(event.transaction);
    } else if (event is DeleteTransaction) {
      await _transactionDao.delete(event.transaction);
    }

    yield* _reloadTransactions();
  }

  Stream<TransactionItemState> _reloadTransactions() async* {
    final List<TransactionItem> transactions = await _transactionDao.getAllFromAccount(_transactionDao.forAccount);
    yield TransactionsLoaded(transactions);
  }
}
