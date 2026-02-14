import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'splash_screen.dart';
void main() {
  runApp(const DishwayApp());
}

class DishwayApp extends StatelessWidget {
  const DishwayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dishway',
      theme: AppTheme.lightTheme, // 👈 APPLY THEME HERE
      home: const SplashScreen(),
    );
  }
}