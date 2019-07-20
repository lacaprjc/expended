import 'package:expended/model/transaction_item.dart';

class Account {
  int id;
  String name;
  String accountType;
  double balance;
  List<TransactionItem> transactions = List();

  Account({
    this.name = '',
    this.accountType = '',
    this.balance = 0.00,
  });

  Account.fromJson(Map<String, dynamic> json) :
    name = json['name'],
    accountType = json['accountType'],
    balance = json['balance'] ?? 0.00,
    transactions = json['transactions'] ?? [];


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'accountType': accountType,
      'balance': balance ?? 0.00,
      'transactions': transactions ?? []
    };
  }
}
