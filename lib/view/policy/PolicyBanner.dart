import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nasancity/model/user.dart';
import 'package:nasancity/system/Info.dart';

import 'PolicyContentView.dart';

class PrivacyPolicyBanner extends StatefulWidget {
  const PrivacyPolicyBanner({Key key}) : super(key: key);

  @override
  _PrivacyPolicyBannerState createState() => _PrivacyPolicyBannerState();
}

class _PrivacyPolicyBannerState extends State<PrivacyPolicyBanner> {
  bool acceptPolicy;

  @override
  void initState() {
    super.initState();
    getAcceptPrivacyPolicy().then((value) => setState(() {
          acceptPolicy = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (acceptPolicy == null || acceptPolicy) {
      return Container();
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
            color: Color(0xe66e6e6e),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            )),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                text: 'ฉันได้อ่าน ',
                style: TextStyle(fontSize: 16, color: Colors.white),
                children: [
                  TextSpan(
                    text: 'นโยบายความเป็นส่วนตัว',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrivacyPolicyContentView(isHaveArrow: "1"),
                          ),
                        );
                      },
                  ),
                  const TextSpan(
                    text: ' โดยละเอียดเรียบร้อยแล้ว และยอมรับตามเงื่อนไขทั้งหมด',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                acceptPolicy = await setAcceptPrivacyPolicy();
                setState(() {
                  // rebuild
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: const Text('ยอมรับ'),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> getAcceptPrivacyPolicy() async {
  final user = User();
  await user.init();
  final http.Response response = await http.post(
    Uri.parse(Info().getAcceptPrivacyPolicy),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(<String, String>{
      'uid': user.uid,
    }),
  );

  if (response.statusCode != 200) {
    return null;
  }

  final data = json.decode(response.body);
  return data['status'] == 'success';
}

Future<bool> setAcceptPrivacyPolicy() async {
  final user = User();
  await user.init();
  final http.Response response = await http.post(
    Uri.parse(Info().setAcceptPrivacyPolicy),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(<String, String>{
      'uid': user.uid,
    }),
  );

  if (response.statusCode != 200) {
    return false;
  }

  final data = json.decode(response.body);
  return data['status'] == 'success';
}
