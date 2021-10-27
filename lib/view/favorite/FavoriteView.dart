import 'dart:convert';

import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/view/PageSubView.dart';
import 'package:flutter/material.dart';

import '../AppBarView.dart';
import 'CallFavListView.dart';
import 'MarketFavListView.dart';
import 'TravelFavListView.dart';

class FavoriteView extends StatefulWidget {
  FavoriteView({Key key, this.isHaveArrow = ""}) : super(key: key);
  final String isHaveArrow;

  @override
  _FavoriteViewState createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  int currentTab = 0;
  final List<Widget> myPage = <Widget>[
    TravelFavListView(),
    CallFavListView(),
    MarketFavListView(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: PageSubView(
        title: "รายการโปรด",
        isHaveArrow: widget.isHaveArrow,
        widget: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                  // bottomRight: Radius.circular(20.0),
                  // bottomLeft: Radius.circular(20.0),
                ),
              ),
              child: TabBar(
                onTap: (index) {
                  print(index.toString());
                  setState(() {
                    currentTab = index;
                  });
                },
                tabs: [
                  Center(
                    child: Container(
                      child: Text(
                        "กิจกรรม/สถานที่/สินค้า",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: FontStyles.FontFamily,
                          fontWeight: (currentTab == 0)
                              ? FontWeight.w500
                              : FontWeight.w300,
                          color: (currentTab == 0) ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "หมายเลขโทรศัพท์",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: FontStyles.FontFamily,
                        fontWeight: (currentTab == 1)
                            ? FontWeight.w500
                            : FontWeight.w300,
                        color: (currentTab == 1) ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "ตลาดสีเขียว",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: FontStyles.FontFamily,
                        fontWeight: (currentTab == 2)
                            ? FontWeight.w500
                            : FontWeight.w300,
                        color: (currentTab == 2) ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: myPage.map((Widget widget) {
                  return widget;
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
