import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickmath/api/google_auth.dart';
import 'package:quickmath/data/user.dart';

class AuthBloc extends ChangeNotifier {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;

  FirebaseUser get firebaseUser => _firebaseUser;
  set firebaseUser(FirebaseUser user) {
    this._firebaseUser = user;
    notifyListeners();
  }

  Future<FirebaseUser> init() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user == null) {
      firebaseUser = null;
    } else {
      firebaseUser = user;
    }
    return user;
  }

  /// handles signIn from google auth provider takes [onDone],[isUser] & [onError] params
  void signIn(
      {Function(FirebaseUser) onDone,
      Function(FirebaseUser) isUser,
      Function(dynamic) onError}) async {
    FirebaseUser user = await signInWithGoogle(onError: onError);
    if (user != null) {
      await Firestore.instance
          .collection('users')
          .document(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (!documentSnapshot.exists) {
          User newUser = new User(
              username: user.displayName,
              // username: '',
              email: user.email,
              phonenumber: user.phoneNumber,
              uid: user.uid,
              avatar: user.photoUrl,
              rank: 'Novice',
              rankXp: 0,
              online: true);
          documentSnapshot.reference
              .setData(User.toMap(newUser))
              .whenComplete(() {
            firebaseUser = user;
            onDone(user);
          });
        } else {
          firebaseUser = user;
          isUser(user);
        }
      }).catchError((err) {
        onError(err);
      });
    }
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
