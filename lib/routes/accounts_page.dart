import 'package:expended/bloc/bloc.dart';
import 'package:expended/misc/colors.dart';
import 'package:expended/widgets/account_widget.dart';
import 'package:expended/widgets/custom_bottom_navigation_bar.dart';
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
    return SafeArea(
      child: Container(
        child: BlocBuilder(
          bloc: _accountBloc,
          builder: (context, AccountState state) {
            if (state is AccountsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is AccountsLoaded) {
              return ListView.separated(
                itemCount: state.accounts.length,
                separatorBuilder: (context, i) => Divider(height: 0.1, indent: 40, color: AppColors.seance,),
                itemBuilder: (context, i) {
                  return AccountWidget(state.accounts[i]);
                },
              );
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
      bottomNavigationBar: CustomBottomNavigationBar("home"),
    );
  }
}
