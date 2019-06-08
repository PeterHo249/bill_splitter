import 'package:bill_splitter/controllers/cost_detector.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';

class TextScanner extends StatefulWidget {
  TextScanner({Key key}) : super(key: key);

  @override
  _TextScannerState createState() => _TextScannerState();
}

class _TextScannerState extends State<TextScanner> {
  VisionText scanResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: CameraMlVision<VisionText>(
                detector: FirebaseVision.instance.textRecognizer().processImage,
                onResult: (VisionText text) {
                  scanResult = text;
                },
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop<double>(
                  getTotalCostFromVisionText(scanResult),
                );
              },
              icon: Icon(
                Icons.radio_button_checked,
              ),
              color: Colors.white,
              iconSize: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
