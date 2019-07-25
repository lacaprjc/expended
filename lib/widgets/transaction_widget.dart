import 'package:auto_size_text/auto_size_text.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:expended/bloc/bloc.dart';
import 'package:expended/misc/colors.dart';
import 'package:expended/model/account.dart';
import 'package:expended/model/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionWidget extends StatefulWidget {
  final MapEntry<Account, TransactionItem> accountAndTransaction;

  TransactionWidget(this.accountAndTransaction, {Key key}) : super(key: key);

  _TransactionWidgetState createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {
  Account get account => widget.accountAndTransaction.key;
  TransactionItem get transaction => widget.accountAndTransaction.value;

  void _transactionPressed() {
    Navigator.pushNamed(context, '/transactionForm', arguments: widget.accountAndTransaction);
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
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                FlatButton.icon(
                  textColor: Colors.red,
                  label: Text('No'),
                  icon: Icon(EvaIcons.stopCircle),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton.icon(
                  textColor: Colors.green,
                  label: Text('Yes'),
                  icon: Icon(EvaIcons.checkmarkCircle),
                  onPressed: _deleteTransaction
                )
            ],
          ),
        );
      }
    );
  }

  void _deleteTransaction() {
    account.transactions.remove(transaction);
    account.balance -= transaction.amount;

    AccountBloc accountBloc = BlocProvider.of<AccountBloc>(context);

    accountBloc.dispatch(UpdateAccount(account,{ 
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
          icon: EvaIcons.trash2Outline,
          caption: 'Delete',
          color: Colors.red,
          onTap: _deleteTransactionPressed,
        ),
      ],
      child: ListTile(
        onTap: _transactionPressed,
        leading: Icon(EvaIcons.bookmark, color: AppColors.govBay,),
        title: AutoSizeText(
          transaction.name,
        ),
        trailing: AutoSizeText(
          transaction.amount.toString()
        ),
      ),
    );
  }
}