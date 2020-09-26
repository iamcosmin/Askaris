import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'settings.dart';

FirebaseAnalytics analytics;
void main() {
  analytics = FirebaseAnalytics();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Askaris',
      theme: CupertinoThemeData(
          brightness: Brightness.dark,
          textTheme: CupertinoTextThemeData(
              textStyle: TextStyle(color: Colors.white))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            title: Text('Acasă'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            title: Text('Setari'),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            switch (index) {
              case 0:
                return Home();
                break;
              case 1:
                return Settings();
                break;
              default:
                return Container();
            }
          },
        );
      },
    );
  }
}
