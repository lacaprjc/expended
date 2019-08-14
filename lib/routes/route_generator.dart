import 'package:expended/model/account.dart';
import 'package:expended/model/transaction_item.dart';
import 'package:expended/routes/account_page.dart';
import 'package:expended/routes/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:expended/routes/routes.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
      case '/accounts':
        return MaterialPageRoute(builder: (context) => AccountsPage());
      case '/account':
        return MaterialPageRoute(
          builder: (context) => Provider<Account>.value(
            value: args,
            child: AccountPage(),
          ),
        );
      case '/accountForm':
        return MaterialPageRoute(
          builder: (context) => Provider<Account>.value(
            value: args,
            child: AccountFormPage(),
          ),
        );
      case '/transactionForm':
        return MaterialPageRoute(
          builder: (context) => Provider<TransactionItem>.value(
            value: args,
            child: TransactionFormPage(),
          ),
        );
      case '/settings':
        return MaterialPageRoute(builder: (context) => SettingsPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text('Invalid Route'),
        ),
        body: Center(
          child: Text('Invalid Route'),
        ),
      ),
    );
  }
}
