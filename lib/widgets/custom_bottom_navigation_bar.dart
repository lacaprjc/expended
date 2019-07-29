import 'package:auto_size_text/auto_size_text.dart';
import 'package:expended/misc/colors.dart';
import 'package:expended/model/account.dart';
import 'package:expended/model/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final String type;
  final String title;
  final Account forAccount;

  const CustomBottomNavigationBar(
    this.type, {
    this.title = 'Accounts',
    this.forAccount,
    Key key,
  }) : super(key: key);

  Widget _buildAddAccountItem(BuildContext context) {
    return IconButton(
      icon: Icon(
        MaterialCommunityIcons.plus_circle_outline,
      ),
      color: AppColors.seance,
      onPressed: () => Navigator.pushNamed(context, "/accountForm"),
    );
  }

  Widget _buildAddTransactionItem(BuildContext context) {
    MapEntry<Account, TransactionItem> accountAndTransaction =
        MapEntry<Account, TransactionItem>(forAccount, TransactionItem());

    return IconButton(
      icon: Icon(MaterialCommunityIcons.plus_circle_outline),
      color: AppColors.seance,
      onPressed: () => Navigator.pushNamed(
        context,
        "/transactionForm",
        arguments: accountAndTransaction,
      ),
    );
  }

  Widget _buildTitleItem() {
    return AutoSizeText(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.seance,
      ),
    );
  }

  Widget _buildBackItem(BuildContext context) {
    return IconButton(
      color: AppColors.seance,
      icon: Icon(
        MaterialCommunityIcons.arrow_left_bold_circle_outline,
      ),
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
        items.insert(
            0,
            Expanded(
              flex: 1,
              child: _buildBackItem(context),
            ));
        items.add(Spacer(
          flex: 1,
        ));
        break;
      case 'accountPage':
        items.insert(
            0,
            Expanded(
              flex: 1,
              child: _buildBackItem(context),
            ));
        items.add(Expanded(
          flex: 1,
          child: _buildAddTransactionItem(context),
        ));
        break;
      case 'accountForm':
        items.insert(
            0,
            Expanded(
              flex: 1,
              child: _buildBackItem(context),
            ));
        items.add(Spacer(flex: 1));
        break;
      default:
        items.insert(
            0,
            Spacer(
              flex: 1,
            ));
        items.add(Expanded(flex: 1, child: _buildAddAccountItem(context)));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage('images/bar_bg.png'),
          //   fit: BoxFit.fill,
          // ),
          ),
      height: 80,
      child: Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: _buildItems(context),
        ),
      ),
    );
  }
}
