import 'package:nasancity/style/font_style.dart';
import 'package:flutter/material.dart';

class MenuStyle {
  TextStyle txtcontact = TextStyle(
    fontSize: 12,
    color: Colors.white,
    height: 1,
  );
  TextStyle txttopic = TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontFamily: FontStyles.FontFamily,
    height: 1,
  );
  BoxDecoration themeTopic = BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      color: Color(0xFFEB1717));
}
