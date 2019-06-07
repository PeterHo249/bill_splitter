import 'package:bill_splitter/controllers/database_service.dart';
import 'package:bill_splitter/models/payment.dart';
import 'package:bill_splitter/widgets/custom_widgets/warning.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillList extends StatelessWidget {
  const BillList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Payment>>.value(
      stream: DatabaseService.instance.getPaymentListStream(),
      child: Container(
        child: BillListBody(),
      ),
    );
  }
}

class BillListBody extends StatelessWidget {
  const BillListBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bills = Provider.of<List<Payment>>(context);

    if (bills == null || bills.length == 0) {
      return Warning(
        icon: Icons.mood_bad,
        message: 'Opps! No bill to show.',
      );
    }
    return ListView.builder(
      itemCount: bills.length,
      itemBuilder: (context, index) {
        return BillListCell(
          bill: bills[index],
        );
      },
    );
  }
}

class BillListCell extends StatelessWidget {
  final Payment bill;
  const BillListCell({
    Key key,
    this.bill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        bill.cost.toString(),
      ),
    );
  }
}
