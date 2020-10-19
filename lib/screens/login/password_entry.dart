import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:askaris/services/telegram_service.dart';
import 'package:tdlib/td_api.dart' show TdError;
import 'package:provider/provider.dart';

class PasswordEntrySreen extends StatefulWidget {
  @override
  _PasswordEntrySreenState createState() => _PasswordEntrySreenState();
}

class _PasswordEntrySreenState extends State<PasswordEntrySreen> {
  final String title = 'Submit Code';
  final TextEditingController _passwordController = TextEditingController();
  bool _loadingStep = false;
  // ignore: unused_field
  String _codeError;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: CupertinoTextField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  placeholder: "Password",
                  autofocus: true,
                ),
              ),
            ),
            CupertinoButton(
              onPressed: () => _nextStep(_passwordController.text),
              child: Icon(CupertinoIcons.arrow_right),
            ),
          ],
        ),
      ),
    );
  }

  void _nextStep(String value) async {
    context.read<TelegramService>().checkAuthenticationCode(
          value,
          onError: _handelError,
        );
    context.read<TelegramService>().savePassword(_passwordController.text);
  }

  void _handelError(TdError error) async {
    setState(() {
      _loadingStep = false;
      _codeError = error.message;
    });
  }
}
