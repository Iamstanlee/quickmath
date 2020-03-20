import 'dart:math';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// return a random a from range 0 to [max] params
int getRandomInt(int max) {
  return new Random().nextInt(max);
}

/// return the int value of a String
int parseInt(String integer) {
  return int.parse(integer);
}

/// return the float value of a String
double parseDouble(String float) {
  return double.parse(float);
}

String getReference() {
  String timestamp = DateTime.now().toString().split('.').last;
  return '#' + timestamp;
}

// 0 - 200 - 500 - 900 - 1200
String getRankBadge(String rank) {
  String badge;
  switch (rank) {
    case 'Novice':
      break;
    case 'Veteran':
      break;
    case 'Pro':
      break;
    case 'Master':
      break;
    case 'Legendary':
      break;
    default:
  }
  return badge;
}

/// takes a percentage of the screens width and return a double of current width
double getWidth(context, {width}) {
  if (width == null) return MediaQuery.of(context).size.width;
  return ((width / 100) * MediaQuery.of(context).size.width);
}

/// takes a percentage of the screens height and return a double of screen height.
double getHeight(context, {height}) {
  if (height == null) return MediaQuery.of(context).size.height;
  return ((height / 100) * MediaQuery.of(context).size.height);
}

String getImage(String image) {
  return 'assets/res/$image';
}

Widget loadImage(String image) {
  return Image.asset(getImage(image));
}

Widget loadPng(String image, {double width, double height}) {
  return Image.asset(
    getPng(image),
    width: width,
    height: height,
  );
}

String getPng(String png) {
  return 'assets/res/$png.png';
}

void afterFirstLayout(BuildContext context) {}

String formatDate(DateTime date) {
  return new DateFormat.jm().format(date);
}

void scrollToBottom(ScrollController controller) {
  controller.animateTo(controller.position.maxScrollExtent + 100,
      curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
}

class GameScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

Color hslRelativeColor(
    {h = 0.0, s = 0.0, l = 0.0, Color color = Colors.orangeAccent}) {
  final hslColor = HSLColor.fromColor(color);
  h = (hslColor.hue + h).clamp(0.0, 360.0);
  s = (hslColor.saturation + s).clamp(0.0, 1.0);
  l = (hslColor.lightness + l).clamp(0.0, 1.0);
  return HSLColor.fromAHSL(hslColor.alpha, h, s, l).toColor();
}

/// Navigate to a new route by passing a route widget
void push(context, Widget to) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => to));
}

/// replace the current widget with a new route by passing a route widget
void replace(context, Widget to) {
  Navigator.pushReplacement(
      context, CupertinoPageRoute(builder: (context) => to));
}

/// go back to the previous route
void pop(context, {dynamic result}) {
  Navigator.of(context).pop(result);
}

///returns ads unit for admob
String getBannerAdUnitId() {
  return 'ca-app-pub-3940256099942544/6300978111';
}

/// Navigate to a new route by passing a route widget
///  and dispose the previous routes
void pushToDispose(context, to, {Widget predicate}) {
  Navigator.pushAndRemoveUntil(
      context, CupertinoPageRoute(builder: (context) => to), (route) {
    if (predicate != null) if (route ==
        CupertinoPageRoute(builder: (context) => predicate)) return true;
    return false;
  });
}

/// Show snack bar from anywhere in the by passing a global key of type scffold state and the string to be displayed
showSnackBar(GlobalKey<ScaffoldState> _scaffoldState, String content) {
  if (content == null) return;
  if (_scaffoldState.currentState == null) return;
  _scaffoldState.currentState.showSnackBar(SnackBar(
    content: Text(
      content,
      style: TextStyle()
          .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
    ),
    backgroundColor: Colors.black,
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 1),
  ));
}

/// Hide snack bar from anywhere in the by passing a global key of type scaffold state
hideSnackBar(GlobalKey<ScaffoldState> _scaffoldState) {
  _scaffoldState.currentState.hideCurrentSnackBar();
}
