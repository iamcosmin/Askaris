import 'package:flutter/cupertino.dart';
import 'package:tdlib/td_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  dynamic data;

  dat() async {
    ChatListMain.fromJson(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(),
    );
  }
}
