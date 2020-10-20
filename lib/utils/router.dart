import 'package:askaris/screens/auth-based/chats.dart';
import 'package:flutter/cupertino.dart';
import 'package:askaris/utils/const.dart';
import 'package:askaris/screens/login/login.dart';
import 'package:askaris/screens/login/code_entry.dart';
import 'package:askaris/screens/login/password_entry.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case otpRoute:
        return CupertinoPageRoute(
          builder: (_) => CoodeEntrySreen(),
        );
      case loginRoute:
        return CupertinoPageRoute(
          builder: (_) => LoginScreen(),
        );
      case initRoute:
        return CupertinoPageRoute(
          builder: (_) => CupertinoPageScaffold(
              child: CupertinoButton(
            child: Text('End Client'),
            onPressed: () => null,
          )),
        );
      case passwordRoute:
        return CupertinoPageRoute(builder: (_) => PasswordEntrySreen());
      case chatsRoute:
        return CupertinoPageRoute(builder: (_) => ChatScreen());
      default:
        return CupertinoPageRoute(
          builder: (_) => CupertinoPageScaffold(
            child: Center(
                child: Text(
              'No route defined for ${settings.name}',
            )),
          ),
        );
    }
  }
}
