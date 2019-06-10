import 'package:flutter/material.dart';

class CheckButton extends StatefulWidget {
  final bool initialState;
  final double size;
  final ValueChanged<bool> onStateChanged;
  final bool isPressable;
  CheckButton({
    Key key,
    this.initialState = false,
    this.size = 30.0,
    this.isPressable = true,
    @required this.onStateChanged,
  }) : super(key: key);

  _CheckButtonState createState() => _CheckButtonState();
}

class _CheckButtonState extends State<CheckButton> {
  bool state;

  @override
  void initState() {
    state = widget.initialState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: InkWell(
        onTap: () {
          if (widget.isPressable) {
            setState(() {
              state = !state;
            });
            widget.onStateChanged(state);
          }
        },
        child: CircleAvatar(
          backgroundColor: state ? Colors.green : Colors.red,
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
