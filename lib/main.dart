import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:projekt_askaris/curse.dart';
import 'home.dart';
import 'init/first.dart';
import 'settings.dart';

FirebaseAnalytics analytics;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  analytics = FirebaseAnalytics();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
  ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Askaris',
      theme: CupertinoThemeData(
          brightness: Brightness.dark,
          textTheme: CupertinoTextThemeData(
              textStyle: TextStyle(color: Colors.white))),
      home: FirebaseAuth.instance.currentUser != null ? MyHomePage() : First(),
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
            icon: Icon(
              Ionicons.home,
              size: 25,
            ),
            title: Text('Acasă'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.bus, size: 25),
            title: Text('Curse'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.cog),
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
                return CourseScreen();
                break;
              case 2:
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
