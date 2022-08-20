import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nasancity/system/Info.dart';
import 'package:nasancity/view/PageSubView.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../AppBarView.dart';

class PrivacyPolicyContentView extends StatefulWidget {
  const PrivacyPolicyContentView({Key key, this.isHaveArrow = ""}) : super(key: key);
  final String isHaveArrow;

  @override
  _PrivacyPolicyContentViewState createState() => _PrivacyPolicyContentViewState();
}

class _PrivacyPolicyContentViewState extends State<PrivacyPolicyContentView> {

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return PageSubView(
        title: 'นโยบายความเป็นส่วนตัว',
        isHaveArrow: widget.isHaveArrow,
      widget: Container(
        color: Color(0xFFFFFFFF),
        padding: EdgeInsets.only(left: 8, right: 8),
        child: WebView(
          initialUrl: Info().contentPrivacyPolicy,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
