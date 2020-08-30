import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmath/bloc/singleplayer.dart';
import 'package:quickmath/helpers/constants.dart';
import 'package:quickmath/helpers/functions.dart';
import 'package:quickmath/screens/game/game.dart';
import 'package:quickmath/screens/game/multiplayer_game/multiplayer_game.dart';

class LoadGame extends StatefulWidget {
  final int questions;
  final String gameType;
  LoadGame({this.questions, this.gameType = 'SP'});
  @override
  _LoadGameState createState() => _LoadGameState();
}

class _LoadGameState extends State<LoadGame> with AfterLayoutMixin<LoadGame> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void afterFirstLayout(BuildContext context) {
    if (widget.gameType == 'MP') {
//isLoaded:false -> isLoaded:true
      Provider.of<SpBloc>(context, listen: false)
          .generateQuestions(widget.questions, onDone: () {
        Future.delayed(Duration(seconds: 1), () {
          replace(context, MultiPlayerGame());
        });
      });
    } else {
      Provider.of<SpBloc>(context, listen: false)
          .generateQuestions(widget.questions, onDone: () {
        Future.delayed(Duration(seconds: 1), () {
          replace(context, Game());
        });
      });
    }
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
