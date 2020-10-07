import 'package:askaris/init/login.dart';
import 'package:askaris/reusable/trailing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../tools.dart';

// ignore: must_be_immutable
class Registration extends StatelessWidget {
  String _email;
  String _password;
  String _name;

  @override
  Widget build(BuildContext context) {
    return CPS(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black,
        previousPageTitle: 'Înapoi',
        trailing: TrailingHelper(
          onTap: () => {
            AskarisSDK.auth
                .createAccount(email: _email, password: _password, context: context, name: _name)
          },
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
                    CupertinoIcons.person_add_solid,
                    size: 75,
                    color: AskarisSDK.props.accent,
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Center(
                    child: Text(
                      'Înregistrează-te',
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
                            child: Icon(CupertinoIcons.person_solid)),
                        decoration: BoxDecoration(
                          color: CupertinoColors.darkBackgroundGray,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        placeholder: 'Nume',
                        onChanged: (value) => _name = value.trim(),
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
                        placeholder: 'Parolă',
                        obscureText: true,
                        onChanged: (value) => _password = value.trim(),
                        style: TextStyle(
                          fontSize: 17,
                        )),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  CupertinoButton(
                    onPressed: () => Navigator.pushReplacement(
                        context, CupertinoPageRoute(builder: (context) => Authentication())),
                    child: Text('Ai cont? Conectează-te!',
                        style: TextStyle(fontSize: 17, fontFamily: 'Inter')),
                  ),
                  Padding(padding: EdgeInsets.only(top: 30)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
