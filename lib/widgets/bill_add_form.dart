import 'package:bill_splitter/controllers/database_service.dart';
import 'package:bill_splitter/controllers/payment_notifier.dart';
import 'package:bill_splitter/models/payment.dart';
import 'package:bill_splitter/widgets/bill_detail.dart';
import 'package:bill_splitter/widgets/custom_widgets/amount_picker.dart';
import 'package:bill_splitter/widgets/custom_widgets/member_tile.dart';
import 'package:bill_splitter/widgets/text_scanner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddingBillForm extends StatelessWidget {
  const AddingBillForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PaymentNotifier>(
      builder: (context) => PaymentNotifier(Payment()),
      child: AddingBillFormBody(),
    );
  }
}

class AddingBillFormBody extends StatefulWidget {
  const AddingBillFormBody({Key key}) : super(key: key);

  @override
  _AddingBillFormBodyState createState() => _AddingBillFormBodyState();
}

class _AddingBillFormBodyState extends State<AddingBillFormBody> {
  bool autoValidate;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController costController;
  PaymentNotifier billNotifier;

  @override
  void initState() {
    super.initState();
    autoValidate = false;
    costController = TextEditingController();
  }

  @override
  void dispose() {
    costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    billNotifier = Provider.of<PaymentNotifier>(context);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context, billNotifier),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Add new bill'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: onCameraPressed,
        ),
        IconButton(
          icon: Icon(Icons.check),
          onPressed: onSavePressed,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, PaymentNotifier billNotifier) {
    final bill = billNotifier.bill;
    if (costController.text == null || costController.text.isEmpty) {
      costController.text = bill.cost.toString();
    }

    return SingleChildScrollView(
      child: Form(
        autovalidate: autoValidate,
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildFormRow(
              title: 'Title:',
              control: TextFormField(
                initialValue: bill.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required.';
                  }

                  return null;
                },
                onSaved: (value) => billNotifier.setTitle(value),
                onFieldSubmitted: (value) => billNotifier.setTitle(value),
              ),
            ),
            _buildFormRow(
              title: 'Cost:',
              control: TextFormField(
                controller: costController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Cost is required.';
                  }

                  return null;
                },
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onSaved: (value) => billNotifier.setCost(
                      double.tryParse(value) ?? 0.0,
                    ),
                onFieldSubmitted: (value) => billNotifier.setCost(
                      double.tryParse(value) ?? 0.0,
                    ),
              ),
            ),
            _buildFormRow(
              title: 'Member count:',
              control: AmountPicker(
                onAddButtonPressed: (value) => billNotifier.addMember(),
                onRemoveButtonPressed: (value) => billNotifier.removeMember(),
                initialValue: bill.memberCount,
                width: MediaQuery.of(context).size.width / 2.0 - 20.0,
              ),
            ),
            _buildFormRow(
              title: 'Tip rate (%):',
              control: AmountPicker(
                onAddButtonPressed: (value) => billNotifier.setTipRate(value),
                onRemoveButtonPressed: (value) =>
                    billNotifier.setTipRate(value),
                onInputChanged: (value) => billNotifier.setTipRate(value),
                initialValue: bill.displayedTipRate,
                minValue: 0,
                maxValue: 100,
                width: MediaQuery.of(context).size.width / 2.0 - 20.0,
              ),
            ),
            _buildFormRow(
              title: 'Member List:',
              control: Container(),
            ),
            Column(
              children: bill.members
                  .asMap()
                  .map((index, member) => MapEntry(
                      index,
                      MemberTile(
                        index: index,
                        isNameModifiable: index == 0 ? false : true,
                        isStateModifiable: index == 0 ? false : true,
                      )))
                  .values
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormRow({String title, Widget control}) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        width: screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: screenWidth / 2.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            Container(
              width: screenWidth / 2.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: control,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSavePressed() async {
    final form = _formKey.currentState;

    if (form.validate()) {
      var docPath = await DatabaseService.instance.writePayment(
        Provider.of<PaymentNotifier>(context).bill,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BillDetail(
                billPath: docPath,
              ),
        ),
      );
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }

  void onCameraPressed() async {
    final cost = await Navigator.push<double>(
      context,
      MaterialPageRoute(
        builder: (context) => TextScanner(),
      ),
    );
    if (cost == null) {
      return;
    }
    setState(() {
      costController.text = cost.toString();
    });
    billNotifier.setCost(cost);
  }
}
