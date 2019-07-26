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
    if (event is LoadAllAccounts) {
      yield AccountsAllLoading();
      yield* _reloadAccounts();
      return;
    } else if (event is AddAccount) {
      await _accountDao.insert(event.account);
      yield* _reloadAccounts();
      return;
    } else if (event is UpdateAccount) {
      await _accountDao.update(event.account, event.fieldsToUpdate);
      yield* _reloadAccount(event.account);
      return;
    } else if (event is DeleteAccount) {
      await _accountDao.delete(event.account);
      yield* _reloadAccounts();
      return;
    } else if (event is LoadAccount) {
      yield* _reloadAccount(event.account);
      return;
    }
  }

  Stream<AccountState> _reloadAccount(Account account) async* {
    print('Loading account: ${account.name}...');
    yield AccountLoading(account);
    yield AccountLoaded(account);
  }

  Stream<AccountState> _reloadAccounts() async* {
    print('Loading all accounts...');
    final List<Account> accounts = await _accountDao.getAll();

    for (Account account in accounts) {
      yield* _reloadAccount(account);
    }

    print('Loaded all accounts!');
    yield AccountsLoaded(accounts);
  }
}
