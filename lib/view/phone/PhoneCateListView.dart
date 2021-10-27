import 'dart:convert';

import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/view/PageSubView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:nasancity/model/AllList.dart';
import 'package:nasancity/system/Info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../AppBarView.dart';
import 'PhoneDetailView.dart';
import 'PhoneListView.dart';

var data;

class PhoneCateListView extends StatefulWidget {
  PhoneCateListView({Key key, this.isHaveArrow = ""}) : super(key: key);
  final String isHaveArrow;

  @override
  _PhoneCateListViewState createState() => _PhoneCateListViewState();
}

class _PhoneCateListViewState extends State<PhoneCateListView> {
  var userFullname;
  var uid;

  final keyword = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetail();
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
      "rows": 500,
      "cid": "2",
    });

    EasyLoading.show(status: 'loading...');
    print("_map : " + _map.toString());
    var body = json.encode(_map);
    return postNewsList(http.Client(), body, _map);
  }

  Future<List<AllList>> postNewsList(
      http.Client client, jsonMap, Map map) async {
    final response = await client.post(Uri.parse(Info().callList),
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

  getDataDetail() {
    if (keyword.text != "") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhoneListView(
            isHaveArrow: "1",
            keyword: keyword.text,
          ),
        ),
      );
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageSubView(
      title: 'เบอร์โทรสำคัญ',
      isHaveArrow: widget.isHaveArrow,
      widget: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    // margin: EdgeInsets.only(left: 16, right: 16),
                    padding: EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                      ),
                    ),
                    child: TextField(
                      controller: keyword,
                      decoration: InputDecoration(
                        hintText: 'พิมพ์คำค้นหา เช่น ชื่อ-นามสกุล',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: FontStyles.FontFamily,
                          fontWeight: FontWeight.w300,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            getDataDetail();
                          },
                          icon: Icon(
                            Icons.search,
                            color: Color(0xFF00B9FF),
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _makePhoneCall('tel:077346096');
            },
            child: Container(
              margin: EdgeInsets.only(top: 16),
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/call.png',
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "แจ้งเหตุด่วน",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: FontStyles.FontFamily,
                                  height: 1.2,
                                ),
                              ),
                              Text(
                                "สายด่วน",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: FontStyles.FontFamily,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 4),
                                child: Text(
                                  "เทศบาลตำบลบ้านเชี่ยวหลาน",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: FontStyles.FontFamily,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "0 7734 6096",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: FontStyles.FontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 16),
              padding: EdgeInsets.only(left: 16, right: 16),
              child: (data != null && data.length != 0)
                  ? GroupedListView<dynamic, String>(
                      elements: data,
                      sort: false,
                      groupBy: (element) => element['session_header'],
                      useStickyGroupSeparators: true,
                      groupSeparatorBuilder: (String value) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          value,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      itemBuilder: (c, element) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhoneDetailView(
                                  isHaveArrow: "1",
                                  id: element["id"],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        element["display_image"],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              element["subject"],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              element["tel"],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        );
                      },
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
