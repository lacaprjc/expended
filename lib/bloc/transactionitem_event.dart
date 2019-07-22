import 'package:equatable/equatable.dart';
import 'package:expended/model/transaction_item.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TransactionItemEvent extends Equatable {
  TransactionItemEvent([List props = const []]) : super(props);
}

class LoadTransactions extends TransactionItemEvent {
  final int accountId;

  LoadTransactions(this.accountId) : super([accountId]);
}

// class LoadTransaction extends TransactionItemEvent {
//   final int transactionId;

//   LoadTransaction(this.transactionId) : super([transactionId]);
// }

// class AddTransaction extends TransactionItemEvent {
//   final TransactionItem transaction;

//   AddTransaction(this.transaction) : super([transaction]);
// }

class UpdateTransaction extends TransactionItemEvent {
  final TransactionItem transaction;

  UpdateTransaction(this.transaction) : super([transaction]);
}

class DeleteTransaction extends TransactionItemEvent {
  final TransactionItem transaction;

  DeleteTransaction(this.transaction) : super([transaction]);
}
