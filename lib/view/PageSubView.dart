import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/system/widht_device.dart';
import 'package:flutter/material.dart';

class PageSubView extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String isHaveArrow;
  final Widget widget;

  PageSubView({
    Key key,
    this.title = "",
    this.isHaveArrow = "",
    this.widget,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  _PageSubViewState createState() => _PageSubViewState();
}

class _PageSubViewState extends State<PageSubView> {
  leading() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF284A64),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
      ),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  double height = AppBar().preferredSize.height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEB1717),
      child: SafeArea(
        child: Center(
          child: Container(
            color: Colors.white,
            width: WidhtDevice().widht(context),
            height: MediaQuery.of(context).size.height,
            child: Scaffold(
              backgroundColor: Colors.white.withOpacity(0),
              appBar: AppBar(
                leading: (widget.isHaveArrow == "") ? Container() : leading(),
                backgroundColor: Color(0xFFEB1717),
                title: Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: FontStyles.FontFamily),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                elevation: 0,
                centerTitle: true,
              ),
              body: Container(
                height: MediaQuery.of(context).size.height - height,
                child: widget.widget,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
