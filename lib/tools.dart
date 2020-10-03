import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

/// Entry point to the Askaris SDK.
/// This SDK is provided as-is, without extra support.
class Askaris {
  static AuthUtils auth = AuthUtils();
  static Alert utils = Alert();
}

class AuthUtils {
  const AuthUtils();
  createAccount({@required String name, @required String email, @required String password}) {
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    dynamic uid = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance.collection('users').doc(email).set({'name': 'name', 'uid': uid});
  }

  signIn({@required String email, @required String password}) {
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
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
