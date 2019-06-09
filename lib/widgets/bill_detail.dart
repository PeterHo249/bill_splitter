import 'package:flutter/material.dart';

class BillDetail extends StatelessWidget {
  final String billPath;
  final Color appBarBackgroundColor;
  const BillDetail({
    Key key,
    this.billPath,
    this.appBarBackgroundColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Bill detail'),
      backgroundColor: appBarBackgroundColor,
    );
  }
}
