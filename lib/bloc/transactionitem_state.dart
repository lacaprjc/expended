import 'package:equatable/equatable.dart';
import 'package:expended/model/transaction_item.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TransactionItemState extends Equatable {
  TransactionItemState([List props = const []]) : super(props);
}

class TransactionInitial extends TransactionItemState {}

class TransactionsLoading extends TransactionItemState {}

class TransactionsLoaded extends TransactionItemState {
  final List<TransactionItem> transactions;

  TransactionsLoaded(this.transactions) : super([transactions]);
}