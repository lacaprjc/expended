import 'package:equatable/equatable.dart';
import 'package:expended/model/account.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AccountState extends Equatable {
  AccountState([List props = const []]) : super(props);
}

class AccountsInitial extends AccountState {}

class AccountsLoading extends AccountState {}

class AccountsLoaded extends AccountState {
  final List<Account> accounts;

  AccountsLoaded(this.accounts) : super([accounts]);
}
