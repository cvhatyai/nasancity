import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nasancity/model/user.dart';
import 'package:nasancity/system/Info.dart';
import 'package:nasancity/view/home/frontpage/ServiceHomeView.dart';
import 'package:nasancity/view/home/frontpage/MarqueeView.dart';
import 'package:nasancity/view/home/frontpage/BannerView.dart';
import 'package:nasancity/view/home/frontpage/SuggustView.dart';
import 'package:nasancity/view/home/frontpage/NewsView.dart';
import 'package:nasancity/view/home/frontpage/ComplainView.dart';
import 'package:nasancity/view/home/frontpage/ComplainFollowView.dart';
import 'package:nasancity/view/home/frontpage/GalleryView.dart';
import 'package:nasancity/view/home/frontpage/TravelView.dart';
import 'package:nasancity/view/login/LoginView.dart';
import 'package:nasancity/view/setting/SettingView.dart';

import 'frontpage/FooterView.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var user = User();
  bool isLogin = false;
  var userAvatar = Info().baseUrl + "images/nopic-personal.jpg";

  void initState() {
    super.initState();
    getUsers();
  }

  getUsers() async {
    await user.init();
    setState(() {
      isLogin = user.isLogin;
      if (isLogin) {
        userAvatar = user.avatar;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: Color(0xFFc7dbf0),
          child: Column(
            children: [
              //top marquee banner
              Stack(
                children: [
                  Image.asset(
                    'assets/images/main/top_bg.png',
                  ),
                  Column(
                    children: [
                      //top
                      Container(
                        height: 80,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 3,
                              child: Image.asset(
                                'assets/images/main/logo_top.png',
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  if (!isLogin) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginView(
                                          isHaveArrow: "1",
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SettingView(
                                          isHaveArrow: "1",
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundImage: NetworkImage(userAvatar),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //marquee
                      MarqueeView(),
                      //banner
                      BannerView(),
                    ],
                  ),
                ],
              ),
              //บริการแนะนำ
              ServiceHomeView(),
              //แนะนำสำหรับคุณ
              SuggustView(),
              //นครนนท์อัพเดท
              NewsView(),
              //แจ้งเรื่องร้องทุกข์
              ComplainView(),
              //บรรเทาความเดือดร้อนล่าสุด
              ComplainFollowView(),
              //กิจกรรมห้ามพลาด
              GalleryView(),
              //เสน่ห์เมืองนนท์
              TravelView(),
              //footer
              FooterView(),
            ],
          ),
        ),
      ),
    );
  }
}
