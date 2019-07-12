import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:expended/bloc/bloc.dart';
import 'package:expended/misc/colors.dart';
import 'package:expended/model/account.dart';
import 'package:expended/widgets/account_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({Key key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  AccountBloc _accountBloc;

  @override
  void initState() { 
    super.initState();
    _accountBloc = BlocProvider.of<AccountBloc>(context);
    _accountBloc.dispatch(LoadAccounts());
  }

  Widget _buildBody() {
    return Container(
      child: BlocBuilder(
        bloc: _accountBloc,
        builder: (context, AccountState state) {
          if (state is AccountsLoading) {
            return CircularProgressIndicator();
          } else if (state is AccountsLoaded) {
            return ListView.separated(
              itemCount: state.accounts.length,
              separatorBuilder: (context, i) => Divider(height: 0.1, indent: 40, color: AppColors.seance,),
              itemBuilder: (context, i) {
                final Account account = state.accounts[i];
                
                return AccountWidget(account);
              },
            );
          }

          return Container();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bar_bg.png'),
            fit: BoxFit.fill,
          ),
        ),
        height: 80,
        child: Row(
          children: <Widget>[
            Spacer(flex: 1,),
            Expanded(
              flex: 1,
              child: Text(
                'Accounts',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                color: Colors.white,
                icon: Icon(EvaIcons.plusSquareOutline),
                onPressed: () {
                  Account account = Account(name: 'This is a long one', accountType: 'Credit');
                  _accountBloc.dispatch(AddAccount(account));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

