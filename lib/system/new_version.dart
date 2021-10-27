// import 'package:nasancity/style/font_style.dart';
// import 'package:flutter/material.dart';
// import 'package:new_version/new_version.dart';
// import 'package:url_launcher/url_launcher.dart';

// final newVersion = NewVersion(
//   iOSId: 'th.go.nasancity',
//   androidId: 'th.go.nasancity',
// );

// class CheckNewVersion {
//   static alertCheck(BuildContext context) async {
//     final status = await newVersion.getVersionStatus();
//     print("======= UPDATE APP =========start");
//     // debugPrint("Notes : " + status.releaseNotes.);
//     debugPrint("Link : " + status.appStoreLink);
//     debugPrint("LocalVersion : " + status.localVersion);
//     debugPrint("StoreVersion : " + status.storeVersion);
//     print("======= UPDATE APP =========end");
//     //----
//     List _local = status.localVersion.split('.');
//     double local = double.parse(_local[0] + '.' + _local[1] + _local[2]);
//     List _store = status.storeVersion.split('.');
//     double store = double.parse(_store[0] + '.' + _store[1] + _store[2]);
//     //----
//     if (local < store) {
//       debugPrint("New Update");
//       showDialog<String>(
//           barrierDismissible: false,
//           context: context,
//           builder: (BuildContext context) {
//             return WillPopScope(
//               onWillPop: () async => false,
//               child: AlertDialog(
//                 title: Text(
//                   'อัพเดทพร้อมใช้งาน',
//                   style: TextStyle(
//                       fontFamily: FontStyles().FontFamily, fontSize: 26),
//                 ),
//                 content: Text(
//                   'ตอนนี้คุณสามารถอัปเดตแอพนี้จาก ' +
//                       status.localVersion +
//                       ' เป็น ' +
//                       status.storeVersion +
//                       '',
//                   style: TextStyle(
//                       fontFamily: FontStyles.FontFamily,
//                       fontSize: 22,
//                       height: 1),
//                 ),
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () async {
//                       await launch(status.appStoreLink);
//                     },
//                     child: Text(
//                       'อัพเดทเดี๋ยวนี้',
//                       style: TextStyle(
//                           fontFamily: FontStyles.FontFamily, fontSize: 22),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           });
//       // newVersion.showUpdateDialog(
//       //   context: context,
//       //   versionStatus: status,
//       //   dialogTitle: 'อัพเดทพร้อมใช้งาน',
//       // dialogText: 'ตอนนี้คุณสามารถอัปเดตแอพนี้จาก ' +
//       //     status.localVersion +
//       //     ' เป็น ' +
//       //     status.storeVersion,
//       // );
//     } else {
//       debugPrint("Last Version");
//     }
//   }
// }
