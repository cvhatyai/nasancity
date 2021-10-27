import 'dart:convert';

import 'package:nasancity/system/Info.dart';
import 'package:nasancity/view/poll/PollView.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nasancity/model/AllList.dart';
import 'package:toast/toast.dart';
// import 'package:nasancity/system/Info.dart';
// import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class FooterWidget extends StatefulWidget {
  @override
  _FooterWidgetState createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  var faceLink = "";
  var lineLink = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSiteDetail();
  }

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
      faceLink = rs["faceLink"].toString();
      lineLink = rs["lineLink"].toString();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 36, top: 8),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "คุยสดกับเจ้าหน้าที่",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11),
              ),
              Padding(padding: EdgeInsets.all(5)),
              GestureDetector(
                onTap: () {
                  _makePhoneCall('tel:077346096');
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.blueAccent,
                      size: 18,
                    ),
                    Text(
                      'โทร. 0-7734-6096',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PollView(
                          isHaveArrow: "1",
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10, bottom: 5),
                    padding: EdgeInsets.only(top: 4, bottom: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/item/menu/review_1.png',
                            height: 18,
                            width: 18,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 2),
                            child: Text(
                              "ประเมินความพึงพอใจ",
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Toast.show("ไม่มีข้อมูล", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    // if (faceLink != "") {
                    //   _launchInBrowser(faceLink);
                    // } else {
                    //   Toast.show("ไม่มีข้อมูล", context,
                    //       duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    // }
                  },
                  child: Image.asset(
                    'assets/item/face.png',
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (lineLink != "") {
                      _launchInBrowser(lineLink);
                    } else {
                      Toast.show("ไม่มีข้อมูล", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }
                  },
                  child: Image.asset(
                    'assets/item/line.png',
                  ),
                ),
              ),
            ],
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Copyright©2021 ',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: 'nasancity.go.th',
                  style: TextStyle(
                    color: Color(0xFF00C3EB),
                    fontSize: 11,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchInBrowser("https://nasancity.go.th");
                    },
                ),
                TextSpan(
                  text: ' All rights reserved.\n Powered by ',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: 'CityVariety Corporation.',
                  style: TextStyle(
                    color: Color(0xFF00C3EB),
                    fontSize: 11,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchInBrowser("http://cityvariety.co.th");
                    },
                ),
              ],
            ),
          )

          /*TextSpan(
            children: [
              Text(
                " CityVariety Corporation.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
            ],
          ),*/
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}