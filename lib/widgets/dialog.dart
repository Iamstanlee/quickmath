import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickmath/helpers/constants.dart';
import 'package:quickmath/widgets/raised_button.dart';

enum DialogType { WithAction, WithoutAction, WithoutActionAndTitle }

class DialogWidget extends StatefulWidget {
  final String title, buttonLabel;
  final VoidCallback callback;
  final Widget content, buttonWidget;
  final Color color;
  final DialogType dialogType;
  DialogWidget(
      {@required this.title,
      @required this.content,
      this.buttonLabel,
      this.buttonWidget,
      this.dialogType,
      this.color = Colors.black,
      this.callback});
  @override
  _DialogWidgetState createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.dialogType) {
      case DialogType.WithAction:
        return CupertinoAlertDialog(
          title: Padding(
            padding: EdgeInsets.only(),
            child: Text(
              widget.title,
              style: TextStyle(fontFamily: fontThree, color: widget.color),
            ),
          ),
          insetAnimationDuration: Duration(milliseconds: 500),
          content: Container(
            child: widget.content,
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: widget.buttonWidget != null
                  ? FlatButton(
                      onPressed: widget.callback,
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      color: Colors.blue,
                      child: widget.buttonWidget,
                    )
                  : raisedButton(widget.callback, widget.buttonLabel),
            )
          ],
        );
        break;
      case DialogType.WithoutAction:
        return CupertinoAlertDialog(
          title: Padding(
            padding: EdgeInsets.only(),
            child: Text(
              widget.title,
              style: TextStyle(fontFamily: fontThree, color: widget.color),
            ),
          ),
          insetAnimationDuration: Duration(milliseconds: 500),
          content: Container(
            child: widget.content,
          ),
        );
        break;
      case DialogType.WithoutActionAndTitle:
        return CupertinoAlertDialog(
          insetAnimationDuration: Duration(milliseconds: 500),
          content: Container(
            child: widget.content,
          ),
        );
        break;
      default:
        return CupertinoAlertDialog(
          title: Padding(
            padding: EdgeInsets.only(),
            child: Text(
              widget.title,
              style: TextStyle(fontFamily: fontThree, color: widget.color),
            ),
          ),
          insetAnimationDuration: Duration(milliseconds: 500),
          content: Container(
            child: widget.content,
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: widget.buttonWidget != null
                  ? FlatButton(
                      onPressed: widget.callback,
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      color: Colors.blue,
                      child: widget.buttonWidget,
                    )
                  : raisedButton(widget.callback, widget.buttonLabel),
            )
          ],
        );
    }
  }
}
