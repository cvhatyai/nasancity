import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/system/Info.dart';
import 'package:nasancity/view/poll/PollView.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nasancity/model/AllList.dart';
import 'package:package_info/package_info.dart';
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
  var osName = "";
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        osName = "Android " + deviceData["version.release"];
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        osName = "IOS " + deviceData["data.systemVersion"];
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
      print(_deviceData.toString());
      print(osName.toString());
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSiteDetail();
    _initPackageInfo();
    initPlatformState();
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
      padding: EdgeInsets.only(bottom: 36, top: 20),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       "คุยสดกับเจ้าหน้าที่",
          //       textAlign: TextAlign.center,
          //       style: TextStyle(fontSize: 11),
          //     ),
          //     Padding(padding: EdgeInsets.all(5)),
          //     GestureDetector(
          //       onTap: () {
          //         _makePhoneCall('tel:077346096');
          //       },
          //       child: Row(
          //         children: [
          //           Icon(
          //             Icons.phone,
          //             color: Colors.blueAccent,
          //             size: 18,
          //           ),
          //           Text(
          //             'โทร. 0-7734-6096',
          //             textAlign: TextAlign.center,
          //             style: TextStyle(fontSize: 11),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Expanded(
              //   child: GestureDetector(
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => PollView(
              //             isHaveArrow: "1",
              //           ),
              //         ),
              //       );
              //     },
              //     child: Container(
              //       margin: EdgeInsets.only(left: 10, bottom: 5),
              //       padding: EdgeInsets.only(top: 4, bottom: 4),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.all(
              //           Radius.circular(3),
              //         ),
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.grey.withOpacity(0.5),
              //             spreadRadius: 3,
              //             blurRadius: 7,
              //             offset: Offset(0, 3), // changes position of shadow
              //           ),
              //         ],
              //         color: Colors.white,
              //       ),
              //       child: SingleChildScrollView(
              //         scrollDirection: Axis.horizontal,
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Image.asset(
              //               'assets/item/menu/review_1.png',
              //               height: 18,
              //               width: 18,
              //             ),
              //             Container(
              //               padding: EdgeInsets.only(left: 2),
              //               child: Text(
              //                 "ประเมินความพึงพอใจ",
              //                 style: TextStyle(
              //                     fontSize: 11, fontWeight: FontWeight.normal),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Text(
                'คุยสดกับเจ้าหน้าที่',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontFamily: FontStyles.FontFamily,
                  fontWeight: FontWeight.w300,
                ),
              ),
              GestureDetector(
                onTap: () {
                  launch("fb://page/266856016823629");
                  // _launchInBrowser(
                  //     'https://www.facebook.com/nasanmunicipality/');
                  // Toast.show("ไม่มีข้อมูล", context,
                  //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  // if (faceLink != "") {
                  //   _launchInBrowser(faceLink);
                  // } else {
                  //   Toast.show("ไม่มีข้อมูล", context,
                  //       duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  // }
                },
                child: Image.asset(
                  'assets/item/face.png',
                  fit: BoxFit.contain,
                  width: 130,
                ),
              ),
              GestureDetector(
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
                  fit: BoxFit.contain,
                  width: 130,
                ),
              ),
            ],
          ),
          Divider(),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Copyright©2021 All rights reserved. Powered by ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: FontStyles.FontFamily,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                TextSpan(
                  text: 'CityVariety Corporation.',
                  style: TextStyle(
                    color: Color(0xFFEB1717),
                    fontSize: 12,
                    fontFamily: FontStyles.FontFamily,
                    fontWeight: FontWeight.w300,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchInBrowser("http://cityvariety.co.th");
                    },
                ),
              ],
            ),
          ),
          Text(
            "Version " + _packageInfo.version + " On " + osName,
            style: TextStyle(
              fontFamily: FontStyles.FontFamily,
              height: 1,
              fontSize: 12,
            ),
          ),
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
          SizedBox(
            height: 5,
          ),
          Text(
            "ขนาดจออุปกรณ์นี้ " +
                MediaQuery.of(context).size.width.toString() +
                " X " +
                MediaQuery.of(context).size.height.toString(),
            style: TextStyle(
              fontFamily: FontStyles.FontFamily,
              height: 1,
              fontSize: 12,
              color: Colors.grey.shade300,
            ),
          )
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
