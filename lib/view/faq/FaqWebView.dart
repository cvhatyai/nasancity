import 'dart:convert';
import 'dart:io';

import 'package:nasancity/model/AllList.dart';
import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/system/widht_device.dart';
import 'package:nasancity/view/PageSubView.dart';
import 'package:flutter/material.dart';
import 'package:nasancity/system/Info.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

import '../AppBarView.dart';

var data;

class FaqWebView extends StatefulWidget {
  FaqWebView({Key key, this.isHaveArrow = ""}) : super(key: key);
  final String isHaveArrow;

  @override
  _FaqWebViewState createState() => _FaqWebViewState();
}

class _FaqWebViewState extends State<FaqWebView> {
  getFaq() async {
    Map _map = {};
    _map.addAll({
      "rows": "6",
    });

    EasyLoading.show(status: 'loading...');
    print("_map : " + _map.toString());
    var body = json.encode(_map);
    return postFaqList(http.Client(), body, _map);
  }

  Future<List<AllList>> postFaqList(
      http.Client client, jsonMap, Map map) async {
    final response = await client.post(Uri.parse(Info().faqList),
        headers: {"Content-Type": "application/json"}, body: jsonMap);
    print(json.decode(response.body));
    parseFaqList(response.body);
  }

  List<AllList> parseFaqList(String responseBody) {
    data = [];
    data.addAll(json.decode(responseBody));
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    parsed.map<AllList>((json) => AllList.fromJson(json)).toList();
    setState(() {});
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFaq();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return PageSubView(
      title: "FAQ ถาม-ตอบ",
      isHaveArrow: widget.isHaveArrow,
      widget: Container(
        // padding: EdgeInsets.only(left: 5, right: 5),
        margin: EdgeInsets.only(bottom: 10),
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          width: WidhtDevice().widht(context),
          child: (data != null && data.length != 0)
              ? ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                        // color: listColor[index % 3],
                        border: Border.all(
                          color: Color(0xFFC4C4C4),
                        ),
                      ),
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: ExpansionTile(
                        title: Row(
                          children: [
                            Container(
                              width: 13,
                              height: 13,
                              margin: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.blue, width: 3.0),
                                  color: Colors.white,
                                  shape: BoxShape.circle),
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  data[index]["subject"],
                                  style: TextStyle(
                                    fontFamily: FontStyles.FontFamily,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                        children: <Widget>[
                          Column(
                            children: [
                              Container(
                                child: Text(
                                  data[index]["subject"],
                                  style: TextStyle(
                                    fontFamily: FontStyles.FontFamily,
                                    fontSize: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              Divider(),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Html(
                                          data: '' +
                                              data[index]["description"] +
                                              ''),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "สร้างเมื่อ " +
                                          data[index]["create_date"],
                                      style: TextStyle(
                                        fontFamily: FontStyles.FontFamily,
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    // if (data[index]["update_date"] != "")
                                    //   Text(
                                    //     "แก้ไขเมื่อ " +
                                    //         (data[index]["update_date"] != ""
                                    //             ? data[index]["update_date"]
                                    //             : ""),
                                    //     style: TextStyle(
                                    //       fontFamily: FontStyles.FontFamily,
                                    //       fontSize: 12,
                                    //       color: Colors.grey,
                                    //     ),
                                    //   ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    " -- ไม่มีข้อมูล --",
                    style: TextStyle(
                      fontFamily: FontStyles.FontFamily,
                      fontSize: 22,
                      color: Colors.grey,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
