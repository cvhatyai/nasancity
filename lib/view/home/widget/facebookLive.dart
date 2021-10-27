import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class FacebookLiveWidget extends StatefulWidget {
  const FacebookLiveWidget({Key key}) : super(key: key);

  @override
  _FacebookLiveWidgetState createState() => _FacebookLiveWidgetState();
}

class _FacebookLiveWidgetState extends State<FacebookLiveWidget> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  String liveEmbed = '';
  String liveLink = '';
  String liveDescription = '';
  bool isLoading = true;

  Future<void> getLive() async {
    setState(() {
      isLoading = true;
    });
    final http.Response response = await http.post(
      Uri.parse('https://cityvariety.co.th/facebook_live/cvtest'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'width': '480',
      }),
    );
    print("response : " + response.statusCode.toString());
    if (response.statusCode != 200) {
      setState(() {
        isLoading = false;
        liveLink = '';
      });
      return;
    }
    final List<dynamic> items = jsonDecode(response.body);
    if (items.length == 0) {
      setState(() {
        isLoading = false;
        liveLink = '';
      });
      return;
    }
    print(items[0]);
    final status = items[0]['status'];
    if (status != 'LIVE' && status != 'LIVE_NOW') {
      setState(() {
        isLoading = false;
        liveLink = '';
      });
      return;
    }
    setState(() {
      isLoading = false;
      liveEmbed = items[0]['embed_link'] + '&autoplay=true';
      print(liveEmbed);
      liveLink = 'https://www.facebook.com' + items[0]['permalink_url'];
      liveDescription = items[0]['description'] ?? '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLive();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (liveLink.isNotEmpty)
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/bg/no-live.png'),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                ),
                child: WebView(
                  initialUrl: liveEmbed,
                  javascriptMode: JavascriptMode.unrestricted,
                  initialMediaPlaybackPolicy:
                      AutoMediaPlaybackPolicy.always_allow,
                  allowsInlineMediaPlayback: true,
                )),
          ),
        if (liveLink.isEmpty)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg/no-live.png'),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
              ),
            ),
          )
        // Center(
        //   child: Padding(
        //     padding: const EdgeInsets.all(15.0),
        //     child: Text('no live'),
        //   ),
        // ),
      ],
    );
  }
}
