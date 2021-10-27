import 'dart:convert';

import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/system/Info.dart';
import 'package:nasancity/system/widht_device.dart';
import 'package:nasancity/view/gallery/GalleryDetailView.dart';
import 'package:nasancity/view/gallery/GalleryListView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nasancity/model/AllList.dart';
// import 'package:nasancity/system/Info.dart';
// import 'package:nasancity/view/calendar/CalendarDetailView.dart';
// import 'package:nasancity/view/calendar/CalendarListView.dart';
// import 'package:nasancity/view/gallery/GalleryDetailView.dart';
// import 'package:nasancity/view/gallery/GalleryListView.dart';
import 'package:http/http.dart' as http;

var data;
var data2;

class GalleryWidget extends StatefulWidget {
  @override
  _GalleryWidgetState createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsList();
    getActivtyList();
  }

  //activity
  getActivtyList() async {
    Map _map = {};
    _map.addAll({
      "rows": "2",
    });

    EasyLoading.show(status: 'loading...');
    print("_map : " + _map.toString());
    var body = json.encode(_map);
    return postActivityList(http.Client(), body, _map);
  }

  Future<List<AllList>> postActivityList(
      http.Client client, jsonMap, Map map) async {
    final response = await client.post(Uri.parse(Info().eventsList),
        headers: {"Content-Type": "application/json"}, body: jsonMap);
    parseActivityList(response.body);
  }

  List<AllList> parseActivityList(String responseBody) {
    data2 = [];
    data2.addAll(json.decode(responseBody));

    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    parsed.map<AllList>((json) => AllList.fromJson(json)).toList();
    setState(() {});
    EasyLoading.dismiss();
  }

  //gallery
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
    final response = await client.post(Uri.parse(Info().galleryList),
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

  //tab
  Color tabTextColorNormal = Color(0xFF707070);
  Color tabTextColorActive = Color(0xFF4283C4);
  BoxDecoration indicatorTabColorNormal = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.white.withOpacity(0.5),
  );
  BoxDecoration indicatorTabColorActive = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.blue.shade300,
  );
  bool isFirstTabActivated = true;

  changeTab() {
    setState(() {
      if (isFirstTabActivated) {
        isFirstTabActivated = false;
      } else {
        isFirstTabActivated = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFf5f6fa).withOpacity(0.5),
      child: Container(
        child: Column(
          children: [
            Container(
              // color: Colors.white,
              padding: EdgeInsets.only(left: 8, top: 28),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!isFirstTabActivated) {
                        changeTab();
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 25, right: 25, top: 5, bottom: 5),
                          decoration: (isFirstTabActivated)
                              ? indicatorTabColorActive
                              : indicatorTabColorNormal,
                          child: Text(
                            "ภาพกิจกรรม",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: FontStyles.FontFamily,
                              color: (isFirstTabActivated)
                                  ? Colors.white
                                  : Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                  GestureDetector(
                    onTap: () {
                      if (isFirstTabActivated) {
                        changeTab();
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 25, right: 25, top: 5, bottom: 5),
                          decoration: (!isFirstTabActivated)
                              ? indicatorTabColorActive
                              : indicatorTabColorNormal,
                          child: Text(
                            "กิจกรรมห้ามพลาด",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: FontStyles.FontFamily,
                              color: (!isFirstTabActivated)
                                  ? Colors.white
                                  : Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            (isFirstTabActivated)
                ? Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        height: 240,
                        margin: EdgeInsets.only(top: 8),
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
                                            builder: (context) =>
                                                GalleryDetailView(
                                                    topicID: data[i]["id"]
                                                        .toString()),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            WidhtDevice().widht(context) * 0.5,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        child: Column(
                                          children: [
                                            Container(
                                              width:
                                                  WidhtDevice().widht(context) *
                                                      0.45,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 1,
                                                    blurRadius: 7,
                                                    offset: Offset(
                                                      0,
                                                      1,
                                                    ), // changes position of shadow
                                                  ),
                                                ],
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  colorFilter:
                                                      new ColorFilter.mode(
                                                          Colors.white
                                                              .withOpacity(0.3),
                                                          BlendMode.dstATop),
                                                  image: new NetworkImage(
                                                    data[i]["display_image"],
                                                  ),
                                                ),
                                              ),
                                              height: 135,
                                              child: Image.network(
                                                data[i]["display_image"],
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 1,
                                                    blurRadius: 7,
                                                    offset: Offset(
                                                      0,
                                                      1,
                                                    ), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              width:
                                                  WidhtDevice().widht(context) *
                                                      0.45,
                                              height: 80,
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        data[i]["subject"],
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Text(
                                                      data[i]["create_date"],
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            Color(0xFF6399C4),
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
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
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
                                child: Container(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.yellow,
                                    border: Border.all(
                                        width: 3, color: Colors.white),
                                  ),
                                  child: Text(
                                    'ดูทั้งหมด',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  )
                : Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        height: 240,
                        margin: EdgeInsets.only(top: 8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "วันที่",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: FontStyles.FontFamily),
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
                                    child: Text(
                                      "กิจกรรม",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: FontStyles.FontFamily),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                color: Color(0xFFFFFFFF),
                                child: (data2 != null && data2.length != 0)
                                    ? ListView.builder(
                                        itemCount: data2.length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            data2[index]
                                                                ["sdate"],
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .deepOrange,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text("-" +
                                                              data2[index]
                                                                  ["edate"]),
                                                        ],
                                                      ),
                                                      Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          data2[index]
                                                              ["smonth"],
                                                          style: TextStyle(
                                                              fontSize: 9),
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
                                                      alignment:
                                                          Alignment.center,
                                                      width: 1,
                                                      height: 80,
                                                      color: Colors.black12,
                                                    ),
                                                    Positioned(
                                                      top: 30,
                                                      child: Container(
                                                        width: 16,
                                                        height: 16,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .blueAccent,
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
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) =>
                                                    //         CalendarDetailView(
                                                    //             topicID: data2[
                                                    //                         index]
                                                    //                     ["id"]
                                                    //                 .toString()),
                                                    //   ),
                                                    // );
                                                  },
                                                  child: Container(
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(9.0),
                                                      ),
                                                      border: Border.all(
                                                          color:
                                                              Colors.black12),
                                                      color: Colors.white,
                                                    ),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8),
                                                    padding: EdgeInsets.all(6),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                data2[index]
                                                                    ["subject"],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style:
                                                                    TextStyle(
                                                                        height:
                                                                            1),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 4),
                                                                child: Text(
                                                                  data2[index][
                                                                      "location"],
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios,
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
                                    : Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width: WidhtDevice().widht(context),
                                        child:
                                            Center(child: Text("ไม่มีข้อมูล")),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (data2 != null && data2.length != 0)
                        Container(
                          padding: EdgeInsets.all(8),
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => CalendarListView(
                              //       isHaveArrow: "1",
                              //     ),
                              //   ),
                              // );
                            },
                            child: Image.asset(
                              'assets/images/main/more.png',
                              height: 24,
                            ),
                          ),
                        )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
