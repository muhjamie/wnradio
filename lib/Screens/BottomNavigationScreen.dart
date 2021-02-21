import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mailto/mailto.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wnradio/Screens/CategoryScreen.dart';
import 'package:wnradio/Screens/DashboardScreen.dart';
import 'package:wnradio/Screens/ProfileScreen.dart';
import 'package:wnradio/Screens/RadioScreen.dart';
import 'package:wnradio/Screens/SearchScreen.dart';
import 'package:wnradio/Utils/Colors.dart';
import 'package:wnradio/Utils/Extensions.dart';
import 'package:wnradio/Utils/Images.dart';
import 'package:wnradio/Utils/Strings.dart';
import 'package:wnradio/Utils/Widgets.dart';
import 'package:wnradio/Utils/constant.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'NewsListScreen.dart';
import 'SettingScreen.dart';
import 'SignInScreen.dart';

class BottomNavigationScreen extends StatefulWidget {
  @override
  BottomNavigationScreenState createState() => BottomNavigationScreenState();
}

class BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int selectedIndex = 2;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  var arrSideMenu = [Home, Latest, Categories, Contact, Settings, Rating, share, Logout];
  var arrSideMenuIcon = [ic_home, ic_News, ic_Categories, ic_Contact_us, ic_Setting, ic_Ratting, ic_Share, ic_Logout];

  var userName = '';
  var userEmail = '';
  var mProfileImage = 'https://mobilityright.com/assets/img/testimonials/03.png';
  bool isLoading = false;
  bool isLogin = false;

  List<Widget> pages = [
    DashboardScreen(),
    CategoryScreen(true),
    RadioScreen(),
    SearchScreen(true),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    changeStatusColor(white_color);
    isLogin = await getBool(IS_LOGGED_IN);
  }

  Widget tabItem(var pos, var icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = pos;
        });
      },
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: selectedIndex == pos ? BoxDecoration(shape: BoxShape.circle, color: primaryColor.withOpacity(0.2)) : BoxDecoration(),
        child: Image.asset(
          icon,
          width: 20,
          height: 20,
          color: selectedIndex == pos ? primaryColor : textColorSecondary,
        ).paddingAll(4.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(primaryColor);
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: context.width(),
                height: context.height() * 0.15,
                child: isLogin == true
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //CircleAvatar(backgroundImage: NetworkImage(mProfileImage, scale: context.width()), radius: context.width() * 0.11),
                          4.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                userName.text(style: primaryTextStyle(color: textColorPrimary, size: textSizeMedium)),
                                userEmail.text(style: primaryTextStyle(color: textColorPrimary, size: textSizeMedium), maxLines: 2)
                              ],
                            ),
                          )
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [Login.text(style: primaryTextStyle(color: textColorPrimary, size: textSizeLargeMedium)), Divider()],
                      ),
              ).onTap(() {
                isLogin ? ProfileScreen(false).launch(context) : SignInScreen().launch(context);
              }),
              Divider(
                color: lightGrey,
              ),
              8.height,
              ListView.builder(
                itemCount: arrSideMenu.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () async {
                      if (i == 0) {
                        BottomNavigationScreen().launch(context);
                      } else if (i == 1) {
                        NewsListScreen(title: arrSideMenu[i], id: 0).launch(context);
                      } else if (i == 2) {
                        CategoryScreen(false).launch(context);
                      } else if (i == 3) {
                        await launch('mailto:User@gamil.com');
                      } else if (i == 4) {
                        SettingScreen().launch(context);
                      } else if (i == 5) {
                        OpenAppstore.launch(androidAppId: "com.iqonic.prokit");
                      } else if (i == 6) {
                        finish(context);
                        onShareTap(context);
                      } else if (i == 7) {
                        await clearSharedPref();
                        BottomNavigationScreen().launch(context, isNewTask: true);
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(arrSideMenuIcon[i], height: 20, width: 20, color: darkBgColor),
                                12.width,
                                Text(arrSideMenu[i], style: secondaryTextStyle(color: textColorPrimary, size: textSizeMedium))
                              ],
                            ),
                            Divider(color: Colors.grey.withOpacity(0)),
                          ],
                        )).paddingAll(4.0),
                  );
                },
              ),
            ],
          ).paddingOnly(left: 16, right: 16),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (pos) {
          selectedIndex = pos;
          setState(() {});
        },
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        unselectedFontSize: 14,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 14,
        items: [
          BottomNavigationBarItem(
            title: Text('Home'),
            icon: Image.asset(Home_Tab, width: 20, height: 20, color: Colors.black),
            activeIcon: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor.withOpacity(0.2)),
              child: Image.asset(
                Home_Tab,
                width: 20,
                height: 20,
                color: primaryColor,
              ),
            ),
          ),
          BottomNavigationBarItem(
            title: Text('Category'),
            icon: Image.asset(Category_Tab, width: 20, height: 20, color: Colors.black),
            activeIcon: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor.withOpacity(0.2)),
              child: Image.asset(
                Category_Tab,
                width: 20,
                height: 20,
                color: primaryColor,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(Radio_tab, width: 20, height: 20, color: Colors.black),
            title: Text('Radio'),
            activeIcon: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor.withOpacity(0.2)),
              child: Image.asset(
                Radio_tab,
                width: 20,
                height: 20,
                color: primaryColor,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(Search_Tab, width: 20, height: 20, color: Colors.black),
            title: Text('Search'),
            activeIcon: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor.withOpacity(0.2)),
              child: Image.asset(
                Search_Tab,
                width: 20,
                height: 20,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: pages[selectedIndex],
      ),
    );
  }
}
