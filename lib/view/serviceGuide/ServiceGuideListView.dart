import 'dart:convert';

import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/view/PageSubView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:nasancity/model/AllList.dart';
import 'package:nasancity/system/Info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AppBarView.dart';
import 'ServiceGuideSubListView.dart';

var data;

class ServiceGuideListView extends StatefulWidget {
  ServiceGuideListView({Key key, this.isHaveArrow = ""}) : super(key: key);
  final String isHaveArrow;

  @override
  _ServiceGuideListViewState createState() => _ServiceGuideListViewState();
}

class _ServiceGuideListViewState extends State<ServiceGuideListView> {
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
    });

    EasyLoading.show(status: 'loading...');
    print("_map : " + _map.toString());
    var body = json.encode(_map);
    return postNewsList(http.Client(), body, _map);
  }

  Future<List<AllList>> postNewsList(
      http.Client client, jsonMap, Map map) async {
    final response = await client.post(Uri.parse(Info().serviceGuideCateList),
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
    print(keyword.text);
    if (keyword.text != "") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceGuideSubListView(
            isHaveArrow: "1",
            title: "บริการของเทศบาล",
            keyword: keyword.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageSubView(
      title: "บริการของเทศบาล",
      isHaveArrow: widget.isHaveArrow,
      widget: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 16, left: 16, right: 16),
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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: keyword,
                    decoration: InputDecoration(
                      hintText: 'พิมพ์คำค้นหา เช่น ภาษีป้าย',
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
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.only(left: 8, right: 8),
              child: (data != null && data.length != 0)
                  ? ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ServiceGuideSubListView(
                                  isHaveArrow: "1",
                                  title: data[index]["cate_name"],
                                  cid: data[index]["id"],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 4),
                            child: Card(
                              color: Color(0xFFF1F9FF),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(8),
                                        /*child: ClipRRect(
                                          child: Image.network(
                                            data[index]["display_image"],
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),*/
                                      ),
                                    ),
                                    Expanded(
                                      flex: 10,
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        child: Text(
                                          data[index]["cate_name"],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Color(0xFF707070),
                                        size: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
