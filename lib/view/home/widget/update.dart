import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/view/home/widget/banner.dart';
import 'package:flutter/material.dart';

class UpdateWidget extends StatelessWidget {
  const UpdateWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'บ้านเชี่ยวหลาน',
                    style: TextStyle(
                        fontFamily: FontStyles.FontFamily,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  Text('อัพเดท',
                      style: TextStyle(
                          fontFamily: FontStyles.FontFamily,
                          fontSize: 20,
                          color: Color(0xFFE6FF00)))
                ],
              ),
            ),
            BannerWidget(),
            Padding(
              padding: EdgeInsets.all(5),
            ),
          ],
        ),
      ),
    );
  }
}
