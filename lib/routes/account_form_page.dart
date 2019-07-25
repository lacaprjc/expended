import 'package:expended/bloc/account_bloc.dart';
import 'package:expended/bloc/bloc.dart';
import 'package:expended/misc/colors.dart';
import 'package:expended/model/account.dart';
import 'package:expended/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class AccountFormPage extends StatefulWidget {
  AccountFormPage(this.account, {Key key}) : super(key: key);

  final Account account;

  _AccountFormPageState createState() => _AccountFormPageState();
}

class _AccountFormPageState extends State<AccountFormPage> {
  // final OutlineInputBorder errorInputBorder = OutlineInputBorder(
  //   borderSide: BorderSide(color: Colors.red)
  // );

  // final OutlineInputBorder inputBorder = OutlineInputBorder(
  //   borderSide: BorderSide(color: AppColors.seance)
  // );


  Account _account;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (account == null) {
      _account = Account();
    }

    super.initState();
  }

  Account get account => widget.account ?? _account;

  void validateForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      
      if (widget.account == null) {
        BlocProvider.of<AccountBloc>(context).dispatch(AddAccount(account));
      } else {
        BlocProvider.of<AccountBloc>(context).dispatch(UpdateAccount(account, account.toJson()));
      }
        
      Navigator.pop(context);
    }
  }

  Widget _buildBody() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        // height: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          child: Form(
            key: _formKey,
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildNameField(),
          // Divider(indent: 100, color: AppColors.seance),
          _buildTypeField(),
          _buildStartingBalanceField(),
          _buildConfirmationField(),
        ],
      ),
    );
  }

  Widget _buildStartingBalanceField() {
    return Container(
      // alignment: Alignment.center,
      child: Container(
        width: 300,
        child: ListTile(
          leading: Icon(MaterialCommunityIcons.currency_usd, color: AppColors.govBay,),
          title: TextFormField(
            initialValue: account.balance.toString(),
            // textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(
              fontSize: 20,
              color: AppColors.govBay,
            ),
            decoration: InputDecoration(
              hintText: 'Starting Balance',
              hintStyle: TextStyle(
                fontSize: 20,
                color: AppColors.govBay,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none
              // errorBorder: errorInputBorder,
              // focusedErrorBorder: errorInputBorder
            ),
            onSaved: (String value) => account.accountType = value.isNotEmpty ? value : 'Personal',
            // validator: (String value) => value.isEmpty ? 'You must enter a type' : null,
          ),
        ),
      ),
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
              icon: Icon(MaterialCommunityIcons.cancel),
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
              icon: Icon(MaterialCommunityIcons.check_circle_outline),
              onPressed: validateForm,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTypeField() {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.only(bottom: 20),
      // alignment: Alignment.center,
      child: Container(
        width: 300,
        child: ListTile(
          leading: Icon(MaterialCommunityIcons.bank, color: AppColors.govBay,),
          title: TextFormField(
            initialValue: account.accountType,
            // textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(
              fontSize: 20,
              color: AppColors.govBay,
            ),
            decoration: InputDecoration(
              // labelStyle: TextStyle(color: AppColors.govBay),
              // labelText: 'Account Type',
              hintText: 'Account Type',
              hintStyle: TextStyle(
                fontSize: 20,
                color: AppColors.govBay,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none
              // errorBorder: errorInputBorder,
              // focusedErrorBorder: errorInputBorder
            ),
            onSaved: (String value) => account.accountType = value.isNotEmpty ? value : 'Personal',
            // validator: (String value) => value.isEmpty ? 'You must enter a type' : null,
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      margin: EdgeInsets.only(top: 100, bottom: 20),
      // alignment: Alignment.center,
      child: Container(
        width: 300,
        child: ListTile(
          leading: Container(width: 0,),
          title: TextFormField(
            initialValue: account.name,
            textCapitalization: TextCapitalization.words,
            // textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: AppColors.govBay,
            ),
            decoration: InputDecoration(
              hintText: 'Account Name',
              hintStyle: TextStyle(
                fontSize: 20,
                color: AppColors.govBay,
              ),
              // labelStyle: TextStyle(color: AppColors.govBay),
              contentPadding: EdgeInsets.only(top: 30, bottom: 10),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              // errorBorder: InputBorder.none,
              // focusedErrorBorder: InputBorder.none
            ),
            onSaved: (String value) => account.name = value.isNotEmpty ?value : 'New Account',
            // validator: (String value) => value.isEmpty ? 'You must enter a name' : null,
          ),
        ),
      ),
    );
  }

  Widget _buildBody2() {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: 240,
        margin: EdgeInsets.only(top: 40),
        child: Form(
          key: _formKey,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.transparent,
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                gradient: LinearGradient(
                  colors: [Color(0xFF9D50BB), Color(0xFF6E48AA)],
                )
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(MaterialCommunityIcons.bank, color: Colors.white,),
                    title: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'New Account',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.white
                        ),
                        border: InputBorder.none
                      ),
                    ),
                    trailing: Icon(MaterialCommunityIcons.circle_edit_outline, color: Colors.white,),
                  ),
                  Container(
                    width: 200,
                    margin: EdgeInsets.only(top: 40, bottom: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(MaterialCommunityIcons.currency_usd, color: Colors.white, size: 36,),
                      title: TextFormField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '0.00',
                          hintStyle: TextStyle(
                            color: Colors.white
                          )
                        ),
                      ),
                    )
                  ),
                  Container(
                    // margin: EdgeInsets.only(),
                    child: Text('Account Balance', style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      // body: _buildBody(),
      body: _buildBody2(),
      bottomNavigationBar: CustomBottomNavigationBar('accountForm', title: widget.account != null ? 'Edit Account' : 'New Account',)
    );
  }
}