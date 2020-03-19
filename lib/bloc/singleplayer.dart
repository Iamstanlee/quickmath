import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quickmath/data/operator.dart';
import 'package:quickmath/data/question.dart';
import 'package:quickmath/helpers/functions.dart';

class SpBloc with ChangeNotifier {
  List<Question> _questions = List();
  int _currentIndex = 0;
  List<Question> get questions => _questions;
  set questions(List<Question> qts) {
    this._questions = qts;
    notifyListeners();
  }

  int get currentIndex => _currentIndex;
  set currentIndex(int newIndex) {
    this._currentIndex = newIndex;
    notifyListeners();
  }

  Question getQuestion() {
    Operator o = getOperator();
    int range = 64;
    int f, s, a;
    switch (o) {
      case Operator.Addition:
        f = getRandomInt(range);
        s = getRandomInt(range);
        a = f + s;
        break;
      case Operator.Multiplication:
        f = getRandomInt(32);
        s = getRandomInt(16);
        a = f * s;
        break;
      case Operator.Division:
        Map fs = doWholeDivision(range);
        f = fs['f'];
        s = fs['s'];
        a = f ~/ s;
        break;
      case Operator.Subtraction:
        Map fs = doPositiveSubtraction(range);
        f = fs['f'];
        s = fs['s'];
        a = f - s;
        break;
      default:
    }
    return Question(f, s, a, o);
  }

  Map doPositiveSubtraction(int range) {
    int f = getRandomInt(range);
    int s = getRandomInt(range);
    if (s > f) {
      return doPositiveSubtraction(range);
    } else {
      return {'f': f, 's': s};
    }
  }

  Map doWholeDivision(int range) {
    int f = getRandomInt(range);
    int s = getRandomInt(range);
    if (s == 0 || f == 0 || f % s != 0) {
      return doWholeDivision(range);
    } else {
      return {'f': f, 's': s};
    }
  }

  Operator getOperator() {
    List<Operator> ops = [
      Operator.Addition,
      Operator.Subtraction,
      Operator.Multiplication,
      Operator.Division
    ];
    int opIndex = getRandomInt(ops.length);
    return ops[opIndex];
  }

  void generateQuestions(int max, {VoidCallback onDone}) {
    List<Question> qts = List();
    for (int i = 0; i < max; i++) {
      Question qt = getQuestion();
      qts.add(qt);
    }
    questions = qts;
    currentIndex = 0;
    onDone();
  }

  void switchQuestion(Question question, String ans,
      {Function(int, bool) isCorrect, Function isNotCorrect}) {
    int answer = parseInt(ans);
    if (question.answer == answer) {
      if (currentIndex == questions.length - 1) {
        isCorrect(currentIndex, true);
      } else {
        currentIndex = currentIndex + 1;
        int nextIndex = currentIndex;
        isCorrect(nextIndex, false);
      }
    } else {
      isNotCorrect();
    }
  }

  /// TODO generate random awesome remarks
  ///
  /// calculate the user performance after a game
  void calculatePerformance(
      {@required int gTime,
      Function(String, String, String, String, Color) onDone}) {
    Color color;
    String grade, remark;

    String gameTime =
        gTime > 60 ? "${(gTime / 60).toStringAsFixed(2)} Mins" : "$gTime Secs";
    double average = gTime / questions.length;
    if (average < 3) {
      color = Colors.green;
      grade = 'EXCELLENT';
      remark = 'You\'re the Boss, Nice Job!';
    } else if (average >= 3 && average < 5) {
      color = Colors.green;
      grade = 'GOOD';
      remark = 'Awesome performance!';
    } else if (average >= 5 && average < 7) {
      color = Colors.orangeAccent;
      grade = 'AVERAGE';
      remark =
          'You did great!, Though you can do better dont\'t you think? Play again to improve. ';
    } else if (average >= 7) {
      color = Colors.red;
      grade = 'POOR';
      remark =
          'Not your best performance, You can do better. \n Play again to improve.';
    }
    onDone(grade, remark, gameTime, average.toStringAsFixed(2), color);
  }
}
