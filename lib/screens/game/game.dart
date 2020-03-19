import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickmath/bloc/singleplayer.dart';
import 'package:quickmath/data/operator.dart';
import 'package:quickmath/data/question.dart';
import 'package:quickmath/helpers/constants.dart';
import 'package:quickmath/helpers/functions.dart';
import 'package:quickmath/screens/load_game/load_game.dart';
import 'package:quickmath/widgets/appbar.dart';
import 'package:quickmath/widgets/dialog.dart';
import 'package:quickmath/widgets/message_bubble.dart';
import 'package:quickmath/widgets/number_pad.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with AfterLayoutMixin<Game> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> widgets = List();
  List<Question> questions = List();
  int time = 5;
  int gameTime = 0;
  Timer gameTimer;
  Timer startTimer;
  ScrollController listViewScrollController = ScrollController();
  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      questions = Provider.of<SpBloc>(context, listen: false).questions;
      widgets.add(buildDateWidget());
      widgets.add(buildModerator(
          update:
              'Hello DevStanlee, I\'m your moderator. \n This game contains ${questions.length} questions, \n You\'re to answer them quickly in the smallest possible time. \n You got this!'));
      startTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (time == 0) {
          timer.cancel();
          widgets.removeLast();
          startGame();
        } else {
          setState(() {
            if (time == 5) {
              widgets.add(buildModerator(update: 'Game starts in $time.'));
            } else {
              widgets[2] = buildModerator(update: 'Game starts in $time.');
            }
            time--;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    gameTimer.cancel();
    startTimer.cancel();
    super.dispose();
  }

  void startGame() {
    // build first question
    int i = Provider.of<SpBloc>(context, listen: false).currentIndex;
    setState(() {
      // start the timer
      gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          gameTime++;
        });
      });
      widgets.add(buildQuestion(question: questions[i]));
      scrollToBottom(listViewScrollController);
    });
  }

  void showPerformanceDialog(
      String grade, String remark, String time, String average, Color color) {
    SpBloc spBloc = Provider.of<SpBloc>(context, listen: false);
    int i = spBloc.currentIndex;
    int qsLength = i + 1;
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return DialogWidget(
            title: grade,
            color: color,
            content: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                      child: Text(remark,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: fontThree,
                              color: Colors.black,
                              fontSize: 12))),
                  SizedBox(height: 8),
                  Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(text: 'Total Time: '),
                            TextSpan(
                                text: '$time',
                                style: TextStyle(
                                    fontFamily: fontThree,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 12)),
                          ],
                          style: TextStyle(
                              fontFamily: fontThree,
                              color: Colors.black,
                              fontSize: 12)),
                      textAlign: TextAlign.left),
                  SizedBox(height: 4),
                  Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(text: 'Average: '),
                            TextSpan(
                                text: '$average Seconds per question.',
                                style: TextStyle(
                                    fontFamily: fontThree,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 12)),
                          ],
                          style: TextStyle(
                              fontFamily: fontThree,
                              color: Colors.black,
                              fontSize: 12)),
                      textAlign: TextAlign.left),
                ],
              ),
            ),
            callback: () {
              pop(context);
              replace(
                  context,
                  LoadGame(
                    questions: qsLength,
                  ));
            },
            buttonLabel: 'PLAY AGAIN',
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    SpBloc spBloc = Provider.of<SpBloc>(context, listen: false);
    int i = spBloc.currentIndex;
    int qsLength = i + 1;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: bgColor,
      body: Column(
        children: <Widget>[
          AppbarWidget(
            appbarType: AppbarType.Regular,
            action: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Container(
                padding: EdgeInsets.all(4.0),
                color: Colors.orangeAccent.withOpacity(0.5),
                child: Text('$qsLength/${questions.length}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 10.0,
                        fontFamily: fontThree)),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12, left: 12, bottom: 8),
              child: ScrollConfiguration(
                behavior: GameScrollBehavior(),
                child: ListView.builder(
                  itemCount: widgets.length,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  controller: listViewScrollController,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, int i) {
                    return widgets[i];
                  },
                ),
              ),
            ),
          ),
          NumberPad(
            onSendMsg: (msg) {
              if (time == 0)
                setState(() {
                  // update question as user answers correctly
                  if (gameTimer.isActive)
                    spBloc.switchQuestion(questions[i], msg.msg,
                        isNotCorrect: () {
                      widgets.add(ChatBubble(msg: msg, isAnswer: false));
                    }, isCorrect: (nextIndex, isLastIndex) {
                      widgets.add(ChatBubble(msg: msg, isAnswer: true));
                      if (isLastIndex) {
                        gameTimer.cancel();
                        widgets.add(buildModerator(update: 'Nice Job!'));
                        spBloc.calculatePerformance(
                            gTime: gameTime,
                            onDone: (grade, remark, time, average, color) {
                              showPerformanceDialog(
                                  grade, remark, time, average, color);
                            });
                      } else {
                        widgets
                            .add(buildQuestion(question: questions[nextIndex]));
                      }
                    });
                  scrollToBottom(listViewScrollController);
                });
            },
          )
        ],
      ),
    );
  }
}

Widget buildDateWidget() {
  DateTime dateTime = DateTime.now();
  String thisInstant = DateFormat('MMM d, yyyy').format(dateTime);
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('$thisInstant',
          style: TextStyle(
              fontFamily: fontThree, color: Colors.grey[600], fontSize: 12)),
    ),
  );
}

Widget buildModerator({@required String update}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.5)),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Text('$update',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: fontThree, color: Colors.black, fontSize: 12))),
    ),
  );
}

Widget buildQuestion({@required Question question}) {
  String theOperator;
  switch (question.operation) {
    case Operator.Addition:
      theOperator = '+';
      break;
    case Operator.Subtraction:
      theOperator = '—';
      break;
    case Operator.Multiplication:
      theOperator = '×';
      break;
    case Operator.Division:
      theOperator = '÷';
      break;
    default:
      throw new Exception('**Error getting operator**');
  }
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.5)),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Text(
              '${question.firstOperand} $theOperator ${question.secondOperand}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                  fontFamily: fontThree))),
    ),
  );
}
