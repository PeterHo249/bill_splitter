import 'package:flutter/material.dart';

class IconWithTextRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  const IconWithTextRow({
    Key key,
    this.icon,
    this.iconColor,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            icon,
            color: iconColor,
            size: 24.0,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }
}
