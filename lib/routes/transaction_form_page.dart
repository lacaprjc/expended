import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:expended/bloc/bloc.dart';
import 'package:expended/misc/colors.dart';
import 'package:expended/model/account.dart';
import 'package:expended/model/transaction_item.dart';
import 'package:expended/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionFormPage extends StatefulWidget {
  final MapEntry<Account, TransactionItem> accountAndTransaction;
  TransactionFormPage(this.accountAndTransaction, {Key key}) : super(key: key);

  TransactionFormPageState createState() => TransactionFormPageState();
}

class TransactionFormPageState extends State<TransactionFormPage> {
  Account get account => widget.accountAndTransaction.key;
  TransactionItem get transaction => widget.accountAndTransaction.value;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final UnderlineInputBorder inputBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: AppColors.govBay)
  );

  void validateForm() {
    if (_formKey.currentState.validate()) {
      bool isEdit = transaction.amount != 0; // This tells whether the transaction is new or is being edited
      _formKey.currentState.save();
      
      if (!isEdit){ // new
       account.transactions.add(transaction);
      }
      
      account.balance += transaction.amount;
      BlocProvider.of<AccountBloc>(context).dispatch(UpdateAccount(account, {
        'balance': account.balance,
        'transactions': account.transactionsToJson()
      }));

      Navigator.pop(context);
    }
  }

  Widget _buildAmountField() {
    return Container(
      margin: EdgeInsets.only(top: 100, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Container(
              child: Icon(Icons.attach_money, size: 50, color: AppColors.govBay,)
            ),
          ),
          Container(
            width: 100,
            child: TextFormField(
              initialValue: transaction.amount != 0 ? transaction.amount.toString() : '',
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: AppColors.govBay
              ),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: TextStyle(color: AppColors.govBay),
                contentPadding: EdgeInsets.only(top: 30, bottom: 10),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                errorStyle: TextStyle(height: .1)
              ),
              onSaved: (value) => transaction.amount = value.isNotEmpty ? double.parse(value) : 0.00,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        initialValue: transaction.name.isNotEmpty ? transaction.name : '',
        textAlign: TextAlign.center,
        textCapitalization: TextCapitalization.words,
        style: TextStyle(
          fontSize: 20,
          color: AppColors.govBay,
        ),
        decoration: InputDecoration(
          hintText: 'Transaction Name',
          hintStyle: TextStyle(
            fontSize: 20,
            color: AppColors.govBay,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          // border: InputBorder.none,
        ),
        onSaved: (value) => transaction.name = value.isNotEmpty ? value : 'New Transaction',
      ),
    );
  }

  Widget _buildDateAndTimeField() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(EvaIcons.calendarOutline, size: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              width: 180,
              child: DateTimeField(
                initialValue: transaction.date.isNotEmpty 
                  ? DateTime.parse(transaction.date)
                  : DateTime.now(),
                style: TextStyle(
                  color: AppColors.govBay,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
                format: DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY),
                readOnly: true,
                decoration: InputDecoration(
                  border: inputBorder,
                  enabledBorder: inputBorder
                ),
                resetIcon: null,
                onShowPicker: (context, DateTime currentDate) {
                  return showDatePicker(
                    firstDate: DateTime(2000),
                    lastDate: DateTime(DateTime.now().year + 5),
                    initialDate: currentDate ?? DateTime.now(),
                    context: context
                  );
                },
                onSaved: (value) => transaction.date = value.toString().substring(0, 10),
              ),
            ),
          ],
        ),
        Container(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(EvaIcons.clockOutline, size: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              width: 180,
              child: DateTimeField(
                initialValue: transaction.time.isNotEmpty
                  ? DateTimeField.convert(
                    TimeOfDay(
                      hour: int.parse(transaction.time.substring(0, transaction.time.indexOf(':'))),
                      minute: int.parse(transaction.time.split(':')[1])
                    )
                  )
                  : DateTime.now()
                ,
                format: DateFormat(DateFormat.HOUR_MINUTE),
                style: TextStyle(
                  color: AppColors.govBay,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  border: inputBorder,
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorder
                ),
                resetIcon: null,
                readOnly: true,
                onShowPicker: (context, DateTime currentTime) async {
                  return DateTimeField.convert(await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(currentTime ?? DateTime.now())
                  ));
                },
                onSaved: (value) => transaction.time = value.hour.toString() + ':' + value.minute.toString() + ':' + value.second.toString(),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmationField() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton.icon(
              textColor: AppColors.govBay,
              label: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 22
                ),
              ),
              icon: Icon(EvaIcons.closeCircleOutline),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton.icon(
              textColor: AppColors.govBay,
              label: Text(
                'Save',
                style: TextStyle(
                  fontSize: 22
                ),
              ),
              icon: Icon(EvaIcons.checkmarkCircle2Outline),
              onPressed: validateForm,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildAmountField(),
          _buildNameField(),
          _buildDateAndTimeField(),
          _buildConfirmationField(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        height: double.infinity,
        // color: Colors.red,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          child: Container(
            child: Form(
              autovalidate: true,
              key: _formKey,
              child: _buildForm()
            ),
          ),
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.seance,
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBar(
        'transactionForm',
        title: transaction.name,
      ),
    );
  }
}