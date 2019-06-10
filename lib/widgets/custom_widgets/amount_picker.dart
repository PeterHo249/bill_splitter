import 'package:flutter/material.dart';

class AmountPicker extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onAddButtonPressed;
  final ValueChanged<int> onRemoveButtonPressed;
  final ValueChanged<int> onInputChanged;
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
    this.onInputChanged,
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
  TextEditingController valueController;

  @override
  void initState() {
    super.initState();
    _buttonWidth = widget.buttonWidth;
    _valueWidth = widget.width - 2 * _buttonWidth;
    _totalWidth = widget.width;
    _height = _buttonWidth;
    valueController = TextEditingController();
    value = widget.initialValue;
    valueController.text = value.toString();
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
              if (value > widget.minValue) {
                setState(() {
                  value--;
                  valueController.text = value.toString();
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
              child: TextFormField(
                controller: valueController,
                textAlign: TextAlign.center,
                enabled: widget.onInputChanged == null ? false : true,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (value) {
                  var amount = int.tryParse(value) ?? widget.minValue;
                  if (amount < widget.minValue) {
                    amount = widget.minValue;
                  }
                  if (amount > widget.maxValue) {
                    amount = widget.maxValue;
                  }
                  setState(() {
                    valueController.text = amount.toString();
                  });
                  widget.onInputChanged(amount);
                },
                onSaved: (value) {
                  if (widget.onInputChanged != null) {
                    var amount = int.tryParse(value) ?? widget.minValue;
                    if (amount < widget.minValue) {
                      amount = widget.minValue;
                    }
                    if (widget.maxValue != null) {
                      if (amount > widget.maxValue) {
                        amount = widget.maxValue;
                      }
                    }
                    setState(() {
                      valueController.text = amount.toString();
                    });
                    widget.onInputChanged(amount);
                  }
                },
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
                valueController.text = value.toString();
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
