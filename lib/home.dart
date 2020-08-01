import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget {
  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: DefaultTextStyle(
        style: TextStyle(fontFamily: 'Inter'),
        child: Container(
          color: CupertinoTheme.of(context).scaffoldBackgroundColor,
          child: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    'Acasă',
                    textAlign: TextAlign.center,
                  ),
                ),
                leading: new Container(),
              ),
              SliverSafeArea(
                top: false,
                // This is just a big list of all the items in the settings.
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
