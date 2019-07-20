import 'package:expended/bloc/transactionitem_bloc.dart';
import 'package:expended/bloc/transactionitem_event.dart';
import 'package:expended/model/account.dart';
import 'package:expended/model/transaction_item.dart';
import 'package:expended/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

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
    _transactionBloc = TransactionItemBloc();
    _transactionBloc.dispatch(LoadTransactions(account.id));
  }
  
  double _calcBalance() {
    double balance = 10380.28;
    
    account.transactions.forEach((TransactionItem item) {
      balance += item.amount;
    });

    return balance;
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
                '\$ ${_calcBalance().toStringAsFixed(2)}',
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
    return SafeArea(
      child: Container(
        child: ListView.builder(
          itemCount: account.transactions.length + 1,
          itemBuilder: (context, int i) {
            if (i == 0) {
              return _buildBalance();
            }

            return Container(
              child: Card(
                
              ),
            );
          },
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBar('accountPage', title: account.name,),
    );
  }
}