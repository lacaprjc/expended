import 'package:equatable/equatable.dart';
import 'package:expended/model/account.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AccountEvent extends Equatable {
  AccountEvent([List props = const []]) : super(props);
}

class LoadAccounts extends AccountEvent {}

class AddAccount extends AccountEvent {
  final Account account;

  AddAccount(this.account) : super([account]);
}

class UpdateAccount extends AccountEvent {
  final Account account;

  UpdateAccount(this.account) : super([account]);
}

class DeleteAccount extends AccountEvent {
  final Account account;

  DeleteAccount(this.account) : super([account]);
}