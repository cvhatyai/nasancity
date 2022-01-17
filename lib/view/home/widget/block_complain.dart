import 'package:flutter/material.dart';
import 'package:nasancity/model/user.dart';
import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/system/widht_device.dart';
import 'package:nasancity/view/complain/FollowComplainListView.dart';
import 'package:nasancity/view/home/widget/complaint.dart';
import 'package:nasancity/view/login/LoginView.dart';

class BlockComplaint extends StatefulWidget {
  const BlockComplaint({Key key}) : super(key: key);

  @override
  _BlockComplaintState createState() => _BlockComplaintState();
}

class _BlockComplaintState extends State<BlockComplaint> {
  var user = User();
  bool isLogin = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: WidhtDevice().widht(context) >= 768
          ? MediaQuery.of(context).size.width / 1.85
          : MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
            height: 270,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(top: 10, left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ร้องเรียน',
                          style: TextStyle(
                              fontFamily: FontStyles.FontFamily,
                              color: Color(0xFFEB1717),
                              fontSize: 20),
                        ),
                        Text(
                          '    ร้องทุกข์',
                          style: TextStyle(
                              fontFamily: FontStyles.FontFamily,
                              color: Color(0xFF0075CC),
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(top: 3),
                    decoration: BoxDecoration(
                      color: Color(0xFFEB1717),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                      ),
                    ),
                    child: ComplaintWidget(),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              // color: Colors.amber,
              child: Image.asset(
                'assets/bg/bg-woman.png',
                height: 150,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                if (!isLogin) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginView(
                        isHaveArrow: "1",
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowComplainListView(
                        isHaveArrow: "1",
                      ),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 5,
                  top: 5,
                  bottom: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '  ติดตามเรื่องร้องเรียน  ',
                      style: TextStyle(
                        fontFamily: FontStyles.FontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFFEB1717),
                      size: 16,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
