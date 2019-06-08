import 'package:flutter/material.dart';

class AmountPicker extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onAddButtonPressed;
  final ValueChanged<int> onRemoveButtonPressed;
  final double buttonWidth;
  final double width;
  final double iconSize;
  Color backgroundColor;
  Color foregroundColor;
  int minValue;
  int maxValue;

  AmountPicker({
    Key key,
    this.initialValue = 1,
    @required this.onAddButtonPressed,
    @required this.onRemoveButtonPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.buttonWidth = 30.0,
    this.width = 100.0,
    this.iconSize = 25.0,
    this.maxValue,
    this.minValue = 1,
  })  : assert(initialValue >= minValue),
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
    _buttonWidth = widget.buttonWidth;
    _valueWidth = widget.width - 2 * _buttonWidth;
    _totalWidth = widget.width;
    _height = _buttonWidth;
  }

  @override
  Widget build(BuildContext context) {
    value = widget.initialValue;
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
              if (value > widget.minValue) {
                setState(() {
                  value--;
                });
                widget.onRemoveButtonPressed(value);
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
              if (widget.maxValue != null && value == widget.maxValue) {
                return;
              }
              setState(() {
                value++;
              });
              widget.onAddButtonPressed(value);
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
