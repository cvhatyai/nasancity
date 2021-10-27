import 'dart:convert';

import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/system/Info.dart';
import 'package:nasancity/view/PageSubView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nasancity/model/AllList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// import '../AppBarView.dart';

var data;

class WeatherListScreen extends StatefulWidget {
  WeatherListScreen({Key key, this.isHaveArrow = ""}) : super(key: key);
  final String isHaveArrow;

  @override
  _WeatherListScreenState createState() => _WeatherListScreenState();
}

class _WeatherListScreenState extends State<WeatherListScreen> {
  var defaultIcon = "https://api.cityvariety.com/weather/icon/rain-day.png";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsList();
  }

  getNewsList() async {
    Map _map = {};
    _map.addAll({
      "rows": "100",
    });

    EasyLoading.show(status: 'loading...');
    print("_map : " + _map.toString());
    var body = json.encode(_map);
    return postNewsList(http.Client(), body, _map);
  }

  postNewsList(http.Client client, jsonMap, Map map) async {
    final response = await client.post(Uri.parse(Info().weatherListApi),
        headers: {"Content-Type": "application/json"}, body: jsonMap);
    parseNewsList(response.body);
  }

  parseNewsList(String responseBody) {
    print("responseBodyList1" + responseBody);
    data = [];
    data.addAll(json.decode(responseBody));
    //print("responseBodyList2" + data.toString());

    // final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    // parsed.map<AllList>((json) => AllList.fromJson(json)).toList();
    setState(() {});
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return PageSubView(
      title: 'พยากรณ์อากาศ',
      isHaveArrow: 'true',
      widget: (data != null && data.length != 0)
          ? ListView.builder(
              itemCount: data.length,
              padding: EdgeInsets.all(0),
              itemExtent: 65,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                child: _convertDate(data[index]["date"]),
                              ),
                            ),
                            Container(
                              height: 65,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    width: 13,
                                    height: 13,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xFF07930A),
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Color(0xFF1C6FC4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  border: Border.all(
                                    color: Color(0xFF48BE00),
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Image.network(
                                                  data[index]["icon"],
                                                  height: 30,
                                                ),
                                              ),
                                              Container(
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Text(
                                                    data[index]["title"],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontFamily:
                                                          FontStyles.FontFamily,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        child: Text(
                                          data[index]["description"],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: FontStyles.FontFamily,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
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
                );
              },
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: Text("ไม่มีข้อมูล")),
            ),
    );
  }

  _convertDate(String date) {
    var list = date.split(' ');
    if (list.length > 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            list[1],
            style: TextStyle(
              color: Color(0xFFFF6600),
              fontSize: 24,
              fontFamily: FontStyles.FontFamily,
              height: 1,
            ),
          ),
          Text(
            list[2],
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: FontStyles.FontFamily,
              height: 1,
              fontWeight: FontWeight.w300,
            ),
          )
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            list[0],
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: FontStyles.FontFamily),
          )
        ],
      );
    }
  }
}
