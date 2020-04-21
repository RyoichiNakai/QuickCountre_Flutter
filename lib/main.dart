import 'package:flutter/material.dart';
import 'package:quick_countre/pages/after_splash.dart';
import 'package:quick_countre/pages/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: AfterSplash()
    );
  }
}