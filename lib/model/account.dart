import 'package:expended/model/transaction_item.dart';

// *NOTES*
// don't forget to load the transactions from the DB

class Account {
  int id;
  String name;
  String accountType;
  double balance;
  List<int> transactionIds = List<int>();
  List<TransactionItem> transactions = List<TransactionItem>();

  Account({
    this.name = '',
    this.accountType = '',
    this.balance = 0.00,
  });

  Account.fromJson(Map<String, dynamic> json) :
    name = json['name'],
    accountType = json['accountType'],
    balance = json['balance'] ?? 0.00 {
      transactions = transactionsFromJson(List.from(json['transactions']));
    }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'accountType': accountType,
      'balance': balance,
      'transactions': transactionsToJson(),
    };
  }

  List<Map<String, dynamic>> transactionsToJson() {
    return transactions.map((TransactionItem item) {
      return item.toJson();
    }).toList();
  }

  List<TransactionItem> transactionsFromJson(List<Map<String, dynamic>> json) {
    return json.map((Map<String, dynamic> transaction) {
      return TransactionItem.fromJson(transaction);
    }).toList();
  }
}
