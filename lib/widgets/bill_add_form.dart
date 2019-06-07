import 'package:bill_splitter/controllers/payment_notifier.dart';
import 'package:bill_splitter/models/payment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillAddForm extends StatelessWidget {
  const BillAddForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PaymentNotifier>(
      builder: (context) => PaymentNotifier(Payment()),
      child: BillAddFormBody(),
    );
  }
}

class BillAddFormBody extends StatelessWidget {
  const BillAddFormBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paymentNotifier = Provider.of<PaymentNotifier>(context);
    final bill = paymentNotifier.bill;
    return Container();
  }
}
