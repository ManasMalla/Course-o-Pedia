import 'package:flutter/material.dart';

class SizeProvider {
  static late double heightFactor;
  static late double widthFactor;
  static late Orientation orientation;
  void init(BuildContext context) {
    MediaQueryData _queryData = MediaQuery.of(context);
    orientation = _queryData.orientation;
    Size _size = _queryData.size;
    heightFactor = _size.height / 1534;
    widthFactor = _size.width / 738;
  }
}

double getProportionalScreenHeight(double height) {
  return height * SizeProvider.heightFactor;
}

double getProportionalScreenWidth(double width) {
  return width * SizeProvider.widthFactor;
}
