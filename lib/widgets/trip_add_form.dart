import 'package:bill_splitter/controllers/trip_tracker_notifier.dart';
import 'package:bill_splitter/models/trip_tracker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddingTripTrackerForm extends StatelessWidget {
  const AddingTripTrackerForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TripTrackerNotifier>(
      builder: (context) => TripTrackerNotifier(TripTracker()),
      child: AddingTripTrackerFormBody(),
    );
  }
}

class AddingTripTrackerFormBody extends StatefulWidget {
  const AddingTripTrackerFormBody({Key key}) : super(key: key);

  @override
  _AddingTripTrackerFormBodyState createState() =>
      _AddingTripTrackerFormBodyState();
}

class _AddingTripTrackerFormBodyState extends State<AddingTripTrackerFormBody> {
  bool autoValidate;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TripTrackerNotifier tripTrackerNotifier;

  @override
  void initState() {
    super.initState();
    autoValidate = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tripTrackerNotifier = Provider.of<TripTrackerNotifier>(context);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context, tripTrackerNotifier),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Add new trip'),
    );
  }

  Widget _buildBody(
    BuildContext context,
    TripTrackerNotifier tripTrackerNotifier,
  ) {
    final tripTracker = tripTrackerNotifier.tripTracker;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidate: autoValidate,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildFormRow(
              title: 'Name:',
              control: Container(),
            ),
            _buildFormRow(
              title: 'Start date:',
              control: Container(),
            ),
            _buildFormRow(
              title: 'Member count:',
              control: Container(),
            ),
            _buildFormRow(
              title: 'Member list:',
              control: Container(),
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
}
