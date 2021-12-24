import 'dart:convert';

import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/system/Info.dart';
import 'package:nasancity/system/widht_device.dart';
import 'package:nasancity/view/news/NewsDetailView.dart';
import 'package:nasancity/view/news/NewsListView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nasancity/model/AllList.dart';
import 'package:http/http.dart' as http;

var data;

class NewsWidget extends StatefulWidget {
  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsList();
  }

  getNewsList() async {
    Map _map = {};
    _map.addAll({
      "rows": "6",
    });

    EasyLoading.show(status: 'loading...');
    print("_map : " + _map.toString());
    var body = json.encode(_map);
    return postNewsList(http.Client(), body, _map);
  }

  Future<List<AllList>> postNewsList(
      http.Client client, jsonMap, Map map) async {
    final response = await client.post(Uri.parse(Info().newsList),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'นาสาร',
                    style: TextStyle(
                      color: Color(0xFFEB1717),
                      fontFamily: FontStyles.FontFamily,
                      fontSize: 26,
                    ),
                  ),
                  Text(
                    'อัปเดต',
                    style: TextStyle(
                      color: Color(0xFF0075CC),
                      fontFamily: FontStyles.FontFamily,
                      fontSize: 26,
                    ),
                  )
                ],
              ),
              Text(
                'ข่าวสำคัญ',
                style: TextStyle(
                  color: Color(0xFF707070),
                  fontFamily: FontStyles.FontFamily,
                  fontSize: 18,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16, bottom: 10),
          height: 220,
          // color: Colors.amber,
          child: (data != null && data.length != 0)
              ? ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var i = 0; i < data.length; i++)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailView(
                                  topicID: data[i]["id"].toString()),
                            ),
                          );
                        },
                        child: Container(
                          width: WidhtDevice().widht(context) * 0.45,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            // alignment: Alignment.topCenter,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  data[i]["display_image"],
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.grey.withOpacity(0.5),
                                  //     spreadRadius: 1,
                                  //     blurRadius: 7,
                                  //     offset: Offset(
                                  //       0,
                                  //       1,
                                  //     ), // changes position of shadow
                                  //   ),
                                  // ],
                                ),
                                alignment: Alignment.center,
                                width: WidhtDevice().widht(context) * 0.45,
                                height: 80,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          data[i]["subject"],
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ),
                                      Text(
                                        data[i]["create_date"],
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFFEB1717),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                )
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: WidhtDevice().widht(context),
                  child: Center(child: Text("ไม่มีข้อมูล")),
                ),
        ),
        if (data != null && data.length != 0)
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
            child: Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFEB1717),
              ),
              child: Text(
                'ดูทั้งหมด',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.all(10),
        ),
      ],
    );
  }
}
