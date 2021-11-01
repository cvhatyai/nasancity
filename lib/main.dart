import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:nasancity/system/widht_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nasancity/system/FirebaseNotification.dart';
import 'package:nasancity/system/Info.dart';
import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/AllList.dart';
import 'view/FrontPageView.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

class ReceivedNotification {
  ReceivedNotification({
    this.id,
    this.title,
    this.body,
    this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

String selectedNotificationPayload = "";

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "MainNavigator"); //ให้ไปหน้านั้นได้เมื่อกดจาก noti
Future<void> main() async {
  // SharedPreferences.setMockInitialValues({});
  // WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
    //await Utils().sendDebug(selectedNotificationPayload);
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification: (
            int id,
            String title,
            String body,
            String payload,
          ) async {
            didReceiveLocalNotificationSubject.add(
              ReceivedNotification(
                id: id,
                title: title,
                body: body,
                payload: payload,
              ),
            );
          });
  const MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: initializationSettingsMacOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });

  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.cubeGrid
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'nasancity',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      //builder: EasyLoading.init(),
      builder: EasyLoading.init(
        builder: (BuildContext context, Widget child) {
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(textScaleFactor: 1.0),
            child: child,
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";
  var _noti = FirebaseNotification();

  @override
  void initState() {
    _noti.init();

    message = "No message.";

    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {
      print("onDidReceiveLocalNotification called.");
    });
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) {
      // when user tap on notification.
      print("onSelectNotification called.");
      setState(() {
        message = payload;
      });
    });

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    super.initState();
    isUpDateApp();
    //isLogin();

    /* Timer(Duration(seconds: 2), () {
      _initPackageInfo();
    });*/
    // _initPackageInfo();
    //isUpDateApp();
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
    _ParamCheckAppData();
  }

  _ParamCheckAppData() async {
    Map _map = {};
    String platform;
    if (Platform.isIOS) {
      platform = "ios";
    } else {
      platform = "android";
    }

    _map.addAll({
      "platform": platform,
      "version": _packageInfo.version,
      //"version": "1.0.0",
    });

    print("_mapVersion" + _map.toString());

    var body = json.encode(_map);
    postCheckAppData(http.Client(), body, _map);
  }

  Future<List<AllList>> postCheckAppData(
    http.Client client,
    jsonMap,
    Map map,
  ) async {
    final response = await client.post(Uri.parse(Info().checkAppVersion),
        headers: {"Content-Type": "application/json"}, body: jsonMap);

    var data = json.decode(response.body);
    if (data["status"].toString() == "0") {
      checkAppVersion(data["msg"].toString(), data["url"].toString(),
          data["important"].toString());
    } else {
      isUpDateApp();
    }
  }

  Future<void> checkAppVersion(msg, url, important) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ตกลง'),
              onPressed: () {
                if (important == "1") {
                  _launchInBrowser(url);
                  Navigator.of(context).pop();
                } else {
                  isUpDateApp();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
      exit(0);
    } else {
      throw 'Could not launch $url';
    }
  }

  isUpDateApp() {
    Timer(
      Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => FrontPageView(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEB1717),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: WidhtDevice().widht(context),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg/splash.png"),
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
            ),
          ),
          // child: Column(
          //   children: [
          //     Expanded(
          //         flex: 2,
          //         child: Container(
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Container(
          //                 padding: EdgeInsets.all(20),
          //                 alignment: Alignment.bottomCenter,
          //                 child: Image.asset(
          //                   "assets/bg/splash2.png",
          //                   fit: BoxFit.fitWidth,
          //                 ),
          //               ),
          //               Padding(
          //                 padding: EdgeInsets.all(10),
          //               ),
          //               Container(
          //                 padding: EdgeInsets.all(10),
          //                 alignment: Alignment.bottomCenter,
          //                 child: Image.asset(
          //                   "assets/bg/splash1.png",
          //                   fit: BoxFit.fitWidth,
          //                 ),
          //               ),
          //               Padding(
          //                 padding: EdgeInsets.all(50),
          //               ),
          //             ],
          //           ),
          //         )),
          //     Expanded(
          //       flex: 1,
          //       child: Container(
          //         alignment: Alignment.bottomCenter,
          //         child: Image.asset(
          //           "assets/bg/splash3.png",
          //           fit: BoxFit.fitWidth,
          //         ),
          //       ),
          //     )
          //   ],
          // ),
        ),
      ),
    );

    // return SafeArea(
    //   child: Container(
    //     decoration: BoxDecoration(
    //       image: DecorationImage(
    //         image: AssetImage("assets/images/splash.png"),
    //         fit: BoxFit.fill,
    //       ),
    //     ),
    //   ),
    // );
  }
}
