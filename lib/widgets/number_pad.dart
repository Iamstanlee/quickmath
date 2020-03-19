import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmath/bloc/auth_bloc.dart';
import 'package:quickmath/data/message.dart';
import 'package:quickmath/helpers/base_textfield.dart';
import 'package:quickmath/helpers/constants.dart';
import 'package:quickmath/helpers/functions.dart';

class NumberPad extends StatefulWidget {
  final Function(Message) onSendMsg;
  NumberPad({this.onSendMsg});
  @override
  _NumberPadState createState() => _NumberPadState();
}

class _NumberPadState extends State<NumberPad> {
  String initialValue = '';
  List<List<Map>> keys = [
    [
      {'key': '1'},
      {'key': '2'},
      {'key': '3'}
    ],
    [
      {'key': '4'},
      {'key': '5'},
      {'key': '6'}
    ],
    [
      {'key': '7'},
      {'key': '8'},
      {'key': '9'}
    ],
    [
      {'key': '.'},
      {'key': '0'},
      {'key': ''}
    ],
  ];
  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<AuthBloc>(context).firebaseUser.uid;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: 250,
            child: NumberPadField(
              hintText: initialValue == '' ? 'Type your answer' : initialValue,
              initialValue: initialValue,
              onSend: () {
                if (initialValue != '') {
                  var thisInstant = new DateTime.now();
                  Message message = Message(
                      msg: initialValue,
                      timeStamp: formatDate(thisInstant),
                      uid: uid);
                  widget.onSendMsg(message);
                }
                setState(() {
                  initialValue = '';
                });
              },
              suffix: loadPng('send', height: 16, width: 16),
            ),
          ),
          Column(
            children: keys.map<Widget>((innerKey) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: innerKey.map<Widget>((k) {
                    return key(
                        key: k['key'],
                        isDeleteKey: k['key'].length == 0,
                        onKeyPress: (value) {
                          setState(() {
                            if (k['key'] == '.') {
                              if (!initialValue.contains('.'))
                                initialValue += value;
                            } else if (k['key'] == '') {
                              if (initialValue.length != 0)
                                initialValue = initialValue.substring(
                                    0, initialValue.length - 1);
                            } else {
                              initialValue += value;
                            }
                          });
                        });
                  }).toList());
            }).toList(),
          )
        ],
      ),
    );
  }
}

Widget key({Function onKeyPress, String key, isDeleteKey = false}) {
  return InkWell(
      onTap: () {
        onKeyPress(key);
      },
      child: Container(
        height: 50,
        width: 100,
        alignment: Alignment.center,
        child: isDeleteKey
            ? Icon(Icons.backspace)
            : Text(key,
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontFamily: fontThree)),
      ));
}
