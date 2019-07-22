import 'package:auto_size_text/auto_size_text.dart';
import 'package:expended/model/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionWidget extends StatefulWidget {
  final TransactionItem transaction;

  TransactionWidget(this.transaction, {Key key}) : super(key: key);

  _TransactionWidgetState createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {
  TransactionItem get transaction => widget.transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: <Widget>[],
        child: ListTile(
          title: AutoSizeText(
            transaction.name,
          ),
          trailing: AutoSizeText(
            transaction.amount.toString()
          ),
        ),
      ),
    );
  }
}