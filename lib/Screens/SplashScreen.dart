import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wnradio/Screens/BottomNavigationScreen.dart';
import 'package:wnradio/Screens/SignInScreen.dart';
import 'package:wnradio/Utils/Colors.dart';
import 'package:wnradio/Utils/Extensions.dart';
import 'package:wnradio/Utils/Images.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wnradio/Utils/constant.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SharedPreferences pref;
  bool isLoggedIn = false;


  @override
  void initState() {
    super.initState();
    getCredential();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    changeStatusColor(white_color);
  }

  Future getCredential() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = pref.getBool("IS_LOGGED_IN");
    });
  }

  init() async {
    await Future.delayed(Duration(seconds: 5));
    BottomNavigationScreen().launch(context, isNewTask: true);
    /*if(isLoggedIn == true) BottomNavigationScreen().launch(context, isNewTask: true);
    else SignInScreen().launch(context, isNewTask: true);*/
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(white_color);
    return Container(
      color: app_Background,
      height: context.height(),
      width: context.width(),
      child: Image.asset(WNR_logo,height: context.height(),width: context.width()),
    );
  }
}
