import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:askaris/services/telegram_service.dart';
import 'package:tdlib/td_api.dart' show TdError;
import 'package:provider/provider.dart';

class CoodeEntrySreen extends StatefulWidget {
  @override
  _CoodeEntrySreenState createState() => _CoodeEntrySreenState();
}

class _CoodeEntrySreenState extends State<CoodeEntrySreen> {
  final String title = 'Submit Code';
  final TextEditingController _codeController = TextEditingController();
  bool _canShowButton = false;
  String _codeError;
  bool _loadingStep = false;

  void codeListener() {
    if (_codeController.text.isNotEmpty && _codeController.text.length == 5) {
      setState(() => _canShowButton = true);
    } else {
      {
        setState(() => _canShowButton = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _codeController.addListener(codeListener);
  }

  @override
  void dispose() {
    super.dispose();
    _codeController.dispose();
  }

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
                  maxLength: 5,
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  placeholder: "code",
                  autofocus: true,
                ),
              ),
            ),
            CupertinoButton(
              onPressed: () => _nextStep(_codeController.text),
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
  }

  void _handelError(TdError error) async {
    setState(() {
      _loadingStep = false;
      _codeError = error.message;
    });
  }
}
