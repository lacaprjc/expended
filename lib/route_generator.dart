import 'package:flutter/material.dart';
import 'package:expended/routes/routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case '/':
      case '/accounts':
        return MaterialPageRoute(builder: (context) => AccountsPage());
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