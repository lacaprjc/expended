import 'package:auto_size_text/auto_size_text.dart';
import 'package:expended/bloc/bloc.dart';
import 'package:expended/misc/colors.dart';
import 'package:expended/misc/formatter.dart';
import 'package:expended/model/account.dart';
import 'package:expended/model/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class TransactionWidget extends StatefulWidget {
  final TransactionItem transactionItem;
  TransactionWidget(this.transactionItem, {Key key}) : super(key: key);

  _TransactionWidgetState createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {
  Account account;
  TransactionItem get transaction => widget.transactionItem;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    account = Provider.of<Account>(context);
    transaction.forAccount = account;
  }

  void _transactionPressed() {
    transaction.isEditing = true;
    Navigator.pushNamed(
      context,
      '/transactionForm',
      arguments: transaction,
    );
  }

  void _deleteTransactionPressed() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Are you sure?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              FlatButton.icon(
                textColor: Colors.red,
                label: Text('No'),
                icon: Icon(MaterialCommunityIcons.stop_circle_outline),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton.icon(
                textColor: Colors.green,
                label: Text('Yes'),
                icon: Icon(MaterialCommunityIcons.check_circle_outline),
                onPressed: _deleteTransaction,
              )
            ],
          ),
        );
      },
    );
  }

  void _deleteTransaction() {
    account.transactions.remove(transaction);
    account.balance -= transaction.amount;

    AccountBloc accountBloc = BlocProvider.of<AccountBloc>(context);

    accountBloc.dispatch(UpdateAccount(account, {
      'transactions': account.transactionsToJson(),
      'balance': account.balance
    }));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          icon: MaterialCommunityIcons.trash_can_outline,
          caption: 'Delete',
          color: Colors.red,
          onTap: _deleteTransactionPressed,
        ),
      ],
      child: ListTile(
        onTap: _transactionPressed,
        leading: Icon(
          MaterialCommunityIcons.bookmark,
          color: AppColors.govBay,
        ),
        title: AutoSizeText(
          transaction.name,
        ),
        trailing:
            AutoSizeText(Formatter.numberFormat.format(transaction.amount)),
      ),
    );
  }
}
