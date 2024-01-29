import 'package:flutter/material.dart';

abstract class Gap {
  static SizedBox width(double width) {
    return SizedBox(width: width);
  }

  static SizedBox height(double height) {
    return SizedBox(height: height);
  }
}
