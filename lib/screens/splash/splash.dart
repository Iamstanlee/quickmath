import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmath/bloc/auth_bloc.dart';
import 'package:quickmath/bloc/multiplayer.dart';
import 'package:quickmath/helpers/constants.dart';
import 'package:quickmath/helpers/functions.dart';
import 'package:quickmath/screens/authentication/authentication.dart';
import 'package:quickmath/screens/home/home.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  @override
  void afterFirstLayout(BuildContext context) async {
    AuthBloc authBloc = Provider.of<AuthBloc>(context, listen: false);
    MpBloc mpBloc = Provider.of<MpBloc>(context, listen: false);
    FirebaseUser user = await authBloc.init();
    if (user != null) {
      mpBloc.uniqueId = user.uid;
      replace(context, Home());
    } else {
      replace(context, Authentication());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Loading App..',
            style: TextStyle(
                fontFamily: fontThree, color: Colors.black, fontSize: 12)),
      ),
    );
  }
}
