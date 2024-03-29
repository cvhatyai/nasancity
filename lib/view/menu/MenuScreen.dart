import 'dart:async';
import 'dart:convert';

import 'package:nasancity/model/user.dart';
import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/system/Info.dart';
import 'package:nasancity/system/widht_device.dart';
import 'package:nasancity/view/FrontPageView.dart';
import 'package:nasancity/view/calendar/CalendarListView.dart';
import 'package:nasancity/view/complain/ComplainCateListView.dart';
import 'package:nasancity/view/complain/FollowComplainListView.dart';
import 'package:nasancity/view/contactdev/ContactDevView.dart';
import 'package:nasancity/view/contactus/ContactusView.dart';
import 'package:nasancity/view/contactus/FollowContactusListView.dart';
import 'package:nasancity/view/download/DownloadListView.dart';
import 'package:nasancity/view/ebook/EbookListView.dart';
import 'package:nasancity/view/faq/FaqWebView.dart';
import 'package:nasancity/view/favorite/FavoriteView.dart';
import 'package:nasancity/view/gallery/GalleryListView.dart';
import 'package:nasancity/view/general/GeneralView.dart';
import 'package:nasancity/view/greenmarket/GreenMarketListView.dart';
import 'package:nasancity/view/law/LawListView.dart';
import 'package:nasancity/view/login/LoginView.dart';
import 'package:nasancity/view/menu/menuStyles.dart';
import 'package:nasancity/view/news/NewsListView.dart';
import 'package:nasancity/view/news/NewsStyleListView.dart';
import 'package:nasancity/view/phone/PhoneCateListView.dart';
import 'package:nasancity/view/policy/PolicyContentView.dart';
import 'package:nasancity/view/poll/PollView.dart';
import 'package:nasancity/view/serviceGuide/ServiceGuideListView.dart';
import 'package:nasancity/view/setting/SettingView.dart';
import 'package:nasancity/view/travel/TravelListView.dart';
import 'package:nasancity/view/video/VideoListView.dart';
import 'package:nasancity/view/webpageview/WebPageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nasancity/model/AllList.dart';
// import 'package:nasancity/model/user.dart';
// import 'package:nasancity/system/Info.dart';
// import 'package:nasancity/view/calendar/CalendarListView.dart';
// import 'package:nasancity/view/chat/ChatView.dart';
// import 'package:nasancity/view/complain/ComplainCateListView.dart';
// import 'package:nasancity/view/complain/FollowComplainListView.dart';
// import 'package:nasancity/view/contactdev/ContactDevView.dart';
// import 'package:nasancity/view/contactus/ContactusView.dart';
// import 'package:nasancity/view/contactus/FollowContactusListView.dart';
// import 'package:nasancity/view/download/DownloadListView.dart';
// import 'package:nasancity/view/law/LawListView.dart';
// import 'package:nasancity/view/ebook/EbookListView.dart';
// import 'package:nasancity/view/gallery/GalleryListView.dart';
// import 'package:nasancity/view/general/GeneralView.dart';
// import 'package:nasancity/view/login/LoginView.dart';
// import 'package:nasancity/view/news/NewsListView.dart';
// import 'package:nasancity/view/news/NewsStyleListView.dart';
// import 'package:nasancity/view/faq/FaqWebView.dart';
// import 'package:nasancity/view/phone/PhoneCateListView.dart';
// import 'package:nasancity/view/phone/PhoneListView.dart';
// import 'package:nasancity/view/poll/PollView.dart';
// import 'package:nasancity/view/serviceGuide/ServiceGuideListView.dart';
// import 'package:nasancity/view/travel/TravelListView.dart';
// import 'package:nasancity/view/video/VideoListView.dart';
// import 'package:nasancity/view/setting/SettingView.dart';
// import 'package:nasancity/view/favorite/FavoriteView.dart';
// import 'package:nasancity/view/webpageview/WebPageView.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

