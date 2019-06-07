import 'package:flutter/material.dart';

class AmountPicker extends StatefulWidget {
  final int initialValue;
  final ValueChanged onValueChanged;
  final double buttonWidth;
  final double valueWidth;
  final double iconSize;
  Color backgroundColor;
  Color foregroundColor;

  AmountPicker({
    Key key,
    this.initialValue = 1,
    @required this.onValueChanged,
    this.backgroundColor,
    this.foregroundColor,
    this.buttonWidth = 30.0,
    this.valueWidth = 50.0,
    this.iconSize = 25.0,
  })  : assert(initialValue >= 1),
        super(key: key) {
    backgroundColor = backgroundColor ?? Colors.blue[100];
    foregroundColor = foregroundColor ?? Colors.blue;
  }

  _AmountPickerState createState() => _AmountPickerState();
}

class _AmountPickerState extends State<AmountPicker> {
  int value;
  double _buttonWidth;
  double _valueWidth;
  double _totalWidth;
  double _height;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
    _buttonWidth = widget.buttonWidth;
    _valueWidth = widget.valueWidth;
    _totalWidth = 2 * _buttonWidth + _valueWidth;
    _height = _buttonWidth;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _totalWidth,
      height: _height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          InkWell(
            onTap: () {
              if (value > 1) {
                setState(() {
                  value--;
                });
                widget.onValueChanged(value);
              }
            },
            child: Container(
              width: _buttonWidth,
              height: _height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_buttonWidth / 2),
                color: widget.backgroundColor,
              ),
              child: Center(
                child: Icon(
                  Icons.remove,
                  color: widget.foregroundColor,
                  size: widget.iconSize,
                ),
              ),
            ),
          ),
          Container(
            width: _valueWidth,
            child: Center(
              child: Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                value++;
              });
              widget.onValueChanged(value);
            },
            child: Container(
              width: _buttonWidth,
              height: _height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_buttonWidth / 2),
                color: widget.backgroundColor,
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: widget.foregroundColor,
                  size: widget.iconSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
