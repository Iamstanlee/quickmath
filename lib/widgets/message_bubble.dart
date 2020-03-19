import 'package:after_layout/after_layout.dart';
import 'package:ant_icons/ant_icons.dart';
import 'package:flutter/material.dart';
import 'package:quickmath/data/message.dart';
import 'package:quickmath/helpers/constants.dart';

class ChatBubble extends StatefulWidget {
  ChatBubble({this.msg, this.isAnswer});
  final bool isAnswer;
  final Message msg;

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with AfterLayoutMixin<ChatBubble> {
  @override
  void afterFirstLayout(BuildContext context) {
    // Future.delayed(Duration(seconds: 2), () {
    //   setState(() {
    //     widget.msg.isDelivered = true;
    //   });
    // });
    setState(() {
      widget.msg.isDelivered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.msg.isMe ? Colors.greenAccent.shade100 : Colors.white;
    final align =
        widget.msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final icon =
        widget.msg.isDelivered ? AntIcons.check_outline : Icons.access_time;
    final radius = widget.msg.isMe
        ? BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          )
        : BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 70.0),
                child: Text(widget.msg.msg,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontFamily: fontThree)),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: <Widget>[
                    Text(widget.msg.timeStamp,
                        style: TextStyle(
                            color: Colors.black38,
                            fontSize: 10.0,
                            fontFamily: fontThree)),
                    SizedBox(width: 3.0),
                    widget.msg.isMe
                        ? Icon(icon,
                            size: 14.0,
                            color:
                                widget.isAnswer ? Colors.black38 : Colors.red)
                        : Container()
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
