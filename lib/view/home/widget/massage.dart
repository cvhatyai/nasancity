import 'dart:convert';

import 'package:nasancity/model/AllList.dart';
import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/system/Info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:http/http.dart' as http;

class MassageWidget extends StatefulWidget {
  const MassageWidget({Key key}) : super(key: key);

  @override
  _MassageWidgetState createState() => _MassageWidgetState();
}

class _MassageWidgetState extends State<MassageWidget> {
  String msg = "ยินดีต้อนรับ :: เทศบาลตำบลบ้านเชี่ยวหลาน";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessageList();
  }

  getMessageList() async {
    Map _map = {};
    _map.addAll({});
    var body = json.encode(_map);
    return postMessageList(http.Client(), body, _map);
  }

  Future<List<AllList>> postMessageList(
      http.Client client, jsonMap, Map map) async {
    final response = await client.post(Uri.parse(Info().messageList),
        headers: {"Content-Type": "application/json"}, body: jsonMap);
    var rs = json.decode(response.body);
    setState(() {
      msg = rs["msg"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey.shade300,
                Colors.white,
              ],
              stops: [
                0,
                1
              ]),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(top: 7, bottom: 7, right: 15, left: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                color: Color(0xFF48BE00),
              ),
              child: FaIcon(
                FontAwesomeIcons.volumeUp,
                color: Colors.white,
                size: 20,
              ),
            ),
            Expanded(
              child: Container(
                height: 20,
                // child: Marquee(
                //   text: msg,
                //   blankSpace: 20.0,
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
