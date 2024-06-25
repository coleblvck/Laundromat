import 'package:laundromat/ui/theming/palette.dart';
import 'package:flutter/widgets.dart';

class InterfaceState {
  Palette palette = const Palette(
    primary: Color.fromARGB(255, 216, 202, 176),
    onPrimary: Color.fromARGB(255, 0, 0, 0),
    secondary: Color.fromARGB(255, 148, 169, 129),
    onSecondary: Color.fromARGB(255, 0, 0, 0),
    background: Color.fromARGB(255, 38, 35, 40),
    onBackground: Color.fromARGB(255, 255, 255, 255),
    shadow: Color.fromARGB(255, 91, 91, 91),
  );
  final PageController controller = PageController();
}
