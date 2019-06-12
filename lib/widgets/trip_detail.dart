import 'package:bill_splitter/controllers/database_service.dart';
import 'package:bill_splitter/models/trip_tracker.dart';
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
    return StreamProvider<TripTrackerDocument>.value(
      stream: DatabaseService.instance.getTrip(tripPath),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: TripDetailBody(),
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

class TripDetailBody extends StatelessWidget {
  const TripDetailBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
