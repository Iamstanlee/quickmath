import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmath/bloc/auth_bloc.dart';
import 'package:quickmath/helpers/constants.dart';
import 'package:quickmath/helpers/functions.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({Key key}) : super(key: key);

  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
        body: Column(
      children: <Widget>[
        SizedBox(height: 36),
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 10),
          child: Row(
            children: <Widget>[
              InkWell(onTap: () {}, child: CircleAvatar()),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('${authBloc.firebaseUser.displayName}',
                    style: TextStyle(
                        fontFamily: fontThree, fontWeight: FontWeight.w600)),
              )
            ],
          ),
        ),
        SizedBox(
          height: getHeight(context, height: 7),
        ),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Divider(),
                      Text('Rank - ✨Novice',
                          style: TextStyle(
                              fontFamily: fontThree,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Sign Out',
                            style: TextStyle(
                                fontFamily: fontThree,
                                fontWeight: FontWeight.w600)),
                        SizedBox(width: 7),
                        loadPng('arrowRight', height: 16)
                      ],
                    ),
                  )
                ],
              )),
        ),
      ],
    ));
  }
}
