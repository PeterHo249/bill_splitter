import 'package:bill_splitter/controllers/database_service.dart';
import 'package:bill_splitter/controllers/trip_tracker_notifier.dart';
import 'package:bill_splitter/models/trip_tracker.dart';
import 'package:bill_splitter/widgets/custom_widgets/amount_picker.dart';
import 'package:bill_splitter/widgets/custom_widgets/trip_member_tile.dart';
import 'package:bill_splitter/widgets/trip_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.check),
          onPressed: onSavePressed,
        ),
      ],
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
              control: TextFormField(
                initialValue: tripTracker.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required.';
                  }

                  return null;
                },
                onSaved: (value) => tripTrackerNotifier.setName(value),
                onFieldSubmitted: (value) => tripTrackerNotifier.setName(value),
              ),
            ),
            _buildFormRow(
              title: 'Start date:',
              control: Container(
                width: MediaQuery.of(context).size.width / 2.0,
                child: InkWell(
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime.now().add(
                        Duration(days: 365),
                      ),
                      currentTime: tripTracker.date,
                      onConfirm: (value) => tripTrackerNotifier.setDate(value),
                    );
                  },
                  child: Text(
                    tripTracker.tripDate,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
            _buildFormRow(
              title: 'Member count:',
              control: AmountPicker(
                width: MediaQuery.of(context).size.width / 2.0 - 20.0,
                initialValue: tripTracker.memberCount,
                onAddButtonPressed: (value) => tripTrackerNotifier.addMember(),
                onRemoveButtonPressed: (value) =>
                    tripTrackerNotifier.removeMember(),
              ),
            ),
            _buildFormRow(
              title: 'Member list:',
              control: Container(),
            ),
            ...tripTracker.members
                .asMap()
                .map((index, member) => MapEntry(
                      index,
                      TripMemberTile(
                        index: index,
                        isNameModifiable: index == 0 ? false : true,
                      ),
                    ))
                .values
                .toList(),
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
      form.save();
      var docPath = await DatabaseService.instance.writeTrip(
        Provider.of<TripTrackerNotifier>(context).tripTracker,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TripDetail(
                tripPath: docPath,
              ),
        ),
      );
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }
}
