import 'dart:ui';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nasancity/model/user.dart';
import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/system/widht_device.dart';
import 'package:nasancity/view/complain/FollowComplainListView.dart';
import 'package:nasancity/view/download/DownloadListView.dart';
import 'package:nasancity/view/home/widget/GreenMarketView.dart';
import 'package:nasancity/view/home/widget/banner.dart';
import 'package:nasancity/view/home/widget/block_complain.dart';
import 'package:nasancity/view/home/widget/block_facebook.dart';
import 'package:nasancity/view/home/widget/complainFollow.dart';
import 'package:nasancity/view/home/widget/complaint.dart';
import 'package:nasancity/view/home/widget/facebookLive.dart';
import 'package:nasancity/view/home/widget/footer.dart';
import 'package:nasancity/view/home/widget/gallery.dart';
import 'package:nasancity/view/home/widget/massage.dart';
import 'package:nasancity/view/home/widget/newsUpdate.dart';
import 'package:nasancity/view/home/widget/recommend.dart';
import 'package:nasancity/view/home/widget/travel.dart';
import 'package:nasancity/view/home/widget/update.dart';
import 'package:nasancity/view/home/widget/weather.dart';
import 'package:nasancity/view/login/LoginView.dart';
import 'package:nasancity/view/noti/NotiListView.dart';
import 'package:nasancity/view/phone/PhoneCateListView.dart';
import 'package:nasancity/view/setting/SettingView.dart';
import 'package:flutter/material.dart';
import 'package:nasancity/view/travel/TravelListView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FrontpageScreen extends StatefulWidget {
  const FrontpageScreen({Key key}) : super(key: key);

  @override
  _FrontpageScreenState createState() => _FrontpageScreenState();
}

class _FrontpageScreenState extends State<FrontpageScreen> {
  var user = User();
  var favCount = 0;
  List<String> arrFav = [];
  bool isLogin = false;
  getUsers() async {
    await user.init();
    setState(() {
      isLogin = user.isLogin;
      if (isLogin) {
        String userFullname = user.fullname;
        String userAvatar = user.avatar;
        print("userAvataruserAvatar" + userAvatar);
      }
    });
  }

