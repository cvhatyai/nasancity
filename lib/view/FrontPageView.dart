import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/system/widht_device.dart';
import 'package:nasancity/view/complain/ComplainCateListView.dart';
import 'package:nasancity/view/home/front_screnn.dart';
import 'package:nasancity/view/menu/MenuScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nasancity/model/user.dart';
import 'package:nasancity/system/FirebaseNotification.dart';
import 'package:nasancity/view/login/LoginView.dart';
import 'package:nasancity/view/nearme/NearMeView.dart';
import 'package:nasancity/view/news/NewsDetailView.dart';

import 'package:nasancity/view/news/NewsListView.dart';
import 'package:nasancity/view/noti/NotiListView.dart';
import 'package:nasancity/view/policy/PolicyBanner.dart';
import 'package:nasancity/view/search/SearchView.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'chat/ChatView.dart';
import 'home/HomeView.dart';
import 'menu/MenuView.dart';

class FrontPageView extends StatefulWidget {
  @override
  _FrontPageViewState createState() => _FrontPageViewState();
}

class _FrontPageViewState extends State<FrontPageView> {
  int selectedIndex = 0;
  List<Widget> _widgetOptions = [
    FrontpageScreen(),
    ComplainCateListView(),
    ChatView(),
    NearMeView(),
    MenuScreen()
  ];

  var user = User();
  bool isLogin = false;

  TextStyle _textSelected = TextStyle(
      color: Color(0XFF45494C),
      fontSize: 10,
      fontFamily: FontStyles.FontFamily,
      height: 1);
  TextStyle _text = TextStyle(
      color: Color(0XFF45494C),
      fontSize: 10,
      fontFamily: FontStyles.FontFamily,
      height: 1);

  ShapeDecoration _shapeDecoration = ShapeDecoration(
    shape: CircleBorder(),
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.1, 0.9],
      colors: [
        Colors.white,
        Colors.grey.shade400,
      ],
    ),
  );
  //------

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }

  getUsers() async {
    await user.init();
    setState(() {
      isLogin = user.isLogin;
    });

    if (isLogin) {
      _widgetOptions = [
        FrontpageScreen(),
        ComplainCateListView(),
        ChatView(),
        NearMeView(),
        MenuScreen()
      ];
    } else {
      _widgetOptions = [
        FrontpageScreen(),
        ComplainCateListView(),
        ChatView(),
        NearMeView(),
        MenuScreen()
      ];
    }
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              child: _widgetOptions.elementAt(selectedIndex),
            ),
            Positioned(
              bottom: 0,
              child: PrivacyPolicyBanner(),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.only(
            //     topRight: Radius.circular(20.0),
            //     topLeft: Radius.circular(20.0)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFFF),
                Color(0xFF72797E59),
              ],
            ),
          ),
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.only(left: 25, right: 25),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        onItemTapped(0);
                      },
                      child: Container(
                        decoration: selectedIndex == 0
                            ? _shapeDecoration
                            : BoxDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              'assets/icon/menubar/menubar_home.png',
                              fit: BoxFit.fitWidth,
                              width: 20,
                            ),
                            Text(
                              'หน้าแรก',
                              style: selectedIndex == 0 ? _textSelected : _text,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        onItemTapped(1);
                      },
                      child: Container(
                        decoration: selectedIndex == 1
                            ? _shapeDecoration
                            : BoxDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              'assets/icon/menubar/menubar_edit.png',
                              fit: BoxFit.fitWidth,
                              width: 20,
                            ),
                            Text(
                              'ร้องเรียน/\nร้องทุกข์',
                              style: selectedIndex == 1 ? _textSelected : _text,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        onItemTapped(2);
                      },
                      child: Container(
                        decoration: selectedIndex == 2
                            ? _shapeDecoration
                            : BoxDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                shape: CircleBorder(),
                                color: Color(0xffeb1717),
                              ),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        onItemTapped(3);
                      },
                      child: Container(
                        decoration: selectedIndex == 3
                            ? _shapeDecoration
                            : BoxDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Image.asset(
                                'assets/icon/menubar/menubar_placeholder.png',
                                fit: BoxFit.fitWidth,
                                width: 20,
                              ),
                            ),
                            Text(
                              'ใกล้ฉัน',
                              style: selectedIndex == 3 ? _textSelected : _text,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        onItemTapped(4);
                      },
                      child: Container(
                        decoration: selectedIndex == 4
                            ? _shapeDecoration
                            : BoxDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Image.asset(
                                'assets/icon/menubar/menubar_menu.png',
                                fit: BoxFit.fitWidth,
                                width: 20,
                              ),
                            ),
                            Text(
                              'เมนูอื่น ๆ',
                              style: selectedIndex == 4 ? _textSelected : _text,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
