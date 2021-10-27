import 'package:nasancity/model/user.dart';
import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/system/widht_device.dart';
import 'package:nasancity/view/home/widget/GreenMarketView.dart';
import 'package:nasancity/view/home/widget/banner.dart';
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
import 'package:nasancity/view/setting/SettingView.dart';
import 'package:flutter/material.dart';

class FrontpageScreen extends StatefulWidget {
  const FrontpageScreen({Key key}) : super(key: key);

  @override
  _FrontpageScreenState createState() => _FrontpageScreenState();
}

class _FrontpageScreenState extends State<FrontpageScreen> {
  var user = User();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
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
            width: WidhtDevice().widht(context),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/bg/bg-frontpage.png"),
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    child: Column(
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
                                        decoration: BoxDecoration(
                                          color: Color(0xFFEB1717),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20.0),
                                          ),
                                        ),
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
                                                      fontFamily:
                                                          FontStyles.FontFamily,
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      height: 1,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    'สุราษฎร์ธานี',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontStyles.FontFamily,
                                                      color: Colors.white,
                                                      fontSize: 16,
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
                                    Expanded(
                                      flex: 2,
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
                                              flex: 2,
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
                                                      child: Icon(
                                                        Icons
                                                            .notifications_none_outlined,
                                                        size: 30,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    GestureDetector(
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
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 270,
                    margin: EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: Color(0xFF0075CC),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(13),
                          height: 70,
                          decoration: BoxDecoration(
                            color: Color(0xFFEB1717),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                            ),
                          ),
                          child: Text(
                            'วิทยุออนไลน์',
                            style: TextStyle(
                              fontFamily: FontStyles.FontFamily,
                              fontSize: 21,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          top: 40,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(10),
                              child: FacebookLiveWidget(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Stack(
                      children: [
                        Container(
                          height: 270,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.only(top: 10, left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ร้องเรียน',
                                        style: TextStyle(
                                            fontFamily: FontStyles.FontFamily,
                                            color: Color(0xFFEB1717),
                                            fontSize: 20),
                                      ),
                                      Text(
                                        '    ร้องทุกข์',
                                        style: TextStyle(
                                            fontFamily: FontStyles.FontFamily,
                                            color: Color(0xFF0075CC),
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFEB1717),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Image.asset(
                            'assets/bg/bg-woman.png',
                            height: 210,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 5,
                              top: 5,
                              bottom: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '  ติดตามเรื่องร้องเรียน  ',
                                  style: TextStyle(
                                    fontFamily: FontStyles.FontFamily,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFFEB1717),
                                  size: 16,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BannerWidget(),
                  NewsWidget(),
                  Container(
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 270),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withOpacity(0),
                                Color(0xFF40B103),
                              ],
                              stops: [
                                0.5,
                                0,
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              ComplaintWidget(),
                              Container(
                                decoration: BoxDecoration(),
                                child: UpdateWidget(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GalleryWidget(),
                  ComplainFollowWidget(),
                  GreenMarketView(),
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
