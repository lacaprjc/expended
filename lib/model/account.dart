import 'package:expended/misc/account_details.dart';
import 'package:expended/model/transaction_item.dart';

// *NOTES*
// don't forget to load the transactions from the DB

class Account {
  int id;
  String name;
  double balance;

  AccountDetails accountDetails = AccountDetails();
  List<TransactionItem> transactions = List<TransactionItem>();

  Account({
    this.name = '',
    this.accountDetails,
    this.balance = 0.00,
    this.transactions,
  }) {
    accountDetails = accountDetails ?? AccountDetails();
    transactions = transactions ?? List();
  }

  Account.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        accountDetails = accountDetailsFromJson(json['accountType']),
        balance = json['balance'] ?? 0.00 {
    transactions = transactionsFromJson(List.from(json['transactions']));
    sortTransactionsByDate();
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'accountType': accountDetailsToJson(),
      'balance': balance,
      'transactions': transactionsToJson(),
    };
  }

  static AccountDetails accountDetailsFromJson(Map<String, dynamic> json) {
    return AccountDetails.fromString(json['type']);
  }

  Map<String, dynamic> accountDetailsToJson() {
    return {
      'type': accountDetails.getString(),
    };
  }

  void sortTransactionsByDate([bool ascending = true]) {
    if (transactions.length < 2) return;

    transactions.sort((TransactionItem item1, TransactionItem item2) {
      int result =
          DateTime.parse(item1.date).compareTo(DateTime.parse(item2.date));
      if (result == 0) {
        print('same');
      }

      if (ascending) return -result;

      return result;
    });
  }

  List<Map<String, dynamic>> transactionsToJson() {
    return transactions.map((TransactionItem item) {
      return item.toJson();
    }).toList();
  }

  static List<TransactionItem> transactionsFromJson(
      List<Map<String, dynamic>> json) {
    return json.map((Map<String, dynamic> transaction) {
      return TransactionItem.fromJson(transaction);
    }).toList();
  }
}
