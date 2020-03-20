import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quickmath/bloc/multiplayer.dart';
import 'package:quickmath/helpers/base_textfield.dart';
import 'package:quickmath/helpers/constants.dart';
import 'package:quickmath/helpers/functions.dart';
import 'package:quickmath/screens/game/multiplayer_game/game_room.dart';
import 'package:quickmath/screens/load_game/load_game.dart';
import 'package:quickmath/widgets/appbar.dart';
import 'package:quickmath/widgets/dialog.dart';
import 'package:quickmath/widgets/toast.dart';

class SelectGame extends StatefulWidget {
  @override
  _SelectGameState createState() => _SelectGameState();
}

class _SelectGameState extends State<SelectGame>
    with AfterLayoutMixin<SelectGame> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final mpFormKey = GlobalKey<FormState>();
  final gcFormKey = GlobalKey<FormState>();
  int questions = 32;
  int gameCode;
  int gameCodeInput;

  @override
  void afterFirstLayout(BuildContext context) {}

  /// show question dialog for singleplayer mode
  void showQuestionsDialog() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return DialogWidget(
            title: 'ENTER NUMBER OF QUESTIONS',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: formKey,
                    child: Material(
                      child: RegField(
                        onSaved: (value) {
                          if (value.isNotEmpty) questions = parseInt(value);
                        },
                        hintText: '32',
                        suffix: Icon(Icons.nature),
                      ),
                    ),
                  ),
                )
              ],
            ),
            callback: () {
              FormState formState = formKey.currentState;
              if (formState.validate()) {
                formState.save();
                pop(context);
                push(context, LoadGame(questions: questions));
              }
            },
            buttonLabel: 'START',
          );
        });
  }

  /// dialog to show for the user to create a game and select number
  /// of questions
  void showMpQuestionsDialog() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return DialogWidget(
                title: 'ENTER NUMBER OF QUESTIONS',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: mpFormKey,
                        child: Material(
                          child: RegField(
                            onSaved: (value) {
                              if (value.isNotEmpty) questions = parseInt(value);
                            },
                            hintText: '32',
                            suffix: Icon(Icons.nature),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                callback: () {
                  setState(() {
                    FormState formState = mpFormKey.currentState;
                    if (formState.validate()) {
                      formState.save();
                      Toast.show('Creating Game...', context,
                          isTimed: false, gravity: Toast.TOP);
                      MpBloc mpBloc =
                          Provider.of<MpBloc>(context, listen: false);
                      mpBloc.createGame(questions, onDone: (gc) {
                        setState(() {
                          gameCode = gc;
                        });
                        Toast.dismiss();
                        pop(context);
                        showGameDialog();
                      }, onError: (err) {
                        Toast.dismiss();
                        Toast.show('Error', context, gravity: Toast.TOP);
                        print("** Error creating game => $err **");
                      });
                    }
                  });
                },
                buttonLabel: 'CONTINUE',
              );
            },
          );
        });
  }

  /// dialog to show for the user to input game code
  void showGameCodeDialog() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return DialogWidget(
            title: 'ENTER GAME CODE',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: gcFormKey,
                    child: Material(
                      child: RegField(
                        onSaved: (value) {
                          if (value.isNotEmpty) gameCodeInput = parseInt(value);
                        },
                        hintText: 'Eg 398242',
                        length: 6,
                        suffix: Icon(Icons.nature),
                      ),
                    ),
                  ),
                )
              ],
            ),
            callback: () {
              FormState formState = gcFormKey.currentState;
              if (formState.validate()) {
                formState.save();
                Toast.show('Please Wait...', context,
                    isTimed: false, gravity: Toast.TOP);
                MpBloc mpBloc = Provider.of<MpBloc>(context, listen: false);
                mpBloc.joinGame(gameCodeInput, onDone: (gc) {
                  Toast.dismiss();
                  pop(context);
                  push(context, GameRoom());
                }, onError: (err) {
                  Toast.dismiss();
                  Toast.show('$err', context, gravity: Toast.TOP);
                });
              }
            },
            buttonLabel: 'CONTINUE',
          );
        });
  }

  /// dialog to show for succesful game creation
  void showGameDialog() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return DialogWidget(
            title: 'GAME CREATED',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 8),
                Center(
                  child: Text(
                      'Your game has been created, Share game code with friends to join you.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: fontThree,
                          color: Colors.black,
                          fontSize: 12)),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text.rich(
                        TextSpan(
                            children: [
                              TextSpan(text: 'GAME CODE: '),
                              TextSpan(
                                  text: gameCode == null ? '' : "$gameCode",
                                  style: TextStyle(
                                      fontFamily: fontThree,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 14)),
                            ],
                            style: TextStyle(
                                fontFamily: fontThree,
                                color: Colors.black,
                                fontSize: 12)),
                        textAlign: TextAlign.left),
                    SizedBox(width: 4),
                    GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(
                              ClipboardData(text: "$gameCode"));
                          Toast.show('"$gameCode" copied', context,
                              gravity: Toast.TOP);
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.content_copy, size: 18),
                            Text('(copy)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: fontThree,
                                    color: Colors.black,
                                    fontSize: 12))
                          ],
                        )),
                  ],
                )
              ],
            ),
            callback: () {
              pop(context);
              push(context, GameRoom());
            },
            buttonLabel: 'CONTINUE',
          );
        });
  }

  void showMultiplayerDialog() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return DialogWidget(
            title: '',
            dialogType: DialogType.WithoutActionAndTitle,
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlineButton(
                    highlightedBorderColor: Colors.white10,
                    highlightColor: Colors.white10,
                    onPressed: () {
                      pop(context);
                      showMpQuestionsDialog();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      alignment: Alignment.center,
                      child: Text('CREATE GAME',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: fontThree,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Center(
                            child: Text('or',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: fontThree,
                                    fontWeight: FontWeight.w500))),
                      ),
                      Expanded(
                        child: Divider(),
                      ),
                    ],
                  ),
                  OutlineButton(
                    highlightedBorderColor: Colors.white10,
                    highlightColor: Colors.white10,
                    onPressed: () {
                      pop(context);
                      showGameCodeDialog();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      alignment: Alignment.center,
                      child: Text('ENTER GAME CODE',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: fontThree,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: bgColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AppbarWidget(label: 'SELECT MODE'),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(27),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 16.0),
                      OutlineButton(
                        highlightedBorderColor: Colors.white10,
                        highlightColor: Colors.white10,
                        onPressed: () {
                          showQuestionsDialog();
                        },
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 16),
                        child: Text('Single-Player',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: fontThree,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(height: 16.0),
                      OutlineButton(
                        highlightedBorderColor: Colors.white10,
                        highlightColor: Colors.white10,
                        onPressed: () {
                          showMultiplayerDialog();
                        },
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 16),
                        child: Text('Multi-Player',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: fontThree,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(height: 16.0),
                      OutlineButton(
                        highlightedBorderColor: Colors.white10,
                        highlightColor: Colors.white10,
                        onPressed: () {
                          Toast.show('Coming Soon', context,
                              gravity: Toast.TOP);
                        },
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 16),
                        child: Text('Random Match',
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
