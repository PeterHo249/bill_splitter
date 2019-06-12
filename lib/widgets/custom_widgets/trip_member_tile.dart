import 'package:bill_splitter/controllers/trip_tracker_notifier.dart';
import 'package:bill_splitter/utils/constants/bill_indicator_constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TripMemberTile extends StatefulWidget {
  final int index;
  final bool isNameModifiable;
  const TripMemberTile({
    Key key,
    this.index,
    this.isNameModifiable = false,
  }) : super(key: key);

  @override
  _TripMemberTileState createState() => _TripMemberTileState();
}

class _TripMemberTileState extends State<TripMemberTile> {
  TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tripTrackerNotifier = Provider.of<TripTrackerNotifier>(context);

    return _buildMemberTileContent(context, tripTrackerNotifier);
  }

  Widget _buildMemberTileContent(
    BuildContext context,
    TripTrackerNotifier tripTrackerNotifier,
  ) {
    var member = tripTrackerNotifier.tripTracker.members[widget.index];
    if (nameController.text == null || nameController.text.isEmpty) {
      nameController.text = member.name;
    }
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundColor: getRandomColor(),
            child: Icon(
              Icons.person_outline,
              color: Colors.white,
            ),
          ),
          title: widget.isNameModifiable
              ? TextField(
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (value) {
                    if (value == null || value.isEmpty) {
                      tripTrackerNotifier.setMemberName('Member', widget.index);
                    } else {
                      tripTrackerNotifier.setMemberName(value, widget.index);
                    }
                  },
                )
              : Text(
                  member.name ?? "Member",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
        ),
        Divider(
          color: Colors.blueGrey,
        ),
      ],
    );
  }
}
