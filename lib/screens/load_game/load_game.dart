import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmath/bloc/singleplayer.dart';
import 'package:quickmath/helpers/constants.dart';
import 'package:quickmath/helpers/functions.dart';
import 'package:quickmath/screens/game/game.dart';

class LoadGame extends StatefulWidget {
  final int questions;
  LoadGame({this.questions});
  @override
  _LoadGameState createState() => _LoadGameState();
}

class _LoadGameState extends State<LoadGame> with AfterLayoutMixin<LoadGame> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void afterFirstLayout(BuildContext context) {
    Provider.of<SpBloc>(context, listen: false)
        .generateQuestions(widget.questions, onDone: () {
      Future.delayed(Duration(seconds: 2), () {
        replace(context, Game());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: bgColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: CupertinoActivityIndicator(radius: 16.0),
            ),
            SizedBox(height: 4),
            Center(
                child:
                    Text('Loading...', style: TextStyle(fontFamily: fontThree)))
          ],
        ));
  }
}
