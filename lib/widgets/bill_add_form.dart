import 'package:bill_splitter/controllers/payment_notifier.dart';
import 'package:bill_splitter/models/payment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddingBillForm extends StatelessWidget {
  const AddingBillForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PaymentNotifier>(
      builder: (context) => PaymentNotifier(Payment()),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: AddingBillFormBody(),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Add new bill'),
    );
  }
}

class AddingBillFormBody extends StatelessWidget {
  const AddingBillFormBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paymentNotifier = Provider.of<PaymentNotifier>(context);
    final bill = paymentNotifier.bill;
    return Container();
  }
}
