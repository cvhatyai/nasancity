import 'package:flutter/material.dart';
import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/system/widht_device.dart';
import 'package:nasancity/view/home/widget/facebookLive.dart';

class Facebook_block extends StatefulWidget {
  const Facebook_block({Key key}) : super(key: key);

  @override
  _Facebook_blockState createState() => _Facebook_blockState();
}

class _Facebook_blockState extends State<Facebook_block> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: WidhtDevice().widht(context) >= 768
          ? MediaQuery.of(context).size.width / 2.2
          : MediaQuery.of(context).size.width,
      height: 260,
      // margin: EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
        color: Color(0xFF0075CC),
        image: DecorationImage(
          alignment: Alignment.topCenter,
          image: AssetImage('assets/bg/bg-fblive.png'),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(13),
            height: 70,
            decoration: BoxDecoration(
              color: Color(0xFFEB1717),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              ),
            ),
            child: Text(
              'วิทยุออนไลน์',
              style: TextStyle(
                fontFamily: FontStyles.FontFamily,
                fontSize: 21,
                color: Colors.white,
              ),
            ),
          ),
          Positioned.fill(
            top: 40,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                child: FacebookLiveWidget(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
