
import 'package:flutter/widgets.dart';
import 'package:laundromat/state/state.dart';
import 'package:laundromat/ui/theming/palette.dart';

class Interface extends InheritedWidget {
  Interface({
    super.key,
    required super.child,
  });

  final PageController controller = interfaceState.controller;

  final Palette palette = interfaceState.palette;

  static Interface? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Interface>();
  }

  static Interface of(BuildContext context) {
    final Interface? result = maybeOf(context);
    assert(result != null, 'No Interface found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(Interface oldWidget) {
    return oldWidget.palette != palette;
  }
}

