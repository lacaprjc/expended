class TransactionItem {
  int id;
  // int forAccount;
  double amount;
  String date;
  String time;
  String name;

  TransactionItem({
    this.amount = 0.00,
    this.date = '',
    this.time = '',
    this.name = '',
    // this.forAccount
  });

  TransactionItem.fromJson(Map<String, dynamic> json) :
    name = json['name'],
    date = json['date'],
    time = json['time'],
    amount = json['amount'];
    // forAccount = json['forAccount'];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'amount': amount,
      'name': name,
      'date': date,
      'time': time,
      // 'forAccount': forAccount
    };
  }
}