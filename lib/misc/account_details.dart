import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

enum AccountType {
  Cash,
  Credit,
  Checking,
  Savings,
  Personal,
  Budget,
}

class AccountDetails {
  AccountType accountType;
  String notes;

  AccountDetails([this.accountType, this.notes]) {
    accountType = accountType ?? AccountType.Credit;
  }

  AccountDetails.fromString(String fromString)
      : accountType = typeFromString(fromString),
        notes = '';

  String getString() {
    return accountType.toString().split('.').last;
  }

  static AccountType typeFromString(String fromString) {
    for (AccountType type in AccountType.values) {
      if (fromString == type.toString().split('.').last) {
        return type;
      }
    }

    return AccountType.Credit;
  }

  IconData getIconData() {
    switch (accountType) {
      case AccountType.Cash:
        return MaterialCommunityIcons.cash;
      case AccountType.Budget:
        return MaterialCommunityIcons.cash_register;
      case AccountType.Checking:
        return MaterialCommunityIcons.checkbook;
      case AccountType.Savings:
        return FontAwesome5Solid.piggy_bank;
      case AccountType.Credit:
        return MaterialCommunityIcons.credit_card;
      case AccountType.Personal:
        return MaterialCommunityIcons.face_outline;
      default:
        return MaterialCommunityIcons.cash;
    }
  }

  Color getIconColor() {
    return Colors.accents[accountType.index];
  }
}
