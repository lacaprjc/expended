import 'package:expended/bloc/bloc.dart';
import 'package:expended/misc/colors.dart';
import 'package:expended/model/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gradient_text/gradient_text.dart';

class AccountWidget extends StatefulWidget {
  final Account account;

  const AccountWidget(this.account, {Key key}) : super(key: key);

  @override
  _AccountWidgetState createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  Account get account => widget.account;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          icon: MaterialCommunityIcons.circle_edit_outline,
          caption: 'Edit',
          color: Colors.deepPurpleAccent,
          onTap: _editAccountPressed,
        ),
        IconSlideAction(
          icon: MaterialCommunityIcons.trash_can_outline,
          caption: 'Delete',
          color: Colors.red,
          onTap: _deleteAccountPressed,
        ),
      ],
      child: ListTile(
        onTap: () =>
            Navigator.pushNamed(context, '/account', arguments: account),
        title: GradientText(
          account.name,
          gradient: LinearGradient(
            colors: [
              AppColors.seance,
              AppColors.redViolet,
            ],
          ),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        subtitle: Container(
          margin: EdgeInsets.only(left: 10),
          child: Row(
            children: <Widget>[
              Icon(
                account.accountDetails.getIconData(),
                color: account.accountDetails.getIconColor(),
                size: 16,
              ),
              Text(
                '\t\t${account.accountDetails.getString()}',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        trailing: GradientText(
          '\$${account.balance.toStringAsFixed(2)}',
          gradient: LinearGradient(
            colors: [AppColors.seance, AppColors.redViolet],
          ),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  void _editAccountPressed() {
    Navigator.pushNamed(context, '/accountForm', arguments: account);
  }

  void _deleteAccountPressed() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Are you sure?',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                FlatButton.icon(
                  textColor: Colors.red,
                  label: Text('No'),
                  icon: Icon(MaterialCommunityIcons.stop_circle_outline),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton.icon(
                  textColor: Colors.green,
                  label: Text('Yes'),
                  icon: Icon(MaterialCommunityIcons.check_circle_outline),
                  onPressed: () {
                    BlocProvider.of<AccountBloc>(context)
                        .dispatch(DeleteAccount(account));
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }
}
