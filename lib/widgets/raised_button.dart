import 'package:flutter/material.dart';
import 'package:quickmath/helpers/constants.dart';

Widget raisedButton(Function onPressed, String child,
    {Color color = Colors.blue, double horizontalPadding = 0.0}) {
  return FlatButton(
    onPressed: onPressed,
    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    color: color,
    child: Text(child,
        style: TextStyle(
            fontFamily: fontThree,
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600)),
    padding:
        EdgeInsets.symmetric(vertical: 14.0, horizontal: horizontalPadding),
  );
}
