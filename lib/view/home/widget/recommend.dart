import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/system/widht_device.dart';
import 'package:nasancity/view/travel/TravelListView.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecommendWidget extends StatefulWidget {
  const RecommendWidget({Key key}) : super(key: key);

  @override
  _RecommendWidgetState createState() => _RecommendWidgetState();
}

class _RecommendWidgetState extends State<RecommendWidget> {
  List<String> arrFav = [];
  var favCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFav();
    // _initPackageInfo();
  }

  initFav() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // arrFav = prefs.getStringList("favList");
    setState(() {
      if (arrFav != null) {
        favCount = arrFav.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 3),
                  padding:
                      EdgeInsets.only(top: 1, bottom: 1, left: 7, right: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFF5C500).withOpacity(0.8),
                  ),
                  child: Text(
                    'แนะนำสำหรับคุณ',
                    style: TextStyle(
                        fontFamily: FontStyles.FontFamily, fontSize: 13),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Row(children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TravelListView(
                        isHaveArrow: "1",
                        title: "ที่เที่ยว",
                        tid: "1",
                      ),
                    ),
                  ).then((value) {
                    setState(() {
                      initFav();
                    });
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  width: WidhtDevice().widht(context) / 3,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/item/suggest.png"),
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Image.asset(
                          'assets/item/passenger.png',
                          fit: BoxFit.fitWidth,
                          width: (WidhtDevice().widht(context) / 3) * 0.4,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          'ที่เที่ยว',
                          style: TextStyle(
                              fontFamily: FontStyles.FontFamily,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TravelListView(
                        isHaveArrow: "1",
                        title: "ที่กิน",
                        tid: "3",
                      ),
                    ),
                  ).then((value) {
                    setState(() {
                      initFav();
                    });
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  width: WidhtDevice().widht(context) / 3,
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/item/suggest.png"),
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Image.asset(
                          'assets/item/food.png',
                          fit: BoxFit.fitWidth,
                          width: (WidhtDevice().widht(context) / 3) * 0.4,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          'ที่กิน',
                          style: TextStyle(
                              fontFamily: FontStyles.FontFamily,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TravelListView(
                        isHaveArrow: "1",
                        title: "ที่พัก",
                        tid: "2",
                      ),
                    ),
                  ).then((value) {
                    setState(() {
                      initFav();
                    });
                  });
                },
                child: Container(
                  width: WidhtDevice().widht(context) / 3,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/item/suggest.png"),
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 35,
                        ),
                        Image.asset(
                          'assets/item/hotel_1.png',
                          fit: BoxFit.cover,
                          width: (WidhtDevice().widht(context) / 3) * 0.4,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'ที่พัก',
                          style: TextStyle(
                              fontFamily: FontStyles.FontFamily,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
