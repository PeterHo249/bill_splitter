import 'package:bill_splitter/controllers/database_service.dart';
import 'package:bill_splitter/models/trip_tracker.dart';
import 'package:bill_splitter/utils/constants/bill_indicator_constant.dart';
import 'package:bill_splitter/widgets/custom_widgets/icon_with_text_row.dart';
import 'package:bill_splitter/widgets/custom_widgets/warning.dart';
import 'package:bill_splitter/widgets/trip_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class TripList extends StatelessWidget {
  const TripList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<TripTrackerDocument>>.value(
      stream: DatabaseService.instance.getTripList(),
      child: Container(
        child: TripListBody(),
      ),
    );
  }
}

class TripListBody extends StatelessWidget {
  const TripListBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tripDocuments = Provider.of<List<TripTrackerDocument>>(context);

    if (tripDocuments == null || tripDocuments.isEmpty) {
      return Warning(
        icon: Icons.sentiment_dissatisfied,
        message: 'Opps! No trip to show.',
      );
    }

    return ListView.builder(
      itemCount: tripDocuments.length,
      itemBuilder: (context, index) =>
          TripListCell(tripDocument: tripDocuments[index]),
    );
  }
}

class TripListCell extends StatelessWidget {
  final TripTrackerDocument tripDocument;
  const TripListCell({
    Key key,
    this.tripDocument,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SlidableController slidableController = SlidableController();
    final Color randomBackgroundColor = getRandomColor();
    return InkWell(
      onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TripDetail(
                    tripPath: tripDocument.path,
                    appBarBackgroundColor: randomBackgroundColor,
                  ),
            ),
          ),
      child: Slidable.builder(
        key: Key(tripDocument.path),
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
              DatabaseService.instance.deleteTrip(tripDocument.path);
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
                DatabaseService.instance.deleteTrip(tripDocument.path);
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
                  tripDocument.data.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              subtitle: IconWithTextRow(
                icon: Icons.people,
                iconColor: Colors.amber,
                text: tripDocument.data.memberCount.toString(),
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
