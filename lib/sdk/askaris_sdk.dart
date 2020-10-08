import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../init/first.dart';
import '../main.dart';

/// Entry point to the Askaris SDK.
/// This SDK is provided as-is, without extra support.
class AskarisSDK {
  static AuthUtils auth = AuthUtils();
  static Utilities utils = Utilities();
  static Props props = Props();
  static Navigation nav = Navigation();
}

class AuthUtils {
  const AuthUtils();

  /// Creates an account.
  /// We recommend passing the email and password as private Strings (_email, _password).
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
        .then(AskarisSDK.nav.back(context: context, repeats: 2))
        .then(AskarisSDK.nav.to(activity: MyHomePage(), context: context))
        .catchError(AskarisSDK.utils.showNotification(
            context: context,
            title: 'Eroare!',
            content: 'Verificați câmpurile pentru nereguli și încercați din nou.'));
  }

  /// Signs in the user.
  /// We recommend passing the email and password as private Strings (_email, _password)
  signIn({@required String email, @required String password, @required BuildContext context}) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then(AskarisSDK.nav.back(context: context, repeats: 2))
        .then(AskarisSDK.nav.to(activity: MyHomePage(), context: context))
        .catchError(AskarisSDK.utils.showNotification(
            context: context,
            title: 'Eroare!',
            content: 'Detaliile de conectare sunt incorecte sau contul nu există.'));
  }

  /// Resets a user's password by sending a reset link to the account's email.
  /// We recommend passing the email as a private String (_email).
  resetPassword({@required String email, @required BuildContext context}) {
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then(AskarisSDK.utils.showNotification(
          context: context,
          title: 'Email trimis!',
          content:
              'Vă rugăm să verificați adresa de email cu care v-ați creat contul pentru a reseta parola!',
        ))
        .catchError(AskarisSDK.utils.showNotification(
            context: context,
            title: 'Eroare!',
            content:
                'Acest email nu aparține unui cont Askaris. Vă rugăm să verificați corectitudinea emailului.'));
  }

  /// Changes a user's email.
  /// We recommend passing the new email and the password as private Strings (_newEmail, _password)
  changeEmail(
      {@required String newEmail,
      @required String password,
      @required BuildContext context}) async {
    FirebaseAuth.instance.currentUser
        .reauthenticateWithCredential(
          EmailAuthProvider.credential(
              email: FirebaseAuth.instance.currentUser.email, password: password),
        )
        .then((value) => FirebaseAuth.instance.currentUser.updateEmail(newEmail))
        .then(AskarisSDK.nav.back(context: context, repeats: 1))
        .catchError(AskarisSDK.utils.showNotification(
            context: context, title: 'Eroare!', content: 'Parola este incorectă!'));
  }

  /// Verifies if users are authenticated or not.
  /// We recommend putting this as the home widget in (CupertinoApp/MaterialApp)(home: verify(context));
  Widget verify({@required BuildContext context}) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.providerData.length == 1 ? MyHomePage() : OOBE();
          } else {
            return OOBE();
          }
        });
  }
}

class Navigation {
  const Navigation();

  /// Navigates to a specific activity.
  to({@required Widget activity, @required BuildContext context}) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => activity));
  }

  /// Navigates back "repeats" times.
  back({@required BuildContext context, @required int repeats}) {
    for (int i = 0; i < repeats; i++) {
      Navigator.pop(context);
    }
  }
}

class Utilities {
  const Utilities();

  /// Reduces the pain of showing a basic Alert.
  showNotification(
      {@required BuildContext context, @required String title, @required String content}) {
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
                  onPressed: () => AskarisSDK.nav.back(context: context, repeats: 1),
                )
              ],
            ));
  }
}

class Props {
  /// Default app color accent.
  Color accent = CupertinoColors.systemBlue;
}

/// This widget helps to reduce the pain of replacing the font in every CupertinoPageScaffold by
/// integrating both of them in one single widget.
class CPS extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final CupertinoNavigationBar navigationBar;
  final bool resizeToAvoidBottomInset;

  CPS(
      {@required this.child,
      this.backgroundColor,
      this.navigationBar,
      this.resizeToAvoidBottomInset});

  @override
  _CPSState createState() => _CPSState();
}

class _CPSState extends State<CPS> {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(fontFamily: 'Inter'),
      child: CupertinoPageScaffold(
        child: widget.child,
        backgroundColor: widget.backgroundColor,
        navigationBar: widget.navigationBar,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      ),
    );
  }
}
