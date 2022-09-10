import 'package:flutter/material.dart';
import 'package:google_map/Screen/CustomMarkers.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:google_map/Screen/IntroductionScreen.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home:  AnimatedSplashScreen(
          duration: 4000,
          splash: Lottie.asset('assets/splash/splash3.json'),
          splashIconSize: 450,
          nextScreen: OnBoardingPage(),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Color(0xFF1E4090),
      )
    );
  }
}

