import 'package:flutter/material.dart';

class ResponsiveLayout {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  static double formWidth(BuildContext context, {double defaultWidth = 500}) {
    final width = MediaQuery.of(context).size.width;
    if (width < defaultWidth + 32) return double.infinity;
    return defaultWidth;
  }
}
