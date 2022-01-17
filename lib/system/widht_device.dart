import 'package:flutter/material.dart';

class WidhtDevice {
  widht(BuildContext context) {
    double widht = MediaQuery.of(context).size.width;
    // print(widht);
    String device = "mobile";
    if (widht >= 1600) {
      device = "xl";
    } else if (widht >= 1360) {
      device = "x";
    } else if (widht >= 1020) {
      device = "l";
    } else if (widht >= 768) {
      device = "m";
    } else {
      device = "s";
    }
    return widht;
  }

  size(BuildContext context) {
    double widht = MediaQuery.of(context).size.width;
    // print(widht);
    String device = "mobile";
    if (widht >= 1600) {
      widht = widht / 4;
      device = "xl";
    } else if (widht >= 1360) {
      widht = widht / 3;
      device = "x";
    } else if (widht >= 1020) {
      widht = widht / 2.5;
      device = "l";
    } else if (widht >= 768) {
      device = "m";
    } else {
      device = "s";
    }
    return device;
  }
}
