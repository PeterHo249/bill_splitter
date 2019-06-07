import 'package:flutter/material.dart';

class Warning extends StatelessWidget {
  final IconData icon;
  final String message;

  const Warning({
    Key key,
    @required this.icon,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            icon,
            size: 30.0,
            color: Colors.blueGrey,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
