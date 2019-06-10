import 'package:bill_splitter/controllers/database_service.dart';
import 'package:bill_splitter/models/payment.dart';
import 'package:bill_splitter/utils/constants/bill_indicator_constant.dart';
import 'package:bill_splitter/widgets/custom_widgets/warning.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillDetail extends StatelessWidget {
  final String billPath;
  final Color appBarBackgroundColor;
  const BillDetail({
    Key key,
    this.billPath,
    this.appBarBackgroundColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<PaymentDocument>.value(
      stream: DatabaseService.instance.getPaymentStream(billPath),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: BillDetailBody(),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Bill detail'),
      backgroundColor: appBarBackgroundColor,
    );
  }
}

class BillDetailBody extends StatelessWidget {
  const BillDetailBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billDocument = Provider.of<PaymentDocument>(context);
    var screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Scaffold.of(context).appBarMaxHeight;
    screenHeight = (screenHeight > 650.0 ? screenHeight : 650.0) - 10.0;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width,
          height: screenHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('assets/img/receipt_background.png'),
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.5),
                BlendMode.dstATop,
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: billDocument == null
              ? Warning(
                  icon: Icons.refresh,
                  message: 'Waiting for receipt information...',
                )
              : _buildContent(context, billDocument),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PaymentDocument billDocument) {
    final bill = billDocument.data;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            bill.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 25.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Text(
            'Date: ${bill.billDate}',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        _buildContentRow(
          leftChild: Text(
            'Cost:',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          rightChild: Text(
            '${bill.cost.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        _buildContentRow(
          leftChild: Text(
            'Tip rate:',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          rightChild: Text(
            '${bill.displayedTipRate}%',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        Divider(
          color: Colors.blueGrey,
        ),
        _buildContentRow(
          leftChild: Text(
            'Total:',
            style: TextStyle(
              fontSize: 25.0,
            ),
          ),
          rightChild: Text(
            '${bill.totalCost.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 35.0,
            ),
          ),
        ),
        Divider(
          color: Colors.blueGrey,
        ),
        _buildContentRow(
          leftChild: Text(
            'Member count:',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          rightChild: Text(
            '${bill.memberCount}',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        _buildContentRow(
          leftChild: Text(
            'Cost per member:',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          rightChild: Text(
            '${bill.paymentPartCost.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 25.0,
            ),
          ),
        ),
        Divider(
          color: Colors.blueGrey,
        ),
        _buildContentRow(
          leftChild: Text(
            'Member list:',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          rightChild: Container(),
        ),
        Container(
          height: 200.0,
          child: ListView.builder(
            itemCount: bill.memberCount,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => MemberTilePortrait(
                  index: index,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentRow({
    EdgeInsetsGeometry padding,
    Widget leftChild,
    Widget rightChild,
  }) {
    padding = padding ??
        EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 15.0,
        );
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          leftChild,
          rightChild,
        ],
      ),
    );
  }
}

class MemberTilePortrait extends StatelessWidget {
  final int index;
  MemberTilePortrait({
    Key key,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billDocument = Provider.of<PaymentDocument>(context);
    return Row(
      children: <Widget>[
        Container(
          height: 200.0,
          width: 150.0,
          child: _buildContent(
            context,
            billDocument,
          ),
        ),
        VerticalDivider(
          color: Colors.blueGrey,
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    PaymentDocument billDocument,
  ) {
    PayState member = billDocument.data.members[index];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: 70.0,
          height: 70.0,
          child: CircleAvatar(
            backgroundColor: getRandomColor(),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 35.0,
            ),
          ),
        ),
        Text(
          member.name,
          style: TextStyle(
            fontSize: 18.0,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              'Is pay back:',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
            Container(
              width: 30.0,
              height: 30.0,
              child: InkWell(
                onTap: () {
                  onStateButtonPressed(index, billDocument);
                },
                child: CircleAvatar(
                  backgroundColor: member.isPayBack ? Colors.green : Colors.red,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void onStateButtonPressed(int index, PaymentDocument billDocument) {
    DatabaseService.instance.changePaymentState(index, billDocument);
  }
}
