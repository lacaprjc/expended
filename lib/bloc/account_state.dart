import 'package:equatable/equatable.dart';
import 'package:expended/model/account.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AccountState extends Equatable {
  AccountState([List props = const []]) : super(props);
}

class AccountsInitial extends AccountState {}

class AccountsAllLoading extends AccountState {}

class AccountLoading extends AccountState {
  final Account account;

  AccountLoading(this.account) : super([account]);
}

class AccountLoaded extends AccountState {
  final Account account;

  AccountLoaded(this.account) : super([account]);
}

class AccountsLoaded extends AccountState {
  final List<Account> accounts;

  AccountsLoaded(this.accounts) : super([accounts]);
}
