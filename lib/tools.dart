import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'init/first.dart';
import 'main.dart';

/// Entry point to the Askaris SDK.
/// This SDK is provided as-is, without extra support.
class Askaris {
  static AuthUtils auth = AuthUtils();
  static Alert utils = Alert();
  static Props props = Props();
}

class AuthUtils {
  const AuthUtils();
  createAccount(
      {@required String name,
      @required String email,
      @required String password,
      @required context}) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .set({'name': name, 'uid': value.user.uid, 'email': email}))
        .then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, CupertinoPageRoute(builder: (context) => MyHomePage()));
    }).catchError((e) => {
              Askaris.utils
                  .showNotification(context: context, title: 'Eroare!', content: e.toString())
            });
  }

  signIn({@required String email, @required String password, @required context}) {
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then(
        (value) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, CupertinoPageRoute(builder: (context) => MyHomePage()));
    }).catchError((e) => {
          Askaris.utils.showNotification(context: context, title: 'Eroare!', content: e.toString())
        });
  }
}

class Alert {
  const Alert();
  showNotification({@required context, @required String title, @required content}) {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(
                title,
                style: TextStyle(letterSpacing: -0.5),
              ),
              content: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  content,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text('Ok'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }
}

class Props {
  StatefulWidget isAuthDiff = FirebaseAuth.instance.currentUser != null ? MyHomePage() : OOBE();
  Color accent = CupertinoColors.systemBlue;
}
