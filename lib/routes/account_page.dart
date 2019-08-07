import 'package:auto_size_text/auto_size_text.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:expended/bloc/bloc.dart';
import 'package:expended/misc/colors.dart';
import 'package:expended/misc/formatter.dart';
import 'package:expended/model/account.dart';
import 'package:expended/model/transaction_item.dart';
import 'package:expended/widgets/custom_bottom_navigation_bar.dart';
import 'package:expended/widgets/transaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';

class AccountPage extends StatefulWidget {
  AccountPage(this.account, {Key key}) : super(key: key);

  final Account account;

  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // takes the formatted date (yyyy-mm-dd) and returns 'today' or day of week
  String formatDate(String date) {
    String formattedDate = '';
    DateTime dateTime = DateTime.parse(date);
    Duration difference = dateTime.difference(DateTime.now());

    // print(difference.inDays);
    if (difference.inDays == 0 && dateTime.day == DateTime.now().day) {
      formattedDate = 'Today';
    } else if (difference.inDays.isNegative) {
      // before today
      if (difference.inDays == -1) {
        formattedDate = 'Yesterday';
      } else if (difference.inDays < -1 && difference.inDays > -5) {
        formattedDate =
            DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY).format(dateTime);
      } else {
        formattedDate =
            DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(dateTime);
      }
    } else {
      // future transactions
      formattedDate =
          DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(dateTime);
    }

    return formattedDate;
  }

  Map<String, List<TransactionItem>> sortedTransactions;

  @override
  void initState() {
    super.initState();
    sortedTransactions = Map();
    BlocProvider.of<AccountBloc>(context).dispatch(LoadAccount(account));
  }

  Account get account => widget.account;

  // void _calcBalance() {
  //   double balance = 0.00;

  //   account.transactions.forEach((TransactionItem item) {
  //     balance += item.amount;
  //   });

  //   account.balance = balance;
  // }

  void sortTransactionsByDate([bool ascending = true]) {
    sortedTransactions.clear();

    for (TransactionItem transaction in account.transactions) {
      if (sortedTransactions[formatDate(transaction.date)] == null) {
        sortedTransactions[formatDate(transaction.date)] = List();
      }
      sortedTransactions[formatDate(transaction.date)].add(transaction);
    }

    sortedTransactions.forEach(
      (String formattedDate, List<TransactionItem> transactions) {
        if (transactions.length < 2) {
          return;
        }

        transactions.sort(
          (TransactionItem item1, TransactionItem item2) {
            int result = DateTime.parse(item1.date).compareTo(
              DateTime.parse(item2.date),
            );

            if (result == 0) {
              // same day but different time
              List<String> item1TimeSplit = item1.time.split(':');
              List<String> item2TimeSplit = item2.time.split(':');

              result = DateTimeField.convert((TimeOfDay(
                      hour: int.parse(item1TimeSplit[0]),
                      minute: int.parse(item1TimeSplit[1]))))
                  .compareTo(DateTimeField.convert((TimeOfDay(
                      hour: int.parse(item2TimeSplit[0]),
                      minute: int.parse(item2TimeSplit[1])))));
            }

            if (ascending) {
              return -result;
            }

            return result;
          },
        );
      },
    );
  }

  List<Widget> _buildSortedTransactions() {
    List<Widget> transactionsWidgets = List();

    sortedTransactions
        .forEach((String formattedDate, List<TransactionItem> transactions) {
      transactionsWidgets.add(Container(
          margin: EdgeInsets.only(left: 14),
          child: AutoSizeText(
            formattedDate,
            style: TextStyle(
              fontWeight: FontWeight.w200,
              // color: AppColors.seance
            ),
          )));
      transactions.forEach((TransactionItem transaction) {
        transactionsWidgets.add(TransactionWidget(
            MapEntry<Account, TransactionItem>(account, transaction)));
      });
    });

    return transactionsWidgets;
  }

  Widget _buildTransactions() {
    return Column(
      children: <Widget>[
        BalanceWidget(account: account),
        Expanded(
          child: Card(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: account.transactions.isEmpty
                ? Center(
                    child: AutoSizeText(
                      'Press the + icon to start adding transactions!',
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.only(top: 10),
                    children: _buildSortedTransactions(),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Container(
        child: BlocBuilder(
          bloc: BlocProvider.of<AccountBloc>(context),
          condition: (AccountState previousState, AccountState currentState) {
            return (currentState is AccountLoading) ||
                (currentState is AccountLoaded);
          },
          builder: (context, AccountState state) {
            if (state is AccountLoading) {
              print('loading...');
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is AccountLoaded) {
              print('Loaded Account: ${account.name}');
              sortTransactionsByDate();
              return _buildTransactions();
            }

            return Container();
          },
        ),
      ),
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

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({
    Key key,
    @required this.account,
  }) : super(key: key);

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          height: 200,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: ShapeDecoration(
                gradient: AppGradients.accountCard,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AutoSizeText(
                      '\$ ${Formatter.numberFormat.format(account.balance)}',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Current Balance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          margin: EdgeInsets.only(right: 20),
          child: FlatButton.icon(
            icon: Icon(MaterialCommunityIcons.circle_edit_outline),
            color: Colors.white,
            label: Text('Edit'),
            textColor: AppColors.seance,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () => Navigator.pushNamed(context, '/accountForm',
                arguments: account),
          ),
        ),
      ],
    );
  }
}
