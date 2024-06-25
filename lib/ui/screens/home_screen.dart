import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laundromat/state/interface.dart';
import 'package:laundromat/ui/pages/selection_page.dart';

import 'package:laundromat/ui/pages/sort_page.dart';

import 'package:laundromat/utils/toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer libraryLoadTimer;
  DateTime? currentBackPressTime;

  Future<bool> doubleTapPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      showToast(
        "Tap back again to quit",
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = Interface.of(context).controller;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        if (controller.page != 0) {
          controller.jumpToPage(0);
        } else {
          final bool shouldPop = await doubleTapPop();
          if (context.mounted && shouldPop) {
            SystemNavigator.pop();
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Interface.of(context).palette.primary,
        ),
        child: SafeArea(
          child: PageView(
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              SelectionPage(),
              SortPage(),
            ],
          ),
        ),
      ),
    );
  }
}
