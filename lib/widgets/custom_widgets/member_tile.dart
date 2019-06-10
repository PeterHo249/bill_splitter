import 'package:bill_splitter/controllers/payment_notifier.dart';
import 'package:bill_splitter/utils/constants/bill_indicator_constant.dart';
import 'package:bill_splitter/widgets/custom_widgets/check_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class MemberTile extends StatefulWidget {
  final int index;
  final bool isNameModifiable;
  final bool isStateModifiable;
  const MemberTile({
    Key key,
    @required this.index,
    this.isNameModifiable = false,
    this.isStateModifiable = true,
  }) : super(key: key);

  @override
  _MemberTileState createState() => _MemberTileState();
}

class _MemberTileState extends State<MemberTile> {
  TextEditingController nameController;
  SlidableController slidableController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    slidableController = SlidableController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var billNotifier = Provider.of<PaymentNotifier>(context);
    if (widget.index == 0) {
      return _buildMemberTileContent(context, billNotifier);
    }
    return Slidable.builder(
      key: Key(billNotifier.bill.date.toString()),
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
            billNotifier.removeMemberAt(widget.index);
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
              if (widget.index == 0) {
                return;
              }
              var state = Slidable.of(context);
              state.dismiss();
              billNotifier.removeMemberAt(widget.index);
            },
          );
        },
        actionCount: 1,
      ),
      child: _buildMemberTileContent(context, billNotifier),
    );
  }

  Widget _buildMemberTileContent(
    BuildContext context,
    PaymentNotifier billNotifier,
  ) {
    var bill = billNotifier.bill;
    var member = bill.members[widget.index];
    nameController.text = member.name;
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
                      billNotifier.setMemberName('Member', widget.index);
                    } else {
                      billNotifier.setMemberName(value, widget.index);
                    }
                  },
                )
              : Text(
                  member.name ?? "Member",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  'Is Pay Back:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CheckButton(
                    isPressable: widget.isStateModifiable,
                    onStateChanged: (state) {},
                    initialState: member.isPayBack,
                  ),
                ),
              ],
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
