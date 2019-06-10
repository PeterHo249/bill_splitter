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
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              child: CameraMlVision<VisionText>(
                detector: FirebaseVision.instance.textRecognizer().processImage,
                onResult: (VisionText text) {
                  scanResult = text;
                },
              ),
            ),
            Positioned(
              left: 10.0,
              top: 10.0,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
                iconSize: 30.0,
                onPressed: () {
                  Navigator.of(context).pop<double>(
                    0.0,
                  );
                },
              ),
            ),
            Positioned(
              bottom: 30.0,
              width: MediaQuery.of(context).size.width,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop<double>(
                    getTotalCostFromVisionText(scanResult),
                  );
                },
                icon: Icon(
                  Icons.radio_button_checked,
                ),
                color: Colors.white,
                iconSize: 100.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
