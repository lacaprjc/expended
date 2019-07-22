import 'package:expended/bloc/bloc.dart';
import 'package:expended/bloc/transactionitem_bloc.dart';
import 'package:expended/bloc/transactionitem_event.dart';
import 'package:expended/model/account.dart';
import 'package:expended/model/transaction_item.dart';
import 'package:expended/widgets/custom_bottom_navigation_bar.dart';
import 'package:expended/widgets/transaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatefulWidget {
  final Account account;

  AccountPage(this.account, {Key key}) : super(key: key);

  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Account get account => widget.account;
  TransactionItemBloc _transactionBloc;


  @override
  void initState() { 
    super.initState();
    _transactionBloc = BlocProvider.of<TransactionItemBloc>(context);
    _transactionBloc.dispatch(LoadTransactions(account.id));
  }
  
  void _calcBalance() {
    double balance = 0.00;

    account.transactions.forEach((TransactionItem item) {
      balance += item.amount;
    });

    account.balance = balance;
    print(balance);
  }

  Widget _buildBalance() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      height: 200,
      child: Card(
        // color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '\$ ${account.balance.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w300
                ),
              ),
              Container(height: 20,),
              Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Current Balance',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    _calcBalance();
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            _buildBalance(),
            Expanded(
              child: ListView.builder(
                itemCount: account.transactions.length,
                itemBuilder: (context, i) {
                  return TransactionWidget(account.transactions[i]);
                },
              ),
            ),
          ],
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBar(
        'accountPage', 
        title: account.name, 
        forAccount: account,
      ),
    );
  }
}