import 'package:nasancity/style/font_style.dart';
import 'package:flutter/material.dart';

class DevelopBlank {
  static Widget show() {
    return Center(
      child: Column(
        children: [
          Container(
            child: Image.asset('assets/images/other/development.png'),
          ),
          Text(
            '... อยู่ระหว่างการพัฒนา ...',
            style: TextStyle(fontFamily: FontStyles.FontFamily, fontSize: 30),
          )
        ],
      ),
    );
  }
}
