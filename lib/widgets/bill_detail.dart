import 'package:flutter/material.dart';

class BillDetail extends StatelessWidget {
  final String billPath;
  const BillDetail({
    Key key,
    this.billPath,
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
    );
  }
}
