import 'dart:convert';

import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/view/PageSubView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nasancity/model/AllList.dart';
import 'package:nasancity/system/Info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../AppBarView.dart';
import 'DownloadDetailView.dart';

var data;

//dropdown
var arrMap;
String cateVal = "";
Map<int, String> dataCateMap = {0: "-- เลือกหมวด --"};
//dropdown

class DownloadListView extends StatefulWidget {
  DownloadListView(
      {Key key, this.isHaveArrow = "", this.title = "", this.keyword = ""})
      : super(key: key);
  final String isHaveArrow;
  final String title;
  final String keyword;

  @override
  _DownloadListViewState createState() => _DownloadListViewState();
}

class _DownloadListViewState extends State<DownloadListView> {
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
    data.clear();
    dataCateMap = {0: "-- เลือกหมวด --"};
    arrMap.clear();
    cateVal = "";
    super.dispose();
  }

  getUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userFullname = prefs.getString('userFullname').toString();
      uid = prefs.getString('uid').toString();
    });
    getCateList();
    getNewsList();
  }

  //dropdown
  getCateList() {
    Map _map = {};
    _map.addAll({
      "cmd": "form_template",
    });
    var body = json.encode(_map);
    return postCateData(http.Client(), body, _map);
  }

  Future<List<AllList>> postCateData(
      http.Client client, jsonMap, Map map) async {
    final response = await client.post(Uri.parse(Info().cateList),
        headers: {"Content-Type": "application/json"}, body: jsonMap);
    return parseCateData(response.body);
  }

  List<AllList> parseCateData(String responseBody) {
    //print("responseBody" + responseBody.toString());
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    arrMap = parsed.map<AllList>((json) => AllList.fromJson(json)).toList();
    print("arrMap" + arrMap.toString());

    Map<int, String> tmpDataCateMap;
    tmpDataCateMap =
        Map.fromIterable(arrMap, key: (e) => e.id, value: (e) => e.cate_name);
    dataCateMap.addAll(tmpDataCateMap);

    print("dataCateMap" + dataCateMap.toString());

    setState(() {});

    return parsed.map<AllList>((json) => AllList.fromJson(json)).toList();
  }

  String dropdownValue2 = (cateVal != "") ? cateVal : "0";

  Widget dropDownCate() {
    return (arrMap != null && arrMap.length != 0)
        ? DropdownButton<String>(
            value: dropdownValue2,
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down_outlined),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
                color: Colors.black,
                fontFamily: FontStyles.FontFamily,
                fontWeight: FontWeight.w400),
            underline: Container(
              height: 1,
              color: Colors.grey,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue2 = newValue;
                cateVal = dropdownValue2;
                getNewsList();
                print("cateVal" + cateVal);
              });
            },
            items: dataCateMap.entries
                .map<DropdownMenuItem<String>>(
                    (MapEntry<int, String> e) => DropdownMenuItem<String>(
                          value: e.key.toString(),
                          child: Text(
                            e.value,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ))
                .toList(),
          )
        : Container();
  }

  //dropdown

  getNewsList() async {
    Map _map = {};
    _map.addAll({
      "uid": uid,
      "cmd": "form_template",
      "row": "200",
      "cid": cateVal,
      "keyword": widget.keyword,
    });

    EasyLoading.show(status: 'loading...');
    print("_map : " + _map.toString());
    var body = json.encode(_map);
    return postNewsList(http.Client(), body, _map);
  }

  Future<List<AllList>> postNewsList(
      http.Client client, jsonMap, Map map) async {
    final response = await client.post(Uri.parse(Info().newsDocumentList),
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

  @override
  Widget build(BuildContext context) {
    return PageSubView(
      title: "เอกสาร/แบบฟอร์ม",
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
            child: dropDownCate(),
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
                                builder: (context) => DownloadDetailView(
                                  topicID: data[index]["id"],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 4),
                            child: Card(
                              color: Color(0xFFF1F9FF),
                              child: ConstrainedBox(
                                constraints: new BoxConstraints(
                                  minHeight:
                                      MediaQuery.of(context).size.height * 0.08,
                                ),
                                child: Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Icon(
                                          Icons.circle,
                                          color: Color(0xFF707070),
                                          size: 12,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 10,
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          child: Text(
                                            data[index]["subject"],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(child: Text("ไม่มีข้อมูล")),
            ),
          ),
        ],
      ),
    );
  }
}
