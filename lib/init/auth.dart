import 'package:askaris/reusable/trailing.dart';
import 'package:flutter/cupertino.dart';

import '../tools.dart';

class Auth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(fontFamily: 'Inter'),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.black,
          previousPageTitle: 'Înapoi',
          trailing: TrailingHelper(
            onTap: () => {
              Askaris.utils.showNotification(
                  title: 'Test', context: context, content: 'Askaris.utils.showNotification()')
            },
            loader: false,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Text(
              'În curând!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
