import 'dart:convert';

import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/view/PageSubView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nasancity/model/AllList.dart';
import 'package:nasancity/system/Info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../AppBarView.dart';
import 'CalendarDetailView.dart';

var data;

class CalendarListView extends StatefulWidget {
  CalendarListView({Key key, this.isHaveArrow = ""}) : super(key: key);
  final String isHaveArrow;

  @override
  _CalendarListViewState createState() => _CalendarListViewState();
}

class _CalendarListViewState extends State<CalendarListView> {
  var userFullname;
  var uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetail();
  }

  @override
  void dispose() {
    setState(() {
      data.clear();
    });
    super.dispose();
  }

  getUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userFullname = prefs.getString('userFullname').toString();
      uid = prefs.getString('uid').toString();
    });
    getNewsList();
  }

  getNewsList() async {
    Map _map = {};
    _map.addAll({
      "uid": uid,
    });

    EasyLoading.show(status: 'loading...');
    print("_map : " + _map.toString());
    var body = json.encode(_map);
    return postNewsList(http.Client(), body, _map);
  }

  Future<List<AllList>> postNewsList(
      http.Client client, jsonMap, Map map) async {
    final response = await client.post(Uri.parse(Info().eventsList),
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
      /*borderRadius: BorderRadius.all(
        Radius.circular(9.0),
      ),*/
      border: Border.all(
        color: Colors.white,
        width: 1.0,
      ),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.6;
    final double itemWidth = size.width / 2;

    return PageSubView(
      title: 'กิจกรรมห้ามพลาด',
      isHaveArrow: widget.isHaveArrow,
      widget: Container(
        // color: Color(0xFFFFFFFF),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
              ),
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text("วันที่",
                          style: TextStyle(
                            fontFamily: FontStyles.FontFamily,
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                  ),
                  Container(
                    width: 20,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 1,
                          height: 30,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: EdgeInsets.only(left: 16),
                      child: Text("กิจกรรม",
                          style: TextStyle(
                            fontFamily: FontStyles.FontFamily,
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                color: Colors.white.withOpacity(0.5),
                child: (data != null && data.length != 0)
                    ? ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data[index]["sdate"],
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.deepOrange,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text("-" + data[index]["edate"]),
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          data[index]["smonth"],
                                          style: TextStyle(fontSize: 9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 20,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: 1,
                                      height: 80,
                                      color: Colors.black12,
                                    ),
                                    Positioned(
                                      top: 30,
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Colors.blueAccent,
                                              width: 4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CalendarDetailView(
                                                topicID: data[index]["id"]
                                                    .toString()),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(9.0),
                                      ),
                                      border: Border.all(color: Colors.black12),
                                      color: Colors.white,
                                    ),
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    padding: EdgeInsets.all(6),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data[index]["subject"],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(height: 1),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 4),
                                                child: Text(
                                                  data[index]["location"],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        })
                    : Center(
                        child: Text("ไม่มีข้อมูล"),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