  initFav() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    arrFav = prefs.getStringList("favList");
    setState(() {
      if (arrFav != null) {
        favCount = arrFav.length;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    print("ขนาดจอ " + MediaQuery.of(context).size.width.toString());
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xFFEB1717),
        ),
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: WidhtDevice().widht(context) >= 768 ? 600 : 450,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/bg/bg-frontpage.png"),
                        alignment: WidhtDevice().widht(context) >= 768
                            ? Alignment.bottomCenter
                            : Alignment.topCenter,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 5),
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Color(0xFF0075CC).withOpacity(0.8),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: EdgeInsets.only(left: 5),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFEB1717),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20.0),
                                          ),
                                        ),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Image.asset(
                                                  'assets/logo/logo-1.png',
                                                  fit: BoxFit.contain,
                                                  width: 45,
                                                ),
                                              ),
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'ทม.นาสาร',
                                                      style: TextStyle(
                                                        fontFamily: FontStyles
                                                            .FontFamily,
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        height: 1,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      'สุราษฎร์ธานี',
                                                      style: TextStyle(
                                                        fontFamily: FontStyles
                                                            .FontFamily,
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        height: 1,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: WidhtDevice().widht(context) >= 768
                                          ? 5
                                          : 2,
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(left: 5, top: 3),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20.0),
                                            bottomLeft: Radius.circular(20.0),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex:
                                                  WidhtDevice().size(context) ==
                                                          "m"
                                                      ? 5
                                                      : 2,
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        'อากาศนาสารวันนี้',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontFamily:
                                                                FontStyles
                                                                    .FontFamily,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ),
                                                    WeatherWidget(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (!isLogin) {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      LoginView(
                                                                isHaveArrow:
                                                                    "1",
                                                              ),
                                                            ),
                                                          );
                                                        } else {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  NotiListView(
                                                                isHaveArrow:
                                                                    "1",
                                                              ),
                                                            ),
                                                          ).then((value) {
                                                            getUsers();
                                                          });
                                                        }
                                                      },
                                                      child: Icon(
                                                        Icons
                                                            .notifications_none_outlined,
                                                        size: 30,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (!isLogin) {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      LoginView(
                                                                isHaveArrow:
                                                                    "1",
                                                              ),
                                                            ),
                                                          );
                                                        } else {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      SettingView(
                                                                isHaveArrow:
                                                                    "1",
                                                              ),
                                                            ),
                                                          ).then((value) {
                                                            getUsers();
                                                          });
                                                        }
                                                      },
                                                      child: Icon(
                                                        Icons.person_sharp,
                                                        size: 30,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Container(
                                width: WidhtDevice().widht(context) >= 768
                                    ? MediaQuery.of(context).size.width / 1.5
                                    : MediaQuery.of(context).size.width,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 5, right: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF0075CC).withOpacity(0.8),
                                    image: DecorationImage(
                                      alignment: Alignment(0.95, -0.9),
                                      scale: 3,
                                      image: AssetImage(
                                        'assets/bg/bg-massage.png',
                                      ),
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15.0),
                                      topLeft: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0),
                                      bottomLeft: Radius.circular(15.0),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFEB1717),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(15.0),
                                                    topLeft:
                                                        Radius.circular(15.0),
                                                  ),
                                                ),
                                                child: Image.asset(
                                                    'assets/item/megaphone.png'),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 6,
                                              child: Container(
                                                decoration: BoxDecoration(),
                                                child: MassageWidget(),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(15.0),
                                            topRight: Radius.circular(15.0),
                                            bottomLeft: Radius.circular(15.0),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment
                                                .bottomCenter, // 10% of the width, so there are ten blinds.
                                            colors: <Color>[
                                              Color(0xffEB1717),
                                              Color(0xffB10000)
                                            ], // red to yellow
                                            tileMode: TileMode
                                                .repeated, // repeats the gradient over the canvas
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'E-Service',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        FontStyles.FontFamily,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                  bottom: 5,
                                                  top: 5,
                                                ),
                                                child: Center(
                                                  child: ListView(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DownloadListView(
                                                                isHaveArrow:
                                                                    "1",
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: 100,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            10),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  // borderRadius: BorderRadius.circular(20),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Color(
                                                                      0xFFFFFFFF),
                                                                  border: Border
                                                                      .all(
                                                                    width: 3,
                                                                    color: Color(
                                                                        0xFFDADADA),
                                                                  ),
                                                                ),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/item/eservice-1.png',
                                                                  width: 50,
                                                                  height: 50,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                ),
                                                              ),
                                                              Text(
                                                                'เอกสาร',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        FontStyles
                                                                            .FontFamily,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    height: 1),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PhoneCateListView(
                                                                isHaveArrow:
                                                                    "1",
                                                              ),
                                                            ),
                                                          ).then((value) {
                                                            setState(() {
                                                              initFav();
                                                            });
                                                          });
                                                        },
                                                        child: Container(
                                                          width: 100,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            10),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  // borderRadius: BorderRadius.circular(20),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Color(
                                                                      0xFFFFFFFF),
                                                                  border: Border
                                                                      .all(
                                                                    width: 3,
                                                                    color: Color(
                                                                        0xFFDADADA),
                                                                  ),
                                                                ),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/item/eservice-2.png',
                                                                  width: 50,
                                                                  height: 50,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                ),
                                                              ),
                                                              Text(
                                                                'เบอร์โทรสำคัญ ',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        FontStyles
                                                                            .FontFamily,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    height: 1),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  TravelListView(
                                                                isHaveArrow:
                                                                    "1",
                                                                title:
                                                                    "ที่เที่ยว",
                                                                tid: "1",
                                                              ),
                                                            ),
                                                          ).then((value) {
                                                            setState(() {
                                                              initFav();
                                                            });
                                                          });
                                                        },
                                                        child: Container(
                                                          width: 100,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            10),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  // borderRadius: BorderRadius.circular(20),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Color(
                                                                      0xFFFFFFFF),
                                                                  border: Border
                                                                      .all(
                                                                    width: 3,
                                                                    color: Color(
                                                                        0xFFDADADA),
                                                                  ),
                                                                ),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/item/eservice-4.png',
                                                                  width: 50,
                                                                  height: 50,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                ),
                                                              ),
                                                              Text(
                                                                'ที่เที่ยวแนะนำ',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        FontStyles
                                                                            .FontFamily,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    height: 1),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        child: Container(
                                                          width: 100,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            10),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  // borderRadius: BorderRadius.circular(20),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Color(
                                                                      0xFFFFFFFF),
                                                                  border: Border
                                                                      .all(
                                                                    width: 3,
                                                                    color: Color(
                                                                        0xFFDADADA),
                                                                  ),
                                                                ),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/item/eservice-3.png',
                                                                  width: 50,
                                                                  height: 50,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                ),
                                                              ),
                                                              Text(
                                                                'เบี้ยยังชีพ',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        FontStyles
                                                                            .FontFamily,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    height: 1),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  MediaQuery.of(context).size.width > 768
                      ? Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Facebook_block(),
                              BlockComplaint(),
                            ],
                          ),
                        )
                      : Container(
                          child: Column(
                            children: [
                              Facebook_block(),
                              SizedBox(
                                height: 30,
                              ),
                              BlockComplaint(),
                            ],
                          ),
                        ),
                  BannerWidget(),
                  NewsWidget(),
                  GalleryWidget(),
                  GreenMarketView(),
                  // ComplainFollowWidget(),
                  TravelWidget(),
                  FooterWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
