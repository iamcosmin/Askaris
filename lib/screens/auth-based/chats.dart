import 'package:askaris/services/telegram_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdlib/td_api.dart' as TdApi;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List items;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        child: ListView.builder(itemBuilder: (context, index) {
          TelegramService().getChats().then((value) {
            switch (value.getConstructor()) {
              case TdApi.Chats.CONSTRUCTOR:
                List chatids = TdApi.Chats().chatIds;
                final chats = TdApi.Chats(chatIds: chatids).chatIds;
                items = chats;
                break;
              case TdApi.TdError.CONSTRUCTOR:
                items = ['Error!'];
            }
          });
          return ListTile(
            title: Text(
              items.toString(),
            ),
          );
        }),
      ),
    );
  }
}
