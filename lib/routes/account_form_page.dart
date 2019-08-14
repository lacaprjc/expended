import 'package:expended/bloc/account_bloc.dart';
import 'package:expended/bloc/bloc.dart';
import 'package:expended/misc/account_details.dart';
import 'package:expended/misc/colors.dart';
import 'package:expended/misc/formatter.dart';
import 'package:expended/model/account.dart';
import 'package:expended/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class AccountFormPage extends StatefulWidget {
  AccountFormPage({Key key}) : super(key: key);

  _AccountFormPageState createState() => _AccountFormPageState();
}

class _AccountFormPageState extends State<AccountFormPage> {
  Account account;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    account = Provider.of<Account>(context) ?? Account();
  }

  void validateForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (account.id == null) {
        BlocProvider.of<AccountBloc>(context).dispatch(AddAccount(account));
      } else {
        BlocProvider.of<AccountBloc>(context).dispatch(UpdateAccount(
          account,
          account.toJson(),
        ));
      }

      Navigator.pop(context);
    }
  }

  Widget _buildForm() {
    return DefaultTextStyle(
      style: TextStyle(
        color: Colors.white,
      ),
      child: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              _buildAccountCard(),
              _buildAccountTypeField(),
              _buildNotesField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          maxLines: null,
          initialValue: account.accountDetails.notes,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Account Notes',
            border: InputBorder.none,
          ),
          onSaved: (String value) => account.accountDetails.notes =
              value.trim().isEmpty ? '' : value.trim(),
        ),
      ),
    );
  }

  Widget _buildAccountTypeField() {
    return Container(
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        itemCount: AccountType.values.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, i) => _buildAccountTypeItem(
          AccountDetails(AccountType.values[i]),
        ),
      ),
    );
  }

  Widget _buildAccountTypeItem(AccountDetails details) {
    return InkWell(
      onTap: () => setState(
          () => account.accountDetails.accountType = details.accountType),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: account.accountDetails.accountType == details.accountType
              ? BorderSide(
                  color: details.getIconColor(),
                  width: 3,
                )
              : BorderSide.none,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              // flex: 1,
              child: Container(
                child: Icon(
                  details.getIconData(),
                  color: details.getIconColor(),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: details.getIconColor(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
                child: Text(
                  details.getString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmation() {
    return Container(
      alignment: Alignment.bottomRight,
      child: FlatButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        textColor: AppColors.seance,
        label: Text(
          'Save',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        icon: Icon(
          MaterialCommunityIcons.check_circle_outline,
        ),
        onPressed: validateForm,
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildAccountCard() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          height: 240,
          margin: EdgeInsets.only(bottom: 10),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                gradient: AppGradients.accountCard,
              ),
              child: Column(
                children: <Widget>[
                  _buildNameField(),
                  _buildStartingBalanceField(),
                  _buildStartingBalanceFieldLabel(),
                ],
              ),
            ),
          ),
        ),
        _buildConfirmation(),
      ],
    );
  }

  Widget _buildStartingBalanceFieldLabel() {
    return Container(
      child: Text(
        'Account Balance',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildStartingBalanceField() {
    return Container(
      width: 200,
      margin: EdgeInsets.only(top: 20, bottom: 10),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          MaterialCommunityIcons.currency_usd,
          color: Colors.white,
          size: 36,
        ),
        title: TextFormField(
          initialValue: account.balance != 0.00
              ? Formatter.numberFormat.format(account.balance)
              : '',
          keyboardType: TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '0.00',
            hintStyle: TextStyle(color: Colors.white),
          ),
          onSaved: (String value) => account.balance =
              Formatter.numberFormat.parse(value.padLeft(1, '0')),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return ListTile(
      leading: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        switchOutCurve: Curves.easeOut,
        child: Icon(
          account.accountDetails.getIconData(),
          color: Colors.white,
          key: UniqueKey(),
        ),
      ),
      title: TextFormField(
        autofocus: true,
        initialValue: account.name,
        textCapitalization: TextCapitalization.words,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: 'New Account',
          hintStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Colors.white,
          ),
          border: InputBorder.none,
        ),
        onSaved: (value) =>
            account.name = value.isEmpty ? 'New Account' : value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBar(
        'accountForm',
        title: account.id != null ? 'Edit Account' : 'New Account',
      ),
    );
  }
}
