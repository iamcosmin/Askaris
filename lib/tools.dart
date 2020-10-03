import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

/// Entry point to the Askaris SDK.
/// This SDK is provided as-is, without extra support.
class Askaris {
  static AuthUtils auth = AuthUtils();
}

class AuthUtils {
  const AuthUtils();
  static createAccount({@required String name, @required String email, @required String password}) {
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    dynamic uid = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance.collection('users').doc(email).set({'name': 'name', 'uid': uid});
  }

  static signIn({@required String email, @required String password}) {
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }
}
