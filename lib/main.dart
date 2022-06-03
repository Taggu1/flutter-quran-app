import 'package:flutter/material.dart';
import 'package:quran_app/screens/home_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_app/screens/settings_screen.dart';
import 'constants.dart';
import 'models/brain.dart';
import 'models/settings.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: FlexThemeData.dark(
        scheme: scheme,
        fontFamily: kFontFamily,
      ),
      routes: {
        '/': (context) => const HomeScreen(),
        SettingsScreenContent.routeName: (context) =>
            const SettingsScreenContent()
      },
    );
  }
}
