import 'package:bill_splitter/controllers/database_service.dart';
import 'package:bill_splitter/utils/constants/theme.dart';
import 'package:bill_splitter/widgets/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Future<String> getUDId = FlutterUdid.udid;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getUDId,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          DatabaseService.instance.udid = snapshot.data;
          return MaterialApp(
            title: 'Bill Splitter',
            theme: appTheme,
            home: HomePage(),
            debugShowCheckedModeBanner: false,
          );
        } else {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}
