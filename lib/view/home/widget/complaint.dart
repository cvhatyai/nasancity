import 'dart:convert';

import 'package:nasancity/model/AllList.dart';
import 'package:nasancity/model/user.dart';
import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/system/Info.dart';
import 'package:nasancity/view/complain/ComplainCateListView.dart';
import 'package:nasancity/view/complain/ComplainFormView.dart';
import 'package:nasancity/view/login/LoginView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:nasancity/system/widht_device.dart';

class ComplaintWidget extends StatefulWidget {
  const ComplaintWidget({Key key}) : super(key: key);

  @override
  _ComplaintWidgetState createState() => _ComplaintWidgetState();
}

var data;

class _ComplaintWidgetState extends State<ComplaintWidget> {
  List<String> list = [];
  int perPageItem = 6;
  int pageCount = 0;
  int selectedIndex = 0;
  int lastPageItemLength = 0;
  PageController pageController = PageController();
  //--
  bool isLogin = false;
  var user = User();
  //--

  getUsers() async {
    await user.init();
    setState(() {
      isLogin = user.isLogin;
    });
  }

  //----
  getNewsList() async {
    Map _map = {};
    _map.addAll({});

    EasyLoading.show(status: 'loading...');
    print("_map : " + _map.toString());
    var body = json.encode(_map);
    return postNewsList(http.Client(), body, _map);
  }

  Future<List<AllList>> postNewsList(
      http.Client client, jsonMap, Map map) async {
    final response = await client.post(Uri.parse(Info().cateInformList),
        headers: {"Content-Type": "application/json"}, body: jsonMap);
    await parseNewsList(response.body);
    _subPage();
  }

  List<AllList> parseNewsList(String responseBody) {
    data = [];
    data.addAll(json.decode(responseBody));

    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    parsed.map<AllList>((json) => AllList.fromJson(json)).toList();
    setState(() {});
    EasyLoading.dismiss();
  }
  //-----

  _subPage() {
    pageController = PageController(initialPage: 0);
    print("count com = " + data.length.toString());
    for (int i = 1; i <= data.length; i++) {
      list.add('$i');
    }
    var num = (data.length / perPageItem);
    pageCount =
        (data.length % perPageItem) == 0 ? num.toInt() : num.toInt() + 1;

    var reminder = list.length.remainder(perPageItem);
    lastPageItemLength = reminder == 0 ? perPageItem : reminder;
  }

  @override
  void initState() {
    getNewsList();
    getUsers();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/

    final double itemWidth = size.width / 2;
    final double itemHeight = WidhtDevice().widht(context) >= 1024 ?itemWidth * 2 :itemWidth * 3;
    return Container(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: WidhtDevice().widht(context) >= 1024 ?2 / 1 :2 / 1.5,
            child: PageView.builder(
              controller: pageController,
              itemCount: pageCount,
              onPageChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              itemBuilder: (_, pageIndex) {
                return GridView.count(
                  childAspectRatio: WidhtDevice().widht(context) >= 1024 ?2 / 1.6 : 2 / 2.3,
                  physics: NeverScrollableScrollPhysics(),
                  // padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  primary: false,
                  // childAspectRatio: 1.1,
                  shrinkWrap: true,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  crossAxisCount: 3,
                  children: List.generate(
                    (pageCount - 1) != pageIndex
                        ? perPageItem
                        : lastPageItemLength,
                    (index) {
                      return GestureDetector(
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
                                builder: (context) => ComplainFormView(
                                  topicID:
                                      data[index + (pageIndex * perPageItem)]
                                              ["id"]
                                          .toString(),
                                  subjectTitle:
                                      data[index + (pageIndex * perPageItem)]
                                          ["subject"],
                                  displayImage:
                                      data[index + (pageIndex * perPageItem)]
                                          ["display_image"],
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          // width: 50,
                          margin: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(20),
                                    shape: BoxShape.circle,
                                    color: Color(0xFFF5F6FA),
                                    border: Border.all(
                                      width: 3,
                                      color: Color(0xFFDADADA),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Image.network(
                                    data[index + (pageIndex * perPageItem)]
                                        ['display_image'],
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(2)),
                              Container(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                    data[index + (pageIndex * perPageItem)]
                                        ['subject'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: FontStyles.FontFamily,
                                        fontWeight: FontWeight.w300,
                                        height: 1),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height:WidhtDevice().widht(context) >= 1024 ? 20 : 15,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: pageCount,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        pageController.animateToPage(index,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: selectedIndex == index
                                ? Color(0xFFF5C500)
                                : Color(0xFFBFBFBF)),
                        margin: EdgeInsets.all(5),
                        width: selectedIndex == index ? 20 : 10,
                        height: 10,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
