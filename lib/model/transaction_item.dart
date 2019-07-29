class TransactionItem {
  int id;
  // int forAccount;
  double amount;
  String date;
  String time;
  String name;
  String notes;
  List<int> image;

  TransactionItem({
    this.amount = 0.00,
    this.date = '',
    this.time = '',
    this.name = '',
    this.notes = '',
    this.image,
  }) {
    if (image == null) {
      image = List();
    }
  }

  TransactionItem.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        date = json['date'],
        time = json['time'],
        amount = json['amount'],
        notes = json['notes'],
        image = List.from(json['image']);
  // forAccount = json['forAccount'];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'amount': amount,
      'name': name,
      'notes': notes,
      'date': date,
      'time': time,
      'image': image ?? []
      // 'forAccount': forAccount
    };
  }
}
