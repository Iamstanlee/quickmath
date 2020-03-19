import 'package:quickmath/data/operator.dart';

class Question {
  int _firstOperand, _secondOperand, _answer;
  Operator _operation;
  Operator get operation => _operation;
  set operation(Operator operation) {
    this._operation = operation;
  }

  int get firstOperand => _firstOperand;
  set firstOperand(int fo) {
    this._firstOperand = fo;
  }

  int get secondOperand => _secondOperand;
  set secondOperand(int so) {
    this._secondOperand = so;
  }

  int get answer => _answer;
  set answer(int answer) {
    this._answer = answer;
  }

  Question(
      this._firstOperand, this._secondOperand, this._answer, this._operation);
}
