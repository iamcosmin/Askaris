import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdlib/td_api.dart' show TdError;
import 'package:askaris/services/telegram_service.dart';

import 'package:provider/provider.dart';
import 'package:country_pickers/country.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String title = 'Your Phone';
  final _phoneNumberController = TextEditingController();
  final _countryNameController = TextEditingController();
  Country _selectedCountry;
  bool _canShowButton = false;
  String _phoneNumberError;
  bool _loadingStep = false;

  void phoneNumberListener() {
    if (_phoneNumberController.text.isEmpty) {
      if (_canShowButton) {
        setState(() => _canShowButton = false);
      }
    } else {
      if (!_canShowButton) {
        setState(() => _canShowButton = true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(phoneNumberListener);
  }

  @override
  void dispose() {
    super.dispose();
    _phoneNumberController.dispose();
    _countryNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*if (_selectedCountry == null) {
      Locale locale = Localizations.localeOf(context);
      _selectedCountry =
          CountryPickerUtils.getCountryByIsoCode(locale.countryCode);
      _countryNameController.text = _selectedCountry.name;
    }*/
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
      ),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: CupertinoTextField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.number,
                        prefix: (_selectedCountry != null)
                            ? Text('+${_selectedCountry.phoneCode}  ')
                            : Text(' +  '),
                        placeholder: "Phone",
                        //contentPadding: EdgeInsets.zero
                        onSubmitted: _nextStep,
                        autofocus: true,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    _phoneNumberError == null
                        ? 'We will send a SMS with a confirmation code to your phone number.'
                        : '',
                    style: TextStyle(color: Colors.grey, fontSize: 15.0),
                  ),
                ),
                FloatingActionButton(
                    onPressed: () => _nextStep(_phoneNumberController.text),
                    tooltip: 'checkphone',
                    child: _loadingStep
                        ? CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          )
                        : Icon(CupertinoIcons.arrow_right))
              ],
            )
          ],
        ),
      ),
    );
  }

  void _nextStep(String value) async {
    context.read<TelegramService>().setAuthenticationPhoneNumber(
          (_selectedCountry != null) ? '+${_selectedCountry.phoneCode}$value' : value,
          onError: _handelError,
        );
  }

  void _handelError(TdError error) async {
    setState(() {
      _loadingStep = false;
      _phoneNumberError = error.message;
    });
  }
}
