import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wnradio/Screens/SplashScreen.dart';
import 'package:wnradio/Utils/Colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: app_Background,
          backgroundColor: app_Background,
          scaffoldBackgroundColor: app_Background,
          fontFamily: 'SFUIText',
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false);
  }
}
