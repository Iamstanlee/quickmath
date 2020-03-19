import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quickmath/data/operator.dart';
import 'package:quickmath/data/question.dart';
import 'package:quickmath/data/user.dart';
import 'package:quickmath/helpers/functions.dart';

// TODO dispose gameCode after a game
class MpBloc with ChangeNotifier {
  List<Question> _questions = List();
  Firestore firestore = Firestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  FirebaseUser firebaseUser;
  String _uniqueId;
  String get uniqueId => _uniqueId;
  bool _onlineStatus = false;
  bool get onlineStatus => _onlineStatus;
  int _gameCode;

  set uniqueId(String uid) {
    this._uniqueId = uid;
  }

  int get gameCode => _gameCode;
  set gameCode(int code) {
    this._gameCode = code;
    notifyListeners();
  }

  set onlineStatus(bool status) {
    this._onlineStatus = status;
    notifyListeners();
  }

  List<Question> get questions => _questions;
  set questions(List<Question> qts) {
    this._questions = qts;
    notifyListeners();
  }

  /// listen to the user online status
  void getOnlineStatus() async {
    firebaseUser = await getCurrentUser();
    firestore.collection('users').document(firebaseUser.uid).snapshots().listen(
        (user) {
      bool myStatus = user.data['online'];
      onlineStatus = myStatus;
    }, onError: (err) {
      print('** Error getting onlineStatus => $err **');
    });
  }

  /// detect user online presence when connected or disconnected
  void getOnlinePresence() async {
    firebaseUser = await getCurrentUser();
    uniqueId = firebaseUser.uid;
    DatabaseReference databaseReference = firebaseDatabase.reference();
    DatabaseReference dbStatusReference =
        databaseReference.child('status/$uniqueId');
    databaseReference.child('.info/connected').onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      bool status = dataSnapshot.value;
      if (status == false) {
        updateOnlineStatus(firebaseUser.uid, status);
        if (gameCode != null)
          updateOnlineStatusInGame(gameCode, firebaseUser.uid, status);
        return;
      }
      dbStatusReference.onDisconnect().set(update(false)).then((onUpdate) {
        // update realtime database
        dbStatusReference.set(update(status));
        // sync with firestore
        if (gameCode != null)
          updateOnlineStatusInGame(gameCode, firebaseUser.uid, status);
        updateOnlineStatus(firebaseUser.uid, status);
      });
    }, onError: (err) {
      print('** Connection Error => $err**');
    });
  }

  /// update the [online] and [lastChanged] values
  Map<String, dynamic> update(bool status) {
    DateTime dateTime = DateTime.now();
    String thisInstant = dateTime.toIso8601String();
    return <String, dynamic>{'online': status, 'lastChanged': thisInstant};
  }

  /// update the user [online] and [lastChanged] values on firestore
  void updateOnlineStatus(String uid, bool status) {
    firestore.collection('users').document(uid).updateData(update(status));
  }

  /// update the user [online] and [lastChanged] values on firestore in game
  /// and notify all user in game on the status update
  void updateOnlineStatusInGame(int gc, String uid, bool status) async {
    DocumentReference documentReference =
        firestore.collection('games').document('$gc');
    documentReference.get().then((DocumentSnapshot snapshot) {
      List<User> players = snapshot.data['players'].map<User>((user) {
        return User.fromMap(user);
      }).toList();
      // loop through players, lookup the user id and set online status
      for (int i = 0; i < players.length; i++) {
        if (players[i].uid == uid) {
          players[i].online = status;
          break;
        }
      }
      List<Map> newPlayers = players.map<Map>((user) {
        return User.toMap(user);
      }).toList();
      documentReference.updateData({'players': newPlayers});
    });
  }

  /// generate unique game code
  Future<int> generateGameCode({int length = 6}) async {
    String gc = '';
    for (int i = 0; i < length; i++) {
      gc += getRandomInt(9).toString();
    }
    QuerySnapshot querySnapshot =
        await firestore.collection('games').getDocuments();
    List<DocumentSnapshot> documentSnapshot = querySnapshot.documents;
    for (int i = 0; i < documentSnapshot.length; i++) {
      if (documentSnapshot[i].documentID == gc) {
        return generateGameCode();
      }
    }
    return parseInt(gc);
  }

  /// create game by generating a 6 digits game code
  void createGame(int qsLength,
      {Function(int) onDone, Function(dynamic) onError}) async {
    int gc = await generateGameCode();
    User user;
    DocumentSnapshot documentSnapshot =
        await firestore.collection('users').document(uniqueId).get();
    user = User.fromMap(documentSnapshot.data);
    user.isGameCreator = true;
    firestore.collection('games').document('$gc').setData({
      'players': [User.toMap(user)],
      'gameCode': gc,
      'qsLength': qsLength,
      'isActive': false
    }).then((_) {
      // return game code onDone
      documentSnapshot.reference.updateData({'game': gc});
      gameCode = gc;
      onDone(gc);
    }).catchError((err) {
      print("** Error getting gamecode => $err **");
      onError(err);
    });
  }

  /// join a game with a game code
  void joinGame(int gc, {Function onDone, Function onError}) async {
    User user;
    DocumentSnapshot documentSnapshot =
        await firestore.collection('users').document(uniqueId).get();
    user = User.fromMap(documentSnapshot.data);
    firestore.collection('games').document('$gc').updateData({
      'players': FieldValue.arrayUnion([User.toMap(user)]),
    }).then((_) {
      // return game code onDone
      documentSnapshot.reference.updateData({'game': gc});
      gameCode = gc;
      onDone(gameCode);
    }).catchError((err) {
      print("** Error joining gamecode => ${err.message} **");
      onError();
    });
  }

  /// get the currently signed user
  Future<FirebaseUser> getCurrentUser() async {
    return await firebaseAuth.currentUser();
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
    onDone();
  }
}
