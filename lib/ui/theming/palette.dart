import 'package:flutter/widgets.dart';

class Palette {
  const Palette({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.background,
    required this.onBackground,
    required this.shadow,
  });

  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color background;
  final Color onBackground;
  final Color shadow;
}
