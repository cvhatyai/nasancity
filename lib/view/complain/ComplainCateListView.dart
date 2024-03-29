import 'dart:convert';

import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/system/widht_device.dart';
import 'package:nasancity/view/PageSubView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nasancity/model/AllList.dart';
import 'package:nasancity/model/user.dart';
import 'package:nasancity/system/Info.dart';
import 'package:nasancity/view/gallery/GalleryDetailView.dart';
import 'package:nasancity/view/login/LoginView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../AppBarView.dart';
import 'ComplainFormView.dart';

var data;

class ComplainCateListView extends StatefulWidget {
  ComplainCateListView({Key key, this.isHaveArrow = ""}) : super(key: key);
  final String isHaveArrow;

  @override
  _ComplainCateListViewState createState() => _ComplainCateListViewState();
}

class _ComplainCateListViewState extends State<ComplainCateListView> {
  var user = User();
  bool isLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
    getNewsList();
  }

  getUsers() async {
    await user.init();
    setState(() {
      isLogin = user.isLogin;
    });
  }

  getNewsList() async {
    Map _map = {};
    _map.addAll({});

    EasyLoading.show(status: 'loading...');
    print("_map : " + _map.toString());
    var body = json.encode(_map);
    return postNewsList(http.Client(), body, _map);
  }

  Future<List<AllList>> postNewsList(
      http.Client client, jsonMap, Map map) async {
    final response = await client.post(Uri.parse(Info().cateInformList),
        headers: {"Content-Type": "application/json"}, body: jsonMap);
    parseNewsList(response.body);
  }

  List<AllList> parseNewsList(String responseBody) {
    data = [];
    data.addAll(json.decode(responseBody));

    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    parsed.map<AllList>((json) => AllList.fromJson(json)).toList();
    setState(() {});
    EasyLoading.dismiss();
  }

  BoxDecoration boxWhite() {
    return BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(9.0),
      ),
      border: Border.all(
        color: Colors.white,
        width: 1.0,
      ),
      color: Color(0xFFF5F6FA),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = WidhtDevice().widht(context) >= 768
        ? ((size.height - kToolbarHeight - 50) / 4)
        : ((size.height - kToolbarHeight - 50) / 5);
    final double itemWidth = size.width / 3;

    return PageSubView(
      title: "แจ้งเรื่องร้องเรียน",
      isHaveArrow: widget.isHaveArrow,
      widget: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFFFF700),
                    border: Border.all(
                      width: 1,
                      color: Color(0xFFFF9100),
                    ),
                  ),
                  padding:
                      EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
                  child: Text(
                    "เลือกหมวดหมู่เพื่อแจ้งเรื่อง",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: FontStyles.FontFamily,
                        fontWeight: FontWeight.w400),
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 5),
              child: (data != null && data.length != 0)
                  ? GridView.count(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      childAspectRatio: (itemWidth / itemHeight),
                      crossAxisCount:
                          WidhtDevice().widht(context) >= 768 ? 5 : 3,
                      children: List.generate(data.length, (index) {
                        return GestureDetector(
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
                                  builder: (context) => ComplainFormView(
                                    topicID: data[index]["id"].toString(),
                                    subjectTitle: data[index]["subject"],
                                    displayImage: data[index]["display_image"],
                                  ),
                                ),
                              );
                            }
                          },
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.only(
                                left: 4,
                                right: 4,
                                top: 8,
                              ),
                              //decoration: boxWhite(),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      width: WidhtDevice().widht(context) >= 768
                                          ? WidhtDevice().widht(context) / 10
                                          : WidhtDevice().widht(context) / 5,
                                      height: WidhtDevice().widht(context) >=
                                              768
                                          ? WidhtDevice().widht(context) / 10
                                          : WidhtDevice().widht(context) / 5,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 3,
                                          color: Color(0xFFDADADA),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: Offset(0,
                                                2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(16),
                                      child: Image.network(
                                        data[index]["display_image"],
                                      ),
                                    ),
                                    Container(
                                      width: WidhtDevice().widht(context) >= 768
                                          ? WidhtDevice().widht(context) / 10
                                          : MediaQuery.of(context).size.width *
                                              0.4,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(6),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Text(
                                          data[index]["subject"],
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 12,
                                              height: 1.2,
                                              fontFamily: FontStyles.FontFamily,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Center(child: Text("ไม่มีข้อมูล")),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
