import 'package:flutter/material.dart';
import 'package:quickmath/helpers/constants.dart';
import 'package:quickmath/helpers/functions.dart';

enum AppbarType { WithBackButton, Regular }

class AppbarWidget extends StatefulWidget {
  final AppbarType appbarType;
  final String label;
  final Widget action;
  AppbarWidget({this.appbarType, this.action, this.label});
  @override
  _AppbarWidgetState createState() => _AppbarWidgetState();
}

class _AppbarWidgetState extends State<AppbarWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.appbarType) {
      case AppbarType.WithBackButton:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        pop(context);
                      },
                      child: loadPng('arrowBack', height: 28)),
                  Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text('${widget.label ?? ''}',
                        style: TextStyle(
                            fontFamily: fontThree,
                            fontWeight: FontWeight.w600)),
                  )
                ],
              ),
            ),
          ],
        );
        break;
      case AppbarType.Regular:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      InkWell(onTap: () {}, child: CircleAvatar()),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('Dev Stanlee',
                            style: TextStyle(
                                fontFamily: fontThree,
                                fontWeight: FontWeight.w600)),
                      )
                    ],
                  ),
                  widget.action ?? Container()
                ],
              ),
            ),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        pop(context);
                      },
                      child: loadPng('arrowBack', height: 28)),
                  Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text('${widget.label ?? ''}',
                        style: TextStyle(
                            fontFamily: fontThree,
                            fontWeight: FontWeight.w600)),
                  )
                ],
              ),
            ),
          ],
        );
    }
  }
}
