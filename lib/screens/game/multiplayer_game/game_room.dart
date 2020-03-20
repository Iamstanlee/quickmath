import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmath/bloc/multiplayer.dart';
import 'package:quickmath/data/user.dart';
import 'package:quickmath/helpers/constants.dart';
import 'package:quickmath/helpers/functions.dart';
import 'package:quickmath/screens/game/game.dart';
import 'package:quickmath/screens/load_game/load_game.dart';
import 'package:quickmath/widgets/appbar.dart';
import 'package:quickmath/widgets/raised_button.dart';
import 'package:quickmath/widgets/toast.dart';

class GameRoom extends StatefulWidget {
  @override
  _GameRoomState createState() => _GameRoomState();
}

class _GameRoomState extends State<GameRoom> with AfterLayoutMixin<GameRoom> {
  int qsLength = 0, totalPlayers = 0;
  @override
  void afterFirstLayout(BuildContext context) {
    MpBloc mpBloc = Provider.of<MpBloc>(context, listen: false);
    mpBloc.getOnlinePresence();
    Stream<DocumentSnapshot> gameStream = mpBloc.onlineInGameStream();
    gameStream.listen((ds) {
      setState(() {
        qsLength = ds.data['qsLength'];
        totalPlayers = ds.data['players'].length;
      });
      if (ds.data['isActive'] == true)
        replace(context, LoadGame(questions: qsLength, gameType: 'MP'));
    }, onError: (err) {
      print('** ERROR => $err**');
    });
  }

  @override
  Widget build(BuildContext context) {
    MpBloc mpBloc = Provider.of<MpBloc>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppbarWidget(label: 'GAME ROOM'),
          buildModerator(
              update:
                  'Game Details \n Total questions: $qsLength \n Current number of players: $totalPlayers'),
          SizedBox(height: 16),
          Expanded(
            child: StreamBuilder(
              stream: mpBloc.onlineInGameStream(),
              builder: (context, documentSnapshot) {
                if (documentSnapshot.hasData) {
                  List<User> players =
                      documentSnapshot.data['players'].map<User>((user) {
                    return User.fromMap(user);
                  }).toList();
                  return ListView.builder(
                    itemCount: players.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, int i) {
                      return buildPlayer(
                          status: players[i].online,
                          username: players[i].username,
                          rank: players[i].rank);
                    },
                  );
                } else if (documentSnapshot.hasError) {
                  return Center(
                    child: Text('** Error Getting Players **',
                        style: TextStyle(
                            fontFamily: fontThree,
                            color: Colors.black,
                            fontSize: 12)),
                  );
                }
                return Container();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
            child: raisedButton(() async {
              Toast.show('Please Wait...', context,
                  isTimed: false, gravity: Toast.TOP);
              // check if the current user is the game creator
              // if true then set [isActive] to true to
              // move all users to the loadGame screen
              MpBloc mpBloc = Provider.of<MpBloc>(context, listen: false);
              mpBloc.moveUsersToLoadGame(onDone: (res) {
                Toast.dismiss();
                if (res.length != 0)
                  Toast.show('$res', context, gravity: Toast.TOP);
              }, onError: (err) {
                Toast.dismiss();
                Toast.show('$err', context, gravity: Toast.TOP);
              });
            }, 'START'),
          )
        ],
      ),
    );
  }
}

Widget buildPlayer({bool status, String avatar, String username, String rank}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            InkWell(onTap: () {}, child: CircleAvatar()),
            SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('$username',
                    style: TextStyle(
                        fontFamily: fontThree,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                Text('$rank',
                    style: TextStyle(
                      fontFamily: fontThree,
                      fontSize: 10,
                    ))
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                height: 6, width: 6, color: status ? Colors.green : Colors.red),
            SizedBox(width: 8),
            Text(status ? 'ONLINE' : 'OFFLINE',
                style: TextStyle(
                    fontFamily: fontThree, color: Colors.black, fontSize: 9))
          ],
        )
      ],
    ),
  );
}
