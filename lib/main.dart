import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const FudpinApp());
}

class FudpinApp extends StatelessWidget {
  const FudpinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}