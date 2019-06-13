import 'package:bill_splitter/controllers/database_service.dart';
import 'package:bill_splitter/models/payment.dart';
import 'package:bill_splitter/models/trip_tracker.dart';
import 'package:bill_splitter/widgets/bill_add_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TripDetail extends StatelessWidget {
  final String tripPath;
  final appBarBackgroundColor;

  const TripDetail({
    Key key,
    this.tripPath,
    this.appBarBackgroundColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<TripTrackerDocument>.value(
          stream: DatabaseService.instance.getTrip(tripPath),
        ),
        StreamProvider<List<PaymentDocument>>.value(
          stream: DatabaseService.instance.getPaymentListInTripStream(tripPath),
        )
      ],
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: TripDetailBody(),
        floatingActionButton: AddingBillFloatActionButton(
          backgroundColor: appBarBackgroundColor,
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Trip detail'),
      backgroundColor: appBarBackgroundColor,
    );
  }
}

class AddingBillFloatActionButton extends StatelessWidget {
  final Color backgroundColor;
  const AddingBillFloatActionButton({
    Key key,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tripDocument = Provider.of<TripTrackerDocument>(context);
    return FloatingActionButton(
      child: Icon(Icons.add, color: Colors.white),
      backgroundColor: backgroundColor,
      onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddingBillForm(
                    bill: Payment(members: tripDocument.data.members.toList()),
                    tripDocPath: tripDocument.path,
                  ),
            ),
          ),
    );
  }
}

class TripDetailBody extends StatelessWidget {
  const TripDetailBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
