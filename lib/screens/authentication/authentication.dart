import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmath/bloc/auth_bloc.dart';
import 'package:quickmath/bloc/multiplayer.dart';
import 'package:quickmath/helpers/constants.dart';
import 'package:quickmath/helpers/functions.dart';
import 'package:quickmath/screens/home/home.dart';
import 'package:quickmath/widgets/fancy_button.dart';
import 'package:quickmath/widgets/spinner.dart';
import 'package:quickmath/widgets/toast.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool _status = false;

  /// update the status of the auth process
  void updateStatus(status) => setState(() => _status = status);
  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
        backgroundColor: bgColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // ClipPath(
            //   clipper: CustomClipOne(),
            //   child: Container(
            //     height: getHeight(context, height: 27),
            //     color: blueColor,
            //   ),
            // ),
            Container(
              height: getHeight(context, height: 27),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('Quick Maths',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: fontThree,
                        fontSize: 38,
                        fontWeight: FontWeight.w800)),
              ),
            ),
            Center(
              child: _status
                  ? Spinner()
                  : FancyButton(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          loadPng('arrowRight', height: 21),
                          SizedBox(width: 4),
                          Text(
                            'Sign In With Google',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: fontThree,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      onPressed: () {
                        MpBloc mpBloc =
                            Provider.of<MpBloc>(context, listen: false);
                        updateStatus(true);
                        authBloc.signIn(onDone: (user) {
                          mpBloc.uniqueId = user.uid;
                          pushToDispose(context, Home());
                        }, isUser: (user) {
                          mpBloc.uniqueId = user.uid;
                          pushToDispose(context, Home());
                        }, onError: (err) {
                          updateStatus(false);
                          Toast.show('Error: ${err.message ?? err.toString()}',
                              context,
                              gravity: Toast.TOP, backgroundColor: Colors.red);
                        });
                      },
                      color: Colors.orangeAccent,
                      size: 38,
                    ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 60.0, right: 20.0, left: 20.0),
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: '- By clicking "Sign In", You agree to our',
                        style: TextStyle(fontFamily: fontThree, fontSize: 12)),
                    TextSpan(
                        text: '\nPrivacy Policy.',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontFamily: fontThree,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                            fontSize: 12)),
                  ]),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              height: getHeight(context, height: 27),
              color: bgColor,
            ),
          ],
        ));
  }
}

class CustomClipOne extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // path.lineTo(size.width, 0.0);
    // path.lineTo(size.width * 0.25, size.height * 0.25);
    // path.lineTo(0.0, size.height);
    // path.lineTo(size.width, 0.0);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height * 0.75);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class CustomClipTwo extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.lineTo(0.0, size.height * 0.25);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
