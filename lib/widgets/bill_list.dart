import 'package:bill_splitter/controllers/database_service.dart';
import 'package:bill_splitter/models/payment.dart';
import 'package:bill_splitter/utils/constants/bill_indicator_constant.dart';
import 'package:bill_splitter/widgets/bill_detail.dart';
import 'package:bill_splitter/widgets/custom_widgets/warning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
        icon: Icons.sentiment_dissatisfied,
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
    final SlidableController slidableController = SlidableController();
    final Color randomBackgroundColor = getRandomColor();
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BillDetail(
                  billPath: billDocument.path,
                  appBarBackgroundColor: randomBackgroundColor,
                ),
          ),
        );
      },
      child: Slidable.builder(
        key: Key(billDocument.path),
        actionPane: SlidableDrawerActionPane(),
        controller: slidableController,
        actionExtentRatio: 0.25,
        dismissal: SlidableDismissal(
          child: SlidableDrawerDismissal(),
          dismissThresholds: <SlideActionType, double>{
            SlideActionType.primary: 1.0,
          },
          onDismissed: (actionType) {
            if (actionType == SlideActionType.secondary) {
              DatabaseService.instance.deletePayment(billDocument.path);
            }
          },
        ),
        secondaryActionDelegate: SlideActionBuilderDelegate(
          builder: (context, index, animation, renderingMode) {
            return IconSlideAction(
              caption: 'Remove',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                var state = Slidable.of(context);
                state.dismiss();
                DatabaseService.instance.deletePayment(billDocument.path);
              },
            );
          },
          actionCount: 1,
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundColor: randomBackgroundColor,
                child: Icon(
                  Icons.assignment,
                  color: Colors.white,
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  billDocument.data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              subtitle: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: <Widget>[
                  IconWithTextRow(
                    icon: Icons.attach_money,
                    iconColor: Colors.red,
                    text: billDocument.data.totalCost.toStringAsFixed(2),
                  ),
                  IconWithTextRow(
                    icon: Icons.people,
                    iconColor: Colors.yellow,
                    text: billDocument.data.memberCount.toString(),
                  ),
                  IconWithTextRow(
                    icon: Icons.timelapse,
                    iconColor: Colors.green,
                    text: '${billDocument.data.paymentPartCost.toStringAsFixed(2)}/person',
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }
}

class IconWithTextRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  const IconWithTextRow({
    Key key,
    this.icon,
    this.iconColor,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            icon,
            color: iconColor,
            size: 24.0,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }
}
