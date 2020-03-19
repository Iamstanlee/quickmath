import 'package:flutter/material.dart';
import 'package:quickmath/helpers/constants.dart';
import 'package:quickmath/helpers/functions.dart';
import 'package:quickmath/screens/select_game/select_game.dart';
import 'package:quickmath/widgets/drawer.dart';
import 'package:quickmath/widgets/fancy_button.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: bgColor,
        drawer: SizedBox(
          width: getWidth(context, width: 72),
          child: DrawerWidget(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 10),
              child: Row(
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        scaffoldKey.currentState.openDrawer();
                      },
                      child: CircleAvatar()),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Dev Stanlee',
                        style: TextStyle(
                            fontFamily: fontThree,
                            fontWeight: FontWeight.w600)),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 27.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FancyButton(
                        child: Center(
                          child: Text(
                            'Play Now',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: fontThree,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        onPressed: () {
                          push(context, SelectGame());
                        },
                        color: Colors.orangeAccent,
                        size: 38,
                      ),
                      SizedBox(height: 16.0),
                      OutlineButton.icon(
                        highlightedBorderColor: Colors.white10,
                        highlightColor: Colors.white10,
                        icon: loadPng('trophy', height: 28),
                        onPressed: () {},
                        padding: EdgeInsets.symmetric(
                            horizontal: 27.0, vertical: 16),
                        label: Text('Leadership Board',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: fontThree,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }
}
