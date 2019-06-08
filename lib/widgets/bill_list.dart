import 'package:bill_splitter/controllers/database_service.dart';
import 'package:bill_splitter/models/payment.dart';
import 'package:bill_splitter/widgets/custom_widgets/warning.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillList extends StatelessWidget {
  const BillList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PaymentDocument>>.value(
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
    var billDocuments = Provider.of<List<PaymentDocument>>(context);

    if (billDocuments == null || billDocuments.length == 0) {
      return Warning(
        icon: Icons.mood_bad,
        message: 'Opps! No bill to show.',
      );
    }
    return ListView.builder(
      itemCount: billDocuments.length,
      itemBuilder: (context, index) {
        return BillListCell(
          billDocument: billDocuments[index],
        );
      },
    );
  }
}

class BillListCell extends StatelessWidget {
  final PaymentDocument billDocument;
  const BillListCell({
    Key key,
    this.billDocument,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        billDocument.data.totalCost.toString(),
      ),
    );
  }
}
