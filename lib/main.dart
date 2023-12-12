import "package:flutter/material.dart";
import 'package:gwelcome_front/features/auth/presentation/pages/app_widget.dart';
import 'service._locator.dart';

void main() {
  setupLocator();
  runApp(const AppWidget());
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
