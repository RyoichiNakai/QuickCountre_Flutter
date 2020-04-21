import 'package:flutter/material.dart';
import 'package:quick_countre/pages/my_homescreen.dart';
import 'package:quick_countre/pages/my_gamescreen.dart';

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'quickcounre',
      home: MyHomeScreen(),
      routes: <String, WidgetBuilder>{
        '/myhomepage': (BuildContext context) => new MyHomeScreen(),
        '/mygamepage': (BuildContext context) => new MyGameScreen(),
      },
    );
  }
}