import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nasancity/style/font_style.dart';
import 'package:nasancity/system/Info.dart';
import 'package:http/http.dart' as http;

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({Key key}) : super(key: key);

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setWeather();
  }

  //weather
  var iconWeather = "";
  var tempWeather = "";
  var textWeather = "";

  setWeather() async {
    Map _map = {};
    _map.addAll({});
    var body = json.encode(_map);
    return postSiteDetail(http.Client(), body, _map);
  }

  postSiteDetail(http.Client client, var jsonMap, Map map) async {
    final response = await client.post(Uri.parse(Info().weatherApi),
        headers: {"Content-Type": "application/json"}, body: jsonMap);
    var rs = json.decode(response.body);
    setState(() {
      iconWeather = rs["icon"].toString();
      tempWeather = rs["temp"].toString();
      textWeather = rs["description"].toString();
    });
    // return rs;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: Row(
            children: [
              if (iconWeather != "")
                Image.network(
                  iconWeather,
                  height: 36,
                ),
              Text(
                "$tempWeather°",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: FontStyles.FontFamily,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Container(
          child: Text(
            textWeather,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 12,
        ),
      ],
    );
  }
}
