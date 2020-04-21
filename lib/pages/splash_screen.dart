import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:quick_countre/pages/after_splash.dart';

class AnimatedSplash extends StatefulWidget {
  @override
  _AnimatedSplashState createState() => new _AnimatedSplashState();
}

//スプラッシュスクリーン用のクラス
class _AnimatedSplashState extends State<AnimatedSplash> {
  @override
  Widget build(BuildContext context) {
//----------------------------案１----------------------------------
    return SplashScreen(
        seconds: 2,
        navigateAfterSeconds: AfterSplash(),
        image: Image.asset('assets/icon/splash_launcher.png'),
        title: Text(
          'Quick Countre',
          style: TextStyle(
              fontSize: 70.0,
              color: Colors.white,
              fontFamily: 'jupiter'
          ),
        ),
        //backgroundColor: Colors.deepPurple[900],
        //backgroundColor: Colors.teal[900],
        //backgroundColor: Colors.cyan[900],
        //backgroundColor: Colors.blue[900],
        backgroundColor: Colors.indigo[900],
        //backgroundColor: Colors.grey[900],
        photoSize: 100.0,
        loaderColor: Colors.blue,
        styleTextUnderTheLoader: TextStyle()
    );
//----------------------------案１----------------------------------
  }
}
