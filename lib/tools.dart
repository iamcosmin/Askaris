import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'init/first.dart';
import 'main.dart';

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

  /// Creates an account. We recommend passing the email and password as private Strings (_email, _password).
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
              AskarisSDK.utils
                  .showNotification(context: context, title: 'Eroare!', content: e.toString())
            });
  }

  /// Signs in the user. We recommend passing the email and password as private Strings (_email, _password)
  signIn({@required String email, @required String password, @required context}) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, CupertinoPageRoute(builder: (context) => MyHomePage()));
    }).catchError((e) => {
              AskarisSDK.utils
                  .showNotification(context: context, title: 'Eroare!', content: e.toString())
            });
  }

  Widget triage() {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        // ignore: missing_return
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            snapshot.data.providerData.length == 1 ? MyHomePage() : OOBE();
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

  /// Reduces the pain of showing a basic Alert. Requires the context, the title and the error content.
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
  /// Helps separate the authenticated users from the first timers.
  StatefulWidget isAuthDiff = FirebaseAuth.instance.currentUser != null ? MyHomePage() : OOBE();

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