// import '../FrontPageView.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var userFullname = "เข้าสู่ระบบ";
  var userClass = "เข้าสู่ระบบ";
  var uid = "";
  var userAvatar = Info().baseUrl + "images/nopic-personal.jpg";

  var guideLink = "";
  var favCount = 0;
  List<String> arrFav = [];

  /*PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );*/

  var user = User();
  bool isLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.show(status: 'loading...');
    getSiteDetail();
    getUsers();
    initFav();
    Timer(Duration(seconds: 1), () => EasyLoading.dismiss());
    // _initPackageInfo();
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

  /*Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }*/

  // siteGuide
  getSiteDetail() async {
    Map _map = {};
    _map.addAll({});
    var body = json.encode(_map);
    return postSiteDetail(http.Client(), body, _map);
  }

  Future<List<AllList>> postSiteDetail(
      http.Client client, jsonMap, Map map) async {
    final response = await client.post(Uri.parse(Info().siteDetail),
        headers: {"Content-Type": "application/json"}, body: jsonMap);
    var rs = json.decode(response.body);
    setState(() {
      guideLink = rs["guide_link"].toString();
    });
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  getUsers() async {
    await user.init();
    setState(() {
      isLogin = user.isLogin;
      if (isLogin) {
        userFullname = user.fullname;
        userAvatar = user.avatar;
        print("userAvataruserAvatar" + userAvatar);
      }
    });
  }

  Future<void> logout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ยืนยันการออกจากระบบ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ยืนยัน'),
              onPressed: () {
                user.logout();
                //clearPref();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => FrontPageView()),
                  ModalRoute.withName("/"),
                );
                Toast.show("ออกจากระบบแล้ว", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                //Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  clearPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  clearPoll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("isVoted");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: WidhtDevice().widht(context),
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: ListView(
              children: [
                //topmenu
                Container(
                  child: Stack(
                    children: [
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Color(0xFF6D8495),
                          image: DecorationImage(
                            image: AssetImage("assets/bg/bg-menu.png"),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            color: Colors.transparent,
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 16),
                                  padding: EdgeInsets.only(right: 16),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (guideLink != "") {
                                            _launchInBrowser(guideLink);
                                          } else {
                                            Toast.show("ไม่มีข้อมูล", context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.BOTTOM);
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(18),
                                              topRight: Radius.circular(18),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                "คู่มือสำหรับผู้ใช้งาน",
                                                style: TextStyle(
                                                  color: Color(0xFF5B5B5F),
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.blueAccent,
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FrontPageView()),
                                                  ModalRoute.withName("/"),
                                                );
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    right: 4, left: 4),
                                                child: Icon(
                                                  Icons.home,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (!isLogin) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginView(
                                                        isHaveArrow: "1",
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SettingView(
                                                        isHaveArrow: "1",
                                                      ),
                                                    ),
                                                  ).then((value) {
                                                    getUsers();
                                                  });
                                                }
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    right: 4, left: 4),
                                                child: Icon(
                                                  Icons.settings,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (!isLogin) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginView(
                                                        isHaveArrow: "1",
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FavoriteView(
                                                        isHaveArrow: "1",
                                                      ),
                                                    ),
                                                  ).then((value) {
                                                    setState(() {
                                                      initFav();
                                                    });
                                                  });
                                                }
                                              },
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 4, left: 4),
                                                    child: Icon(
                                                      Icons.bookmark_sharp,
                                                      color: Colors.white,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  if (favCount != 0)
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.red,
                                                        ),
                                                        child: Text(
                                                          favCount.toString(),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.only(top: 16),
                                  child: Row(
                                    children: [
                                      Container(
                                        child: CircleAvatar(
                                          radius: 24.0,
                                          backgroundImage:
                                              NetworkImage(userAvatar),
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (!isLogin) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginView(
                                                        isHaveArrow: "1",
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(left: 8),
                                                child: Text(
                                                  userFullname,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 22),
                                                ),
                                              ),
                                            ),
                                            if (isLogin)
                                              Container(
                                                padding:
                                                    EdgeInsets.only(left: 8),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    logout();
                                                  },
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "ออกจากระบบ",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 2),
                                                        child: Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.white,
                                                          size: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //top menu2
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 32),
                            // padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFFEB1717),
                              borderRadius: BorderRadius.circular(9),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "ติดต่อ/แจ้งเรื่องร้องเรียน",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: FontStyles.FontFamily,
                                      color: Colors.white,
                                    ),
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (!isLogin) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginView(
                                                    isHaveArrow: "1",
                                                  ),
                                                ),
                                              );
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ComplainCateListView(
                                                    isHaveArrow: "1",
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.all(2)),
                                              Image.asset(
                                                'assets/item/menu/m-1.png',
                                                height: 25,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(2)),
                                              Text(
                                                "แจ้งเรื่อง\nร้องเรียน",
                                                textAlign: TextAlign.center,
                                                style: MenuStyle().txtcontact,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(2)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        color: Color(0xFFE3E3E3),
                                        height: 40,
                                        width: 1,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (!isLogin) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginView(
                                                    isHaveArrow: "1",
                                                  ),
                                                ),
                                              );
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FollowComplainListView(
                                                    isHaveArrow: "1",
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.all(2)),
                                              Image.asset(
                                                'assets/item/menu/m-5.png',
                                                height: 25,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(2)),
                                              Text(
                                                "ติดตามเรื่อง\nร้องเรียน",
                                                textAlign: TextAlign.center,
                                                style: MenuStyle().txtcontact,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(2)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        color: Color(0xFFE3E3E3),
                                        height: 40,
                                        width: 1,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (!isLogin) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginView(
                                                    isHaveArrow: "1",
                                                  ),
                                                ),
                                              );
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ContactusView(
                                                    isHaveArrow: "1",
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.all(2)),
                                              Image.asset(
                                                'assets/item/menu/m-2.png',
                                                height: 25,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(2)),
                                              Text(
                                                "ติดต่อ\nเจ้าหน้าที่",
                                                textAlign: TextAlign.center,
                                                style: MenuStyle().txtcontact,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(2)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        color: Color(0xFFE3E3E3),
                                        height: 40,
                                        width: 1,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (!isLogin) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginView(
                                                    isHaveArrow: "1",
                                                  ),
                                                ),
                                              );
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FollowContactusListView(
                                                    isHaveArrow: "1",
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.all(2)),
                                              Image.asset(
                                                'assets/item/menu/m-4.png',
                                                height: 25,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(2)),
                                              Text(
                                                "ติดตามเรื่อง\nที่ติดต่อ",
                                                textAlign: TextAlign.center,
                                                style: MenuStyle().txtcontact,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(2)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      //top menu
                    ],
                  ),
                ),

                //title menu 1
                // if (user.userclass != "superadmin" && user.userclass != "admin")
                // Container(
                //   padding: EdgeInsets.only(left: 16, right: 16),
                //   alignment: Alignment.centerLeft,
                //   decoration: MenuStyle().themeTopic,
                //   height: 40,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         "ชำระภาษี/ค่าบริการ",
                //         style: MenuStyle().txttopic,
                //       ),
                //       Icon(Icons.keyboard_arrow_down,color: Colors.white),
                //     ],
                //   ),
                // ),
                //sub menu 1
                // if (user.userclass != "superadmin" && user.userclass != "admin")
                // GestureDetector(
                //   onTap: () {
                //     if (isLogin) {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => WebPageView(
                //             isHaveArrow: "1",
                //             title: "ชำระภาษี",
                //             cmd: "tax",
                //           ),
                //         ),
                //       );
                //     } else {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => LoginView(
                //             isHaveArrow: "1",
                //           ),
                //         ),
                //       );
                //     }
                //   },
                //   child: Column(
                //     children: [
                //       Container(
                //         padding: EdgeInsets.only(left: 32),
                //         alignment: Alignment.centerLeft,
                //         color: Colors.transparent,
                //         height: 40,
                //         child: Row(
                //           children: [
                //             /*Image.asset(
                //             'assets/images/menu1.png',
                //             height: 22,
                //             width: 22,
                //           ),*/
                //             Image.asset(
                //               'assets/item/menu/payment.png',
                //               height: 18,
                //               width: 18,
                //             ),
                //             Container(
                //               margin: EdgeInsets.only(left: 16),
                //               child: Text(
                //                 "ชำระภาษี",
                //                 style: TextStyle(
                //                   fontSize: 15,
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       Divider(height: 1, indent: 8, endIndent: 8),
                //     ],
                //   ),
                // ),
                // if (user.userclass != "superadmin" && user.userclass != "admin")
                // GestureDetector(
                //   onTap: () {
                //     if (isLogin) {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => WebPageView(
                //             isHaveArrow: "1",
                //             title: "ชำระค่าขยะ",
                //             cmd: "garbage",
                //           ),
                //         ),
                //       );
                //     } else {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => LoginView(
                //             isHaveArrow: "1",
                //           ),
                //         ),
                //       );
                //     }
                //   },
                //   child: Column(
                //     children: [
                //       Container(
                //         padding: EdgeInsets.only(left: 32),
                //         alignment: Alignment.centerLeft,
                //         color: Colors.transparent,
                //         height: 40,
                //         child: Row(
                //           children: [
                //             /*Image.asset(
                //               'assets/images/menu1.png',
                //               height: 22,
                //               width: 22,
                //             ),*/
                //             Image.asset(
                //               'assets/item/menu/m3.png',
                //               height: 18,
                //               width: 18,
                //             ),
                //             Container(
                //               margin: EdgeInsets.only(left: 16),
                //               child: Text(
                //                 "ชำระค่าขยะ",
                //                 style: TextStyle(
                //                   fontSize: 15,
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       Divider(height: 1, indent: 8, endIndent: 8),
                //     ],
                //   ),
                // ),

                //title menu 2
                // if (user.userclass != "superadmin" && user.userclass != "admin")
                //   Container(
                //     padding: EdgeInsets.only(left: 16, right: 16),
                //     alignment: Alignment.centerLeft,
                //     decoration: MenuStyle().themeTopic,
                //     height: 40,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Text(
                //           "สวัสดิการ/เบี้ยยังชีพ",
                //           style: MenuStyle().txttopic,
                //         ),
                //         Icon(Icons.keyboard_arrow_down, color: Colors.white),
                //       ],
                //     ),
                //   ),
                //sub menu 2
                // if (user.userclass != "superadmin" && user.userclass != "admin")
                // GestureDetector(
                //   onTap: () {
                //     _launchInBrowser(
                //         "http://nasancity.go.th/public/allowance/data/index/menu/646");
                // if (isLogin) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => WebPageView(
                //         isHaveArrow: "1",
                //         title: "เบี้ยยังชีพผู้สูงอายุ",
                //         cmd:
                //             "http://nasancity.go.th/public/allowance/data/index/menu/646",
                //       ),
                //     ),
                //   );
                // } else {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => LoginView(
                //         isHaveArrow: "1",
                //       ),
                //     ),
                //   );
                // }
                //   },
                //   child: Column(
                //     children: [
                //       Container(
                //         padding: EdgeInsets.only(left: 32),
                //         alignment: Alignment.centerLeft,
                //         color: Colors.transparent,
                //         height: 40,
                //         child: Row(
                //           children: [
                //             /*Image.asset(
                //               'assets/images/menu1.png',
                //               height: 22,
                //               width: 22,
                //             ),*/
                //             Image.asset(
                //               'assets/item/menu/m4.png',
                //               height: 18,
                //               width: 18,
                //             ),
                //             Container(
                //               margin: EdgeInsets.only(left: 16),
                //               child: Text(
                //                 "เบี้ยยังชีพผู้สูงอายุ",
                //                 style: TextStyle(
                //                   fontSize: 15,
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       Divider(height: 1, indent: 8, endIndent: 8),
                //     ],
                //   ),
                // ),
                // if (user.userclass != "superadmin" && user.userclass != "admin")
                //   GestureDetector(
                //     onTap: () {
                //       _launchInBrowser(
                //           "http://nasancity.go.th/public/cripple/data/index/menu/647");
                //       // if (isLogin) {
                //       //   Navigator.push(
                //       //     context,
                //       //     MaterialPageRoute(
                //       //       builder: (context) => WebPageView(
                //       //         isHaveArrow: "1",
                //       //         title: "เบี้ยยังชีพผู้พิการ",
                //       //         cmd: "disabled",
                //       //       ),
                //       //     ),
                //       //   );
                //       // } else {
                //       //   Navigator.push(
                //       //     context,
                //       //     MaterialPageRoute(
                //       //       builder: (context) => LoginView(
                //       //         isHaveArrow: "1",
                //       //       ),
                //       //     ),
                //       //   );
                //       // }
                //     },
                //     child: Column(
                //       children: [
                //         Container(
                //           padding: EdgeInsets.only(left: 32),
                //           alignment: Alignment.centerLeft,
                //           color: Colors.transparent,
                //           height: 40,
                //           child: Row(
                //             children: [
                //               /*Image.asset(
                //               'assets/images/menu1.png',
                //               height: 22,
                //               width: 22,
                //             ),*/
                //               Image.asset(
                //                 'assets/item/menu/m5.png',
                //                 height: 18,
                //                 width: 18,
                //               ),
                //               Container(
                //                 margin: EdgeInsets.only(left: 16),
                //                 child: Text(
                //                   "เบี้ยยังชีพผู้พิการ",
                //                   style: TextStyle(
                //                     fontSize: 15,
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //         Divider(height: 1, indent: 8, endIndent: 8),
                //       ],
                //     ),
                //   ),

                //title menu 3
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  alignment: Alignment.centerLeft,
                  decoration: MenuStyle().themeTopic,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ข้อมูลเกี่ยวกับเทศบาล",
                        style: MenuStyle().txttopic,
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    ],
                  ),
                ),
                //sub menu 3
                GestureDetector(
                  onTap: () {
                    _launchInBrowser(
                        "https://www.nasancity.go.th/content/general");

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => GeneralView(
                    //       isHaveArrow: "1",
                    //     ),
                    //   ),
                    // );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/m13.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "ข้อมูลทั่วไปของเทศบาล",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicyContentView(isHaveArrow: "1",),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/m13.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "นโยบายความเป็นส่วนตัว",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _launchInBrowser(
                        "https://www.nasancity.go.th/content/history");

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => GeneralView(
                    //       isHaveArrow: "1",
                    //     ),
                    //   ),
                    // );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/m13.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "ประวัติความเป็นมา",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _launchInBrowser(
                        "https://www.nasancity.go.th/content/cate/8");

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => GeneralView(
                    //       isHaveArrow: "1",
                    //     ),
                    //   ),
                    // );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/m13.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "บทบาทหน้าที่",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _launchInBrowser(
                        "https://www.nasancity.go.th/content/vision");

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => GeneralView(
                    //       isHaveArrow: "1",
                    //     ),
                    //   ),
                    // );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/m13.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "วิสัยทัศน์/พันธกิจ",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _launchInBrowser(
                        "https://www.nasancity.go.th/content/cate/4");

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => GeneralView(
                    //       isHaveArrow: "1",
                    //     ),
                    //   ),
                    // );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/m13.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "นโยบาย",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _launchInBrowser("https://nasancity.go.th/news_tran");

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => GeneralView(
                    //       isHaveArrow: "1",
                    //     ),
                    //   ),
                    // );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/m13.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "ประกาศนโยบายคุณธรรมและความโปร่งใส",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                /*GestureDetector(
                  onTap: () {
                    _launchInBrowser(
                        "https://www.nasancity.go.th/contactus/location");

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => GeneralView(
                    //       isHaveArrow: "1",
                    //     ),
                    //   ),
                    // );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            *//*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*//*
                            Image.asset(
                              'assets/item/menu/m13.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "สำนักงาน",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),*/

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsListView(
                          isHaveArrow: "1",
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/m14.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "นาสารอัพเดท",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),

                //new
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsStyleListView(
                          isHaveArrow: "1",
                          cid: "3",
                          title: "ประกาศจัดซื้อจัดจ้าง",
                          isHasCate: true,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/tick.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "ประกาศจัดซื้อจัดจ้าง",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LawListView(
                          isHaveArrow: "1",
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/surface.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "ระเบียบข้อกฏหมาย/ข้อบัญญัติ",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsStyleListView(
                          isHaveArrow: "1",
                          cid: "4",
                          title: "ข่าวสมัครงาน",
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/portfolio.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "ข่าวสมัครงาน",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryListView(
                          isHaveArrow: "1",
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/m15.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "ภาพกิจกรรม",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalendarListView(
                          isHaveArrow: "1",
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/m16.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "กิจกรรมห้ามพลาด",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoListView(
                          isHaveArrow: "1",
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/m17.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "วิดีโอกิจกรรม",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceGuideListView(
                          isHaveArrow: "1",
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/m18.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "บริการของเทศบาล",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DownloadListView(
                          isHaveArrow: "1",
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/m19.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "เอกสาร/แบบฟอร์ม",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EbookListView(
                          isHaveArrow: "1",
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/open-book.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "วารสาร",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhoneCateListView(
                          isHaveArrow: "1",
                        ),
                      ),
                    ).then((value) {
                      setState(() {
                        initFav();
                      });
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/m20.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "เบอร์โทรสำคัญ",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // _launchInBrowser(
                    //     "https://docs.google.com/forms/d/e/1FAIpQLScbrsfcCcNp8A8fas63H6m12Plzejpp6LUaUlm8g6rI7WHZNQ/viewform");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PollView(
                          isHaveArrow: "1",
                        ),
                      ),
                    ).then((value) {
                      setState(() {
                        initFav();
                      });
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/review_1.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "ประเมินความพึงพอใจ",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),

                //title menu 4
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  alignment: Alignment.centerLeft,
                  decoration: MenuStyle().themeTopic,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ข้อมูลท่องเที่ยว",
                        style: MenuStyle().txttopic,
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    ],
                  ),
                ),
                //sub menu 4
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TravelListView(
                          isHaveArrow: "1",
                          title: "ที่เที่ยว",
                          tid: "1",
                        ),
                      ),
                    ).then((value) {
                      setState(() {
                        initFav();
                      });
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/traveler-with-a-suitcase.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "ที่เที่ยว",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TravelListView(
                          isHaveArrow: "1",
                          title: "ที่กิน",
                          tid: "3",
                        ),
                      ),
                    ).then((value) {
                      setState(() {
                        initFav();
                      });
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/m-3.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "ที่กิน",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TravelListView(
                          isHaveArrow: "1",
                          title: "ที่พัก",
                          tid: "2",
                        ),
                      ),
                    ).then((value) {
                      setState(() {
                        initFav();
                      });
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/hotel.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "ที่พัก",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TravelListView(
                          isHaveArrow: "1",
                          title: "OTOP",
                          tid: "4",
                        ),
                      ),
                    ).then((value) {
                      setState(() {
                        initFav();
                      });
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/shopping-bag.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "OTOP",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
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
                          builder: (context) => GreenMarketListView(
                            isHaveArrow: "1",
                          ),
                        ),
                      );
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/market.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "ตลาดสีเขียว",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                //title menu 5
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  alignment: Alignment.centerLeft,
                  decoration: MenuStyle().themeTopic,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ติดต่อ",
                        style: MenuStyle().txttopic,
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    ],
                  ),
                ),
                //sub menu 5
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FaqWebView(
                          isHaveArrow: "1",
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/faq.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "FAQ ถาม-ตอบ",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
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
                          builder: (context) => ContactusView(
                            isHaveArrow: "1",
                          ),
                        ),
                      );
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/Page-1.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "ติดต่อเทศบาล",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactDevView(
                          isHaveArrow: "1",
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 32),
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        height: 40,
                        child: Row(
                          children: [
                            /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                            Image.asset(
                              'assets/item/menu/m30.png',
                              height: 18,
                              width: 18,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text(
                                "แจ้งปัญหา/ติดต่อผู้พัฒนา",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, indent: 8, endIndent: 8),
                    ],
                  ),
                ),

                //title menu 6
                if (user.userclass == "superadmin" || user.userclass == "admin")
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    alignment: Alignment.centerLeft,
                    decoration: MenuStyle().themeTopic,
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "สำหรับเจ้าหน้าที่",
                          style: MenuStyle().txttopic,
                        ),
                        Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      ],
                    ),
                  ),
                //sub menu 6
                if (user.userclass == "superadmin" || user.userclass == "admin")
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FollowComplainListView(
                            isHaveArrow: "1",
                            title: "ตรวจสอบเรื่องร้องเรียน",
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 32),
                          alignment: Alignment.centerLeft,
                          color: Colors.transparent,
                          height: 40,
                          child: Row(
                            children: [
                              /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                              Image.asset(
                                'assets/item/menu/m21.png',
                                height: 18,
                                width: 18,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 16),
                                child: Text(
                                  "ตรวจสอบเรื่องร้องเรียน",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1, indent: 8, endIndent: 8),
                      ],
                    ),
                  ),
                if (user.userclass == "superadmin" || user.userclass == "admin")
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebPageView(
                            isHaveArrow: "1",
                            title: "แผนที่แสดงจุดเรื่องร้องเรียน",
                            cmd: "map_complain",
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 32),
                          alignment: Alignment.centerLeft,
                          color: Colors.transparent,
                          height: 40,
                          child: Row(
                            children: [
                              /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                              Image.asset(
                                'assets/item/menu/m22.png',
                                height: 18,
                                width: 18,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 16),
                                child: Text(
                                  "แผนที่แสดงจุดเรื่องร้องเรียน",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1, indent: 8, endIndent: 8),
                      ],
                    ),
                  ),
                if (user.userclass == "superadmin" || user.userclass == "admin")
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebPageView(
                            isHaveArrow: "1",
                            title: "กราฟสรุปผลเรื่องร้องเรียน",
                            cmd: "graph_complain",
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 32),
                          alignment: Alignment.centerLeft,
                          color: Colors.transparent,
                          height: 40,
                          child: Row(
                            children: [
                              /*Image.asset(
                              'assets/images/menu1.png',
                              height: 22,
                              width: 22,
                            ),*/
                              Image.asset(
                                'assets/item/menu/m23.png',
                                height: 18,
                                width: 18,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 16),
                                child: Text(
                                  "กราฟสรุปผลเรื่องร้องเรียน",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1, indent: 8, endIndent: 8),
                      ],
                    ),
                  ),
                // if (user.userclass == "superadmin" || user.userclass == "admin")
                // GestureDetector(
                //   onTap: () {
                //     // Navigator.push(
                //     //   context,
                //     //   MaterialPageRoute(
                //     //     builder: (context) => WebPageView(
                //     //       isHaveArrow: "1",
                //     //       title: "รายการภาษี",
                //     //       cmd: "tax_admin",
                //     //     ),
                //     //   ),
                //     // );
                //   },
                //   child: Column(
                //     children: [
                //       Container(
                //         padding: EdgeInsets.only(left: 32),
                //         alignment: Alignment.centerLeft,
                //         color: Colors.transparent,
                //         height: 40,
                //         child: Row(
                //           children: [
                //             /*Image.asset(
                //               'assets/images/menu1.png',
                //               height: 22,
                //               width: 22,
                //             ),*/
                //             Image.asset(
                //               'assets/images/menu/m24.png',
                //               height: 18,
                //               width: 18,
                //             ),
                //             Container(
                //               margin: EdgeInsets.only(left: 16),
                //               child: Text(
                //                 "รายการภาษี",
                //                 style: TextStyle(
                //                   fontSize: 15,
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       Divider(height: 1, indent: 8, endIndent: 8),
                //     ],
                //   ),
                // ),
                // // if (user.userclass == "superadmin" || user.userclass == "admin")
                // GestureDetector(
                //   onTap: () {
                //     // Navigator.push(
                //     //   context,
                //     //   MaterialPageRoute(
                //     //     builder: (context) => WebPageView(
                //     //       isHaveArrow: "1",
                //     //       title: "รายการค่าขยะ",
                //     //       cmd: "garbage_admin",
                //     //     ),
                //     //   ),
                //     // );
                //   },
                //   child: Column(
                //     children: [
                //       Container(
                //         padding: EdgeInsets.only(left: 32),
                //         alignment: Alignment.centerLeft,
                //         color: Colors.transparent,
                //         height: 40,
                //         child: Row(
                //           children: [
                //             /*Image.asset(
                //               'assets/images/menu1.png',
                //               height: 22,
                //               width: 22,
                //             ),*/
                //             Image.asset(
                //               'assets/images/menu/m2.png',
                //               height: 18,
                //               width: 18,
                //             ),
                //             Container(
                //               margin: EdgeInsets.only(left: 16),
                //               child: Text(
                //                 "รายการค่าขยะ",
                //                 style: TextStyle(
                //                   fontSize: 15,
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       Divider(height: 1, indent: 8, endIndent: 8),
                //     ],
                //   ),
                // ),

                //version
                /*Stack(
                  children: [
                    Image.asset(
                      'assets/images/btm_version.png',
                      width: double.infinity,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 85),
                      padding: EdgeInsets.only(left: 32),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Version " + _packageInfo.version,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "Powered by ",
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                "CityVariety Co.,Ltd,",
                                style:
                                TextStyle(color: Colors.blueAccent, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
