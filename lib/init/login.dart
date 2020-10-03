import 'package:askaris/init/signup.dart';
import 'package:askaris/reusable/trailing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../tools.dart';

// ignore: must_be_immutable
class Authentication extends StatelessWidget {
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(fontFamily: 'Inter'),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.black,
          previousPageTitle: 'Înapoi',
          trailing: TrailingHelper(
            onTap: () =>
                {Askaris.auth.signIn(email: _email, password: _password, context: context)},
            loader: false,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.person_solid,
                      size: 75,
                      color: Askaris.props.accent,
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Center(
                      child: Text(
                        'Conectează-te',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: CupertinoTextField(
                          prefix: Padding(
                              padding: EdgeInsets.only(left: 7, right: 5, bottom: 3),
                              child: Icon(CupertinoIcons.mail_solid)),
                          decoration: BoxDecoration(
                            color: CupertinoColors.darkBackgroundGray,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          placeholder: 'Email',
                          onChanged: (value) => _email = value.trim(),
                          style: TextStyle(
                            fontSize: 17,
                          )),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: CupertinoTextField(
                          prefix: Padding(
                              padding: EdgeInsets.only(left: 7, right: 5, bottom: 3),
                              child: Icon(CupertinoIcons.padlock_solid)),
                          decoration: BoxDecoration(
                            color: CupertinoColors.darkBackgroundGray,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          obscureText: true,
                          placeholder: 'Parolă',
                          onChanged: (value) => _password = value.trim(),
                          style: TextStyle(
                            fontSize: 17,
                          )),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    CupertinoButton(
                      onPressed: () => Navigator.pushReplacement(
                          context, CupertinoPageRoute(builder: (context) => Registration())),
                      child: Text('Nu ai cont? Înregistrează-te!',
                          style: TextStyle(fontSize: 17, fontFamily: 'Inter')),
                    ),
                    Padding(padding: EdgeInsets.only(top: 30)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
