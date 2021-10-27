import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nasancity/view/FrontPageView.dart';

import '../main.dart';

String channelId = "1000";
String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

class FirebaseNotification {
  FirebaseMessaging _firebaseMessaging;

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

  init() {
    _firebaseMessaging = FirebaseMessaging();

    if (Platform.isIOS) {
      _firebaseMessaging.subscribeToTopic("th.go.nasancity.app");
    } else {
      _firebaseMessaging.subscribeToTopic("th.go.nasancity");
    }

    _firebaseMessaging.subscribeToTopic("news");

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("wittawat onMessage: $message");
        String title = "";
        String body = "";
        if (message != null) {
          if (message["data"] != null) {
            /*Map mapNotification = message["notification"];
          title = mapNotification["title"];
          body = mapNotification["body"];*/
            Map data = message["data"];
            title = data["subject"];
            body = data["descripiton"];
          } else {
            body = message["subject"];
          }
          await sendNotification(title: title, body: body, data: "");
        }
        //_showItemDialog(message);
      },
      onBackgroundMessage:
          Platform.isAndroid ? myBackgroundMessageHandler : null,
      onLaunch: (Map<String, dynamic> message) async {
        print("wittawat onLaunch: $message");

        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("wittawat onResume: $message");

        //_navigateToItemDetail(message);
      },
    );
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print("wittawat fms data");
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print("wittawat fms notification");
    }
    // Or do other work.
  }

  sendNotification({String title, String body, String data}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId, channelName, channelDescription,
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: "xxxsss");
    print('sendNotification Success ✅✅');
  }
}
