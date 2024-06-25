import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laundromat/state/state.dart';
import 'package:laundromat/ui/screens/home_screen.dart';
import 'package:laundromat/state/interface.dart';
import 'init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: interfaceState.palette.primary,
      statusBarIconBrightness: Brightness.dark
    )
  );
  runApp(
    Interface(
      child: const Laundromat(),
    ),
  );
}

class Laundromat extends StatelessWidget {
  const Laundromat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Interface.of(context).palette.primary,
      home: const HomeScreen(),
    );
  }
}
