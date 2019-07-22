import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:expended/database/account_dao.dart';
import 'package:expended/model/account.dart';
import './bloc.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountDao _accountDao = AccountDao();

  @override
  AccountState get initialState => AccountsInitial();

  @override
  Stream<AccountState> mapEventToState(
    AccountEvent event,
  ) async* {
    if (event is LoadAccounts) {
      yield AccountsLoading();
    } else if (event is AddAccount) {
      await _accountDao.insert(event.account);
    } else if (event is UpdateAccount) {
      await _accountDao.update(event.account, event.fieldsToUpdate);
    } else if (event is DeleteAccount) {
      await _accountDao.delete(event.account);
    }

    yield* _reloadAccounts();
  }

  Stream<AccountState> _reloadAccounts() async* {
    final List<Account> accounts = await _accountDao.getAll();
    yield AccountsLoaded(accounts);
  }
}
