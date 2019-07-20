import 'package:auto_size_text/auto_size_text.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final String type;
  final String title;
  final int forAccount;

  const CustomBottomNavigationBar(this.type, {this.title = 'Accounts', this.forAccount = 0, Key key}) : super(key: key);

  Widget _buildAddAccountItem(BuildContext context) {
    return IconButton(
      icon: Icon(EvaIcons.plusSquareOutline),
      color: Colors.white,
      onPressed: () => Navigator.pushNamed(context, "/accountForm"),
    );
  }

  Widget _buildAddTransactionItem(BuildContext context) {
    return IconButton(
      icon: Icon(EvaIcons.plusSquareOutline),
      color: Colors.white,
      onPressed: () => Navigator.pushNamed(context, "/transactionForm", arguments: forAccount),
    );
  }

  Widget _buildTitleItem() {
    return AutoSizeText(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white
      ),
    );
  }

  Widget _buildBackItem(BuildContext context) {
    return IconButton(
      color: Colors.white,
      icon: Icon(EvaIcons.arrowBackOutline),
      onPressed: () => Navigator.pop(context),
    );
  }

  List<Widget> _buildItems(BuildContext context) {
    List<Widget> items = [
      Expanded(
        flex: 1,
        child: _buildTitleItem(),
      )
    ];

    switch (type) {
      case 'transactionForm':
        items.insert(0, 
          Expanded(
            flex: 1,
            child: _buildBackItem(context),
          )
        );
        items.add(Spacer(flex: 1,));
        break;
      case 'accountPage':
        items.insert(0, 
            Expanded(
              flex: 1,
              child: _buildBackItem(context),
          )
        );
        items.add(
          Expanded(
            flex: 1,
            child: _buildAddTransactionItem(context),
          )
        );
        break;
      case 'accountForm':
        items.insert(0, 
          Expanded(
            flex: 1,
            child: _buildBackItem(context),
          )
        );
        items.add(Spacer(flex: 1));
        break;
      default:
        items.insert(0, Spacer(flex: 1,));
        items.add(
          Expanded(
            flex: 1,
            child: _buildAddAccountItem(context)
          )
        );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/bar_bg.png'),
          fit: BoxFit.fill,
        ),
      ),
      height: 80,
      child: Row(
        children: _buildItems(context)
      ),
    );
  }
}
