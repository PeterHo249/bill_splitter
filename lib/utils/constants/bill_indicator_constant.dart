import 'dart:math';

import 'package:flutter/material.dart';

List<Color> billIndicatorBackgroundColors = <Color>[
  Colors.red[400],
  Colors.green[400],
  Colors.orange[400],
  Colors.deepOrange[400],
  Colors.blue[400],
  Colors.indigo[400],
];

Color getRandomColor() => billIndicatorBackgroundColors[Random().nextInt(
      billIndicatorBackgroundColors.length,
    )];

var billIndicatorIcon = Icons.attach_money;
