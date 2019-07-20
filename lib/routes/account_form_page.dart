import 'package:expended/bloc/account_bloc.dart';
import 'package:expended/bloc/bloc.dart';
import 'package:expended/misc/colors.dart';
import 'package:expended/model/account.dart';
import 'package:expended/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountFormPage extends StatefulWidget {
  final Account account;
  AccountFormPage(this.account, {Key key}) : super(key: key);

  _AccountFormPageState createState() => _AccountFormPageState();
}

class _AccountFormPageState extends State<AccountFormPage> {
  Account _account;
  Account get account => widget.account ?? _account;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final OutlineInputBorder inputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.seance)
  );

  final OutlineInputBorder errorInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red)
  );

  @override
  void initState() {
    if (account == null) {
      _account = Account();
    }

    super.initState();
  }

  void validateForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      
      if (widget.account == null) {
        BlocProvider.of<AccountBloc>(context).dispatch(AddAccount(account));
      } else {
        BlocProvider.of<AccountBloc>(context).dispatch(UpdateAccount(account));
      }
        
      Navigator.pop(context);
    }
  }

  Widget _buildBody() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextFormField(
                initialValue: account.name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: AppColors.govBay),
                  labelText: 'Account Name',
                  focusedBorder: inputBorder,
                  enabledBorder: inputBorder,
                  errorBorder: errorInputBorder,
                  focusedErrorBorder: errorInputBorder
                ),
                onSaved: (String value) => account.name = value,
                validator: (String value) => value.isEmpty ? 'You must enter a name' : null,
              ),
              Divider(indent: 100, color: AppColors.seance),
              TextFormField(
                initialValue: account.accountType,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: AppColors.govBay),
                  labelText: 'Account Type',
                  focusedBorder: inputBorder,
                  enabledBorder: inputBorder,
                  errorBorder: errorInputBorder,
                  focusedErrorBorder: errorInputBorder
                ),
                onSaved: (String value) => account.accountType = value,
                validator: (String value) => value.isEmpty ? 'You must enter a type' : null,
              ),
              Divider(color: Colors.transparent,),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: OutlineButton(
                      child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.w500),),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      borderSide: BorderSide(color: AppColors.seance),
                      onPressed: () => Navigator.pop(context)
                    ),
                  ),
                  Spacer(flex: 1,),
                  Expanded(
                    flex: 5,
                    child: OutlineButton(
                      child: Text('Save', style: TextStyle(fontWeight: FontWeight.w500),),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      borderSide: BorderSide(color: AppColors.seance),
                      onPressed: validateForm,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBar('accountForm', title: widget.account != null ? 'Edit Account' : 'New Account',)
    );
  }
}