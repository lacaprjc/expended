import 'package:flutter/material.dart';

class Account {
  int id;
  String name;
  String accountType;
  double balance;

  Account({
    @required this.name,
    @required this.accountType,
    this.balance = 0.00,
  });

  Account.fromJson(Map<String, dynamic> json) :
    name = json['name'],
    accountType = json['accountType'],
    balance = json['balance'] ?? 0.00;


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'accountType': accountType,
      'balance': balance ?? 0.00,
    };
  }
}