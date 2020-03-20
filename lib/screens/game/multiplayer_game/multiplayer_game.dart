import 'package:flutter/material.dart';
import 'package:quickmath/helpers/constants.dart';
import 'package:quickmath/helpers/functions.dart';
import 'package:quickmath/screens/game/multiplayer_game/game_room.dart';
import 'package:quickmath/screens/home/home.dart';
import 'package:quickmath/screens/select_game/select_game.dart';

class MultiPlayerGame extends StatefulWidget {
  @override
  _MultiPlayerGameState createState() => _MultiPlayerGameState();
}

class _MultiPlayerGameState extends State<MultiPlayerGame> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // pushToDispose(context, SelectGame(), predicate: SelectGame());
        return true;
      },
      child: Scaffold(
        body: Center(
          child: Text('SOS:: WORK IN PROGRESS... 🏃‍',
              style: TextStyle(
                  fontFamily: fontThree, color: Colors.black, fontSize: 16)),
        ),
      ),
    );
  }
}
