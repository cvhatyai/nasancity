import 'dart:async';
import 'dart:convert';

import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/system/Info.dart';
import 'package:nasancity/system/widht_device.dart';
import 'package:nasancity/view/travel/TravelDetailView.dart';
import 'package:nasancity/view/travel/TravelListView.dart';
import 'package:nasancity/view/weather/WeatherListScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:nasancity/model/AllList.dart';
// import 'package:nasancity/system/Info.dart';
// import 'package:nasancity/view/travel/TravelDetailView.dart';
// import 'package:nasancity/view/travel/TravelListView.dart';
// import 'package:nasancity/view/weather/WeatherListView.dart';

class TravelWidget extends StatefulWidget {
  @override
  _TravelWidgetState createState() => _TravelWidgetState();
}

class _TravelWidgetState extends State<TravelWidget> {
  int currentTab = 1;
  var title = "ที่เที่ยว";
  var tid = "1";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setWeather();
    getList();
  }

  //weather
  var iconWeather = "";
  var tempWeather = "";
  var textWeather = "";

  setWeather() async {
    Map _map = {};
    _map.addAll({});
    var body = json.encode(_map);
    return postSiteDetail(http.Client(), body, _map);
  }

  postSiteDetail(http.Client client, var jsonMap, Map map) async {
    final response = await client.post(Uri.parse(Info().weatherApi),
        headers: {"Content-Type": "application/json"}, body: jsonMap);
    var rs = json.decode(response.body);
    setState(() {
      iconWeather = rs["icon"].toString();
      tempWeather = rs["temp"].toString();
      textWeather = rs["description"].toString();
    });
    // return rs;
  }

  //tab
  Color selectedColor = Color(0xFFFFF700);
  Color normalColor = Color(0xFFEB1717);
  Color normalTextColor = Color(0xFF45494C);

  BoxDecoration tabSelect = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: Color(0xFFEB1717),
  );
  BoxDecoration tabNormal = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: Color(0xFFEFEFEF),
  );

  getTravel(tab) {
    if (tab != currentTab) {
      setState(() {
        currentTab = tab;
        data.clear();
        getList();
      });
    }
  }

  var data = [];
  var fnName = Info().travelList;

  getList() async {
    Map _map = {};
    _map.addAll({
      "rows": "100",
    });

    EasyLoading.show(status: 'loading...');
    print("_map : " + _map.toString());
    var body = json.encode(_map);
    return postList(http.Client(), body, _map);
  }

  Future<List<AllList>> postList(http.Client client, jsonMap, Map map) async {
    if (currentTab == 1) {
      fnName = Info().travelList;
      tid = "1";
      title = "ที่เที่ยว";
    } else if (currentTab == 2) {
      fnName = Info().eatList;
      tid = "3";
      title = "ที่กิน";
    } else if (currentTab == 3) {
      fnName = Info().restList;
      tid = "2";
      title = "พัก";
    } else if (currentTab == 4) {
      fnName = Info().shopList;
      tid = "4";
      title = "OTOP";
    }

    final response = await client.post(Uri.parse(fnName),
        headers: {"Content-Type": "application/json"}, body: jsonMap);

    parseNewsList(response.body);
  }

  List<AllList> parseNewsList(String responseBody) {
    data.addAll(json.decode(responseBody));

    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    parsed.map<AllList>((json) => AllList.fromJson(json)).toList();
    setState(() {});
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color(0xFFf5f6fa),
      child: Container(
        child: Stack(
          children: [
            Container(
              height: 230,
              width: WidhtDevice().widht(context),
              child: Image.asset(
                'assets/bg/bg-travel.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            Positioned(
              right: 0,
              top: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeatherListScreen(
                        isHaveArrow: "1",
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(6),
                  height: 70,
                  margin: EdgeInsets.only(right: 8),
                  width: WidhtDevice().widht(context) * 0.48,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(9.0),
                      ),
                      color: Colors.black.withOpacity(0.5)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "อากาศนาสารวันนี้",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontFamily: FontStyles.FontFamily,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                if (iconWeather != "")
                                  Expanded(
                                    child: Image.network(
                                      iconWeather,
                                      height: 36,
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    "$tempWeather°",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontFamily: FontStyles.FontFamily,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Text(
                                  textWeather,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    height: 1,
                                    fontFamily: FontStyles.FontFamily,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10, top: 8),
                    child: Image.asset(
                      'assets/logo/icon-travel.png',
                      width: MediaQuery.of(context).size.width / 2.2,
                    ),
                  ),
                  Container(
                    // padding: EdgeInsets.all(4),
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(9.0),
                      ),
                    ),
                    child: Container(
                      child: Center(
                        child: Column(
                          children: [
                            //travelTab
                            Container(
                              width: WidhtDevice().widht(context),
                              margin: EdgeInsets.only(right: 20, left: 20),
                              padding: EdgeInsets.only(
                                  top: 5, bottom: 5, right: 5, left: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 5, right: 5, bottom: 15),
                                      child: GestureDetector(
                                        onTap: () {
                                          getTravel(1);
                                        },
                                        child: Container(
                                          height: 120,
                                          padding: EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          decoration: (currentTab == 1)
                                              ? tabSelect
                                              : tabNormal,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/item/travel/travel1.png',
                                                height: 50,
                                                color: (currentTab == 1)
                                                    ? selectedColor
                                                    : normalColor,
                                              ),
                                              Container(
                                                child: Text(
                                                  "เที่ยว",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontStyles.FontFamily,
                                                    fontSize: 16,
                                                    color: (currentTab == 1)
                                                        ? selectedColor
                                                        : normalTextColor,
                                                  ),
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        top: 15,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          getTravel(2);
                                        },
                                        child: Container(
                                          height: 120,
                                          padding: EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          decoration: (currentTab == 2)
                                              ? tabSelect
                                              : tabNormal,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/item/travel/travel2.png',
                                                height: 50,
                                                color: (currentTab == 2)
                                                    ? selectedColor
                                                    : normalColor,
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "กิน",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontStyles.FontFamily,
                                                    fontSize: 16,
                                                    color: (currentTab == 2)
                                                        ? selectedColor
                                                        : normalTextColor,
                                                  ),
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 4),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        bottom: 15,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          getTravel(3);
                                        },
                                        child: Container(
                                          height: 120,
                                          padding: EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          decoration: (currentTab == 3)
                                              ? tabSelect
                                              : tabNormal,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/item/travel/travel3.png',
                                                height: 50,
                                                color: (currentTab == 3)
                                                    ? selectedColor
                                                    : normalColor,
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "พัก",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontStyles.FontFamily,
                                                    fontSize: 16,
                                                    color: (currentTab == 3)
                                                        ? selectedColor
                                                        : normalTextColor,
                                                  ),
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 4),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 5, right: 5, top: 15),
                                      child: GestureDetector(
                                        onTap: () {
                                          getTravel(4);
                                        },
                                        child: Container(
                                          height: 120,
                                          padding: EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          decoration: (currentTab == 4)
                                              ? tabSelect
                                              : tabNormal,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/item/travel/travel4.png',
                                                height: 50,
                                                color: (currentTab == 4)
                                                    ? selectedColor
                                                    : normalColor,
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "ช๊อป",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontStyles.FontFamily,
                                                    fontSize: 16,
                                                    color: (currentTab == 4)
                                                        ? selectedColor
                                                        : normalTextColor,
                                                  ),
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     getTravel(5);
                                  //   },
                                  //   child: Container(
                                  //     padding: EdgeInsets.all(5),
                                  //     decoration: (currentTab == 5)
                                  //         ? tabSelect
                                  //         : BoxDecoration(),
                                  //     child: Column(
                                  //       children: [
                                  //         Row(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.center,
                                  //           children: [
                                  //             Image.asset(
                                  //               'assets/item/travel/travel5.png',
                                  //               height: 18,
                                  //               color: (currentTab == 5)
                                  //                   ? selectedColor
                                  //                   : normalColor,
                                  //             ),
                                  //             Container(
                                  //               child: Text(
                                  //                 "ตลาดเขียว",
                                  //                 style: TextStyle(
                                  //                   fontFamily:
                                  //                       FontStyles.FontFamily,
                                  //                   fontSize: 14,
                                  //                   color: (currentTab == 5)
                                  //                       ? selectedColor
                                  //                       : normalColor,
                                  //                 ),
                                  //               ),
                                  //               margin: EdgeInsets.symmetric(
                                  //                 horizontal: 4,
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            //contentTravel
                            (data != null && data.length != 0)
                                ? Container(
                                    margin: EdgeInsets.only(top: 4),
                                    child: Column(
                                      children: [
                                        //top1
                                        if (data != null && data.length != 0)
                                          Row(
                                            children: [
                                              if (data != null &&
                                                  data.length != 0)
                                                if (data.length >= 1)
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                TravelDetailView(
                                                              topicID: data[0]
                                                                      ["id"]
                                                                  .toString(),
                                                              title: title,
                                                              tid: tid,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 4,
                                                                vertical: 8),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                9.0),
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                              spreadRadius: 3,
                                                              blurRadius: 7,
                                                              offset: Offset(0,
                                                                  3), // changes position of shadow
                                                            ),
                                                          ],
                                                          color: Colors.white,
                                                        ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.44,
                                                        height: 150,
                                                        child: Column(
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            9.0),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            9.0),
                                                                  ),
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        NetworkImage(
                                                                      data[0][
                                                                          "display_image"],
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8),
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                data[0]
                                                                    ["subject"],
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              data.length == 1
                                                  ? Expanded(child: Container())
                                                  : Container(),
                                              if (data != null &&
                                                  data.length != 0)
                                                if (data.length >= 2)
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                TravelDetailView(
                                                              topicID: data[1]
                                                                      ["id"]
                                                                  .toString(),
                                                              title: title,
                                                              tid: tid,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 4,
                                                                vertical: 8),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                9.0),
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                              spreadRadius: 3,
                                                              blurRadius: 7,
                                                              offset: Offset(0,
                                                                  3), // changes position of shadow
                                                            ),
                                                          ],
                                                          color: Colors.white,
                                                        ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.44,
                                                        height: 150,
                                                        child: Column(
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            9.0),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            9.0),
                                                                  ),
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        NetworkImage(
                                                                      data[1][
                                                                          "display_image"],
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8),
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                data[1]
                                                                    ["subject"],
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            ],
                                          ),

                                        //top2-3
                                        Row(
                                          children: [
                                            if (data != null &&
                                                data.length != 0)
                                              if (data.length >= 3)
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              TravelDetailView(
                                                            topicID: data[2]
                                                                    ["id"]
                                                                .toString(),
                                                            title: title,
                                                            tid: tid,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4,
                                                              vertical: 8),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(9.0),
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            spreadRadius: 3,
                                                            blurRadius: 7,
                                                            offset: Offset(0,
                                                                3), // changes position of shadow
                                                          ),
                                                        ],
                                                        color: Colors.white,
                                                      ),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.44,
                                                      height: 150,
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          9.0),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          9.0),
                                                                ),
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      NetworkImage(
                                                                    data[2][
                                                                        "display_image"],
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              data[2]
                                                                  ["subject"],
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            data.length == 1
                                                ? Expanded(child: Container())
                                                : Container(),
                                            if (data != null &&
                                                data.length != 0)
                                              if (data.length >= 4)
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              TravelDetailView(
                                                            topicID: data[3]
                                                                    ["id"]
                                                                .toString(),
                                                            title: title,
                                                            tid: tid,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4,
                                                              vertical: 8),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(9.0),
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            spreadRadius: 3,
                                                            blurRadius: 7,
                                                            offset: Offset(0,
                                                                3), // changes position of shadow
                                                          ),
                                                        ],
                                                        color: Colors.white,
                                                      ),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.44,
                                                      height: 150,
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          9.0),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          9.0),
                                                                ),
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      NetworkImage(
                                                                    data[3][
                                                                        "display_image"],
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              data[3]
                                                                  ["subject"],
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    height: 350,
                                    width: WidhtDevice().widht(context),
                                    child: Center(child: Text("ไม่มีข้อมูล")),
                                  ),
                            //more
                            if (data != null && data.length != 0)
                              Container(
                                padding: EdgeInsets.all(4),
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    if (currentTab == 1) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TravelListView(
                                            isHaveArrow: "1",
                                            title: "ที่เที่ยว",
                                            tid: "1",
                                          ),
                                        ),
                                      );
                                    } else if (currentTab == 2) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TravelListView(
                                            isHaveArrow: "1",
                                            title: "ที่กิน",
                                            tid: "3",
                                          ),
                                        ),
                                      );
                                    } else if (currentTab == 3) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TravelListView(
                                            isHaveArrow: "1",
                                            title: "พัก",
                                            tid: "2",
                                          ),
                                        ),
                                      );
                                    } else if (currentTab == 4) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TravelListView(
                                            isHaveArrow: "1",
                                            title: "ชอป",
                                            tid: "4",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Image.asset(
                                    'assets/images/main/more.png',
                                    height: 24,
                                  ),
                                ),
                              ),
                          ],
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
    );
  }
}
