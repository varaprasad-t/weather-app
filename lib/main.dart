import 'package:flutter/material.dart';
import 'package:weather/weatherfront.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  void _handleThemeChange(String selectedTheme) {
    setState(() {
      if (selectedTheme == 'light') {
        _themeMode = ThemeMode.light;
      } else if (selectedTheme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _themeMode,
      title: 'Weather app',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: Weatherfront(onThemeChanged: _handleThemeChange),
    );
  }
}
