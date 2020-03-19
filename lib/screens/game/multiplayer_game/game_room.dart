import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmath/bloc/multiplayer.dart';
import 'package:quickmath/helpers/constants.dart';
import 'package:quickmath/widgets/appbar.dart';

class GameRoom extends StatefulWidget {
  @override
  _GameRoomState createState() => _GameRoomState();
}

class _GameRoomState extends State<GameRoom> {
  @override
  Widget build(BuildContext context) {
    MpBloc mpBloc = Provider.of<MpBloc>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AppbarWidget(label: 'GAME ROOM'),
          Center(
            child: Text('GAME ROOM',
                style: TextStyle(
                    fontFamily: fontThree, color: Colors.black, fontSize: 12)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: 8,
                  width: 8,
                  color: mpBloc.onlineStatus ? Colors.green : Colors.red),
              SizedBox(width: 8),
              Text(mpBloc.onlineStatus ? 'ONLINE' : 'OFFLINE',
                  style: TextStyle(
                      fontFamily: fontThree, color: Colors.black, fontSize: 12))
            ],
          )
        ],
      ),
    );
  }
}
