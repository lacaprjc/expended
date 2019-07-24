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
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AccountBloc>(context).dispatch(LoadAllAccounts());
  }

  Widget _buildBody() {
    return SafeArea(
      child: Container(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: BlocBuilder(
            bloc: BlocProvider.of<AccountBloc>(context),
            condition: (AccountState previousState, AccountState currentState) {
              return (currentState is AccountsAllLoading ||
                  currentState is AccountsLoaded);
            },
            builder: (context, AccountState state) {
              if (state is AccountsAllLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is AccountsLoaded) {
                return ListView.separated(
                  itemCount: state.accounts.length,
                  separatorBuilder: (context, i) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        height: 0.1,
                        color: AppColors.seance,
                      ));
                  },
                  itemBuilder: (context, i) {
                    return AccountWidget(state.accounts[i]);
                  },
                );
              }

              return Container();
            },
          ),
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
