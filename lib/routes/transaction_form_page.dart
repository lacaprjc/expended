import 'dart:io';
import 'dart:typed_data';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:expended/bloc/bloc.dart';
import 'package:expended/misc/colors.dart';
import 'package:expended/misc/formatter.dart';
import 'package:expended/model/account.dart';
import 'package:expended/model/transaction_item.dart';
import 'package:expended/widgets/custom_bottom_navigation_bar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';

class TransactionFormPage extends StatefulWidget {
  TransactionFormPage(this.accountAndTransaction, {Key key}) : super(key: key);

  final MapEntry<Account, TransactionItem> accountAndTransaction;

  TransactionFormPageState createState() => TransactionFormPageState();
}

class TransactionFormPageState extends State<TransactionFormPage> {
  final UnderlineInputBorder inputBorder =
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.white));

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Account get account => widget.accountAndTransaction.key;

  TransactionItem get transaction => widget.accountAndTransaction.value;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    clearMemoryImageCache();
    super.dispose();
  }

  void validateForm() {
    if (_formKey.currentState.validate()) {
      bool isEdit = transaction.amount !=
          0; // This tells whether the transaction is new or is being edited
      _formKey.currentState.save();

      if (!isEdit) {
        // new
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

  void _imageLongPressed() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: FlatButton.icon(
              textColor: Colors.red,
              icon: Icon(
                MaterialCommunityIcons.trash_can_outline,
                color: Colors.red,
              ),
              label: Text('Remove image'),
              onPressed: () {
                _removeImage();
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  void _viewImage() {
    Navigator.push(context, TransparentMaterialPageRoute(builder: (context) {
      return Container(
        child: Image.memory(
          Uint8List.fromList(transaction.image),
        ),
      );
    }));
  }

  void _openCamera() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    if (imageFile == null && transaction.image.isNotEmpty) {
      return;
    }

    transaction.image = await imageFile.readAsBytes();
    setState(() {});
  }

  void _openGallery() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile == null && transaction.image.isNotEmpty) {
      return;
    }

    transaction.image = await imageFile.readAsBytes();
    setState(() {});
  }

  void _removeImage() {
    clearMemoryImageCache();
    transaction.image = List();

    setState(() {});
  }

  Widget _buildDateAndTimeField() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              MaterialCommunityIcons.calendar_outline,
              size: 20,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              width: 180,
              child: DateTimeField(
                initialValue: transaction.date.isNotEmpty
                    ? DateTime.parse(transaction.date)
                    : DateTime.now(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                format: Formatter.dateFormat,
                readOnly: true,
                decoration: InputDecoration(
                  border: inputBorder,
                  focusedBorder: inputBorder,
                  enabledBorder: inputBorder,
                ),
                resetIcon: null,
                onShowPicker: (context, DateTime currentDate) {
                  return showDatePicker(
                    firstDate: DateTime(2000),
                    lastDate: DateTime(DateTime.now().year + 5),
                    initialDate: currentDate ?? DateTime.now(),
                    context: context,
                  );
                },
                onSaved: (value) =>
                    transaction.date = value.toString().substring(0, 10),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              MaterialCommunityIcons.clock_outline,
              size: 20,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 10,
              ),
              width: 180,
              child: DateTimeField(
                initialValue: transaction.time.isNotEmpty
                    ? DateTimeField.convert(TimeOfDay(
                        hour: int.parse(transaction.time
                            .substring(0, transaction.time.indexOf(':'))),
                        minute: int.parse(transaction.time.split(':')[1])))
                    : DateTime.now(),
                format: Formatter.timeFormat,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  border: inputBorder,
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorder,
                ),
                resetIcon: null,
                readOnly: true,
                onShowPicker: (context, DateTime currentTime) async {
                  return DateTimeField.convert(
                    await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                        currentTime ?? DateTime.now(),
                      ),
                    ),
                  );
                },
                onSaved: (value) => transaction.time = value.hour.toString() +
                    ':' +
                    value.minute.toString() +
                    ':' +
                    value.second.toString(),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildImageField() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  MaterialCommunityIcons.camera_outline,
                  size: 30,
                  color: AppColors.green,
                ),
                onPressed: _openCamera,
              ),
              IconButton(
                icon: Icon(
                  MaterialCommunityIcons.image_outline,
                  size: 30,
                  color: AppColors.green,
                ),
                onPressed: _openGallery,
              ),
            ],
          ),
          Container(
            // color: Colors.red,
            child: transaction.image.isEmpty
                ? Container()
                : Container(
                    child: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        InkWell(
                          onTap: _viewImage,
                          onLongPress: _imageLongPressed,
                          child: ExtendedImage.memory(
                            Uint8List.fromList(transaction.image),
                            width: 80,
                            height: 160,
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Container(
              padding: EdgeInsets.only(
                bottom: 20,
              ),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                gradient: LinearGradient(
                  colors: [
                    Color(0xff808080),
                    AppColors.green,
                  ],
                ),
              ),
              child: Column(
                children: <Widget>[
                  _buildNameField(),
                  _buildAmountField(),
                  _buildAmountFieldLabel(),
                  _buildDateAndTimeField()
                ],
              ),
            ),
          ),
        ),
        _buildConfirmation()
      ],
    );
  }

  Widget _buildConfirmation() {
    return Container(
      alignment: Alignment.bottomRight,
      child: FlatButton.icon(
        color: Colors.white,
        textColor: Color(0xff3fada8),
        label: Text(
          'Save',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        icon: Icon(
          MaterialCommunityIcons.check_circle_outline,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: validateForm,
      ),
    );
  }

  Widget _buildAmountFieldLabel() {
    return Container(
      child: Text(
        'Amount',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return Container(
      width: 200,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          MaterialCommunityIcons.currency_usd,
          color: Colors.white,
          size: 36,
        ),
        title: TextFormField(
          keyboardType: TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          initialValue: transaction.amount != 0.00
              ? Formatter.numberFormat.format(transaction.amount)
              : '',
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '0.00',
            hintStyle: TextStyle(
              color: Colors.white,
              // fontSize: 36,
            ),
          ),
          onSaved: (String value) =>
              transaction.amount = Formatter.numberFormat.parse(value),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return ListTile(
      leading: Icon(
        MaterialCommunityIcons.receipt,
        color: Colors.white,
      ),
      title: TextFormField(
        initialValue: transaction.name,
        textCapitalization: TextCapitalization.words,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
        decoration: InputDecoration(
          hintText: 'New Transction',
          hintStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
          border: InputBorder.none,
        ),
        onSaved: (String value) =>
            transaction.name = value.isEmpty ? 'New Transactions' : value,
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            maxLines: null,
            initialValue: transaction.notes,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Notes',
              border: InputBorder.none,
            ),
            onSaved: (String value) =>
                transaction.notes = value.trim().isEmpty ? '' : value.trim(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.symmetric(
            // horizontal: 10,
            ),
        child: Column(
          children: <Widget>[
            _buildTransactionCard(),
            _buildNotesField(),
            _buildImageField(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBar(
        'transactionForm',
        title: transaction.name.isEmpty ? 'New Transaction' : transaction.name,
      ),
    );
  }
}
