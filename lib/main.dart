import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmath/bloc/auth_bloc.dart';
import 'package:quickmath/bloc/multiplayer.dart';
import 'package:quickmath/bloc/singleplayer.dart';
import 'package:quickmath/screens/splash/splash.dart';

void main() {
  runApp(MultiProvider(child: QuickMath(), providers: [
    ChangeNotifierProvider(
      create: (context) => AuthBloc(),
    ),
    ChangeNotifierProvider(
      create: (context) => SpBloc(),
    ),
    ChangeNotifierProvider(
      create: (context) => MpBloc(),
    )
  ]));
}

class QuickMath extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Quick Math',
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
