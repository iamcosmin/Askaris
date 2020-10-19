import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import 'package:tdlib/td_client.dart';
import 'package:tdlib/td_api.dart';
import 'package:askaris/services/locator.dart';
import 'dart:math' show Random;

import 'package:askaris/utils/const.dart';

int _random() => Random().nextInt(11111111);

class TelegramService extends ChangeNotifier {
  int _client;
  StreamController<TdObject> _eventController;
  StreamSubscription<TdObject> _eventReceiver;
  Map results = <int, Completer>{};
  Map callbackResults = <int, Future<void>>{};
  Directory appDocDir;
  Directory appExtDir;
  String lastRouteName;

  TelegramService({this.lastRouteName}) {
    _eventController = StreamController();
    _eventController.stream.listen(_onEvent);
    initClient();
  }

  /// Creates a new instance of TDLib.
  /// Returns Pointer to the created instance of TDLib.
  /// Pointer 0 mean No client instance.

  void initClient() async {
    if (_client != null) {
      return await TdClient.destroyClient(_client);
    }
    _client = await TdClient.createClient();

    // ignore: unused_local_variable
    PermissionStatus storagePermission =
        await Permission.storage.request(); // todo : handel storage permission
    /*try {
      PermissionStatus storagePermission =
          await SimplePermissions.requestPermission(
              Permission.WriteExternalStorage);
    } on PlatformException catch (e) {
      print(e);
    }
    */
    appDocDir = await getApplicationDocumentsDirectory();
    appExtDir = await getTemporaryDirectory();

    //execute(SetLogStream(logStream: LogStreamEmpty()));
    await execute(SetLogVerbosityLevel(newVerbosityLevel: 1));
    _eventReceiver = TdClient.clientEvents(_client).listen(_receiver);
  }

  void _receiver(TdObject newEvent) async {
    if (newEvent != null) {
      if (newEvent is Updates) {
        newEvent.updates.forEach((Update event) => _eventController.add(event));
      } else {
        _eventController.add(newEvent);
      }
      await _resolveEvent(newEvent);
    }
  }

  Future _resolveEvent(event) async {
    final int extraId = event.extra;
    if (results.containsKey(extraId)) {
      results.remove(extraId).complete(event);
    } else if (callbackResults.containsKey(extraId)) {
      await callbackResults.remove(extraId);
    }
  }

  void stop() {
    _eventController.close();
    _eventReceiver.cancel();
  }

  void _onEvent(TdObject event) async {
    /*try {
      print('res =>>>> ${event.toJson()}');
    } catch (NoSuchMethodError) {
      print('res =>>>> ${event.getConstructor()}');
    }*/
    switch (event.getConstructor()) {
      case UpdateAuthorizationState.CONSTRUCTOR:
        await _authorizationController(
          (event as UpdateAuthorizationState).authorizationState,
          isOffline: true,
        );
        break;
      default:
        return;
    }
  }

  Future _authorizationController(
    AuthorizationState authState, {
    bool isOffline = false,
  }) async {
    String route;
    switch (authState.getConstructor()) {
      case AuthorizationStateWaitTdlibParameters.CONSTRUCTOR:
        await send(
          SetTdlibParameters(
            parameters: TdlibParameters(
              useTestDc: false,
              useSecretChats: false,
              useMessageDatabase: true,
              useFileDatabase: true,
              useChatInfoDatabase: true,
              ignoreFileNames: true,
              enableStorageOptimizer: true,
              systemLanguageCode: 'EN',
              filesDirectory: appExtDir.path + '/tdlib',
              databaseDirectory: appDocDir.path,
              applicationVersion: '0.0.1 alpha (login only)',
              deviceModel: 'Samsung Galaxy A80 (mockup)',
              systemVersion: 'Android 10 (mockup)',
              apiId: 671018,
              apiHash: '0ed6cbca0384197d7857f1b7e0d4dab4',
            ),
          ),
        );
        return;
      case AuthorizationStateWaitEncryptionKey.CONSTRUCTOR:
        if ((authState as AuthorizationStateWaitEncryptionKey).isEncrypted) {
          await send(
            CheckDatabaseEncryptionKey(
              encryptionKey: 'mostrandomencryption',
            ),
          );
        } else {
          await send(
            SetDatabaseEncryptionKey(
              newEncryptionKey: 'mostrandomencryption',
            ),
          );
        }
        return;
      case AuthorizationStateWaitPhoneNumber.CONSTRUCTOR:
      case AuthorizationStateClosed.CONSTRUCTOR:
        route = loginRoute;
        break;
      case AuthorizationStateReady.CONSTRUCTOR:
        route = homeRoute;
        break;
      case AuthorizationStateWaitCode.CONSTRUCTOR:
        route = otpRoute;
        break;
      case AuthorizationStateWaitOtherDeviceConfirmation.CONSTRUCTOR:
      case AuthorizationStateWaitRegistration.CONSTRUCTOR:
      case AuthorizationStateWaitPassword.CONSTRUCTOR:
        route = passwordRoute;
        break;
      case AuthorizationStateLoggingOut.CONSTRUCTOR:
      case AuthorizationStateClosing.CONSTRUCTOR:
        return;
      default:
        return;
    }

    if (route == lastRouteName) return;
    lastRouteName = route;
    locator<NavigationService>().navigateTo(route);
  }

  void destroyClient() async {
    await TdClient.destroyClient(_client);
  }

  /// Sends request to the TDLib client. May be called from any thread.
  Future<TdObject> send(event, {Future<void> callback}) async {
    // ignore: missing_return
    final rndId = _random();
    event.extra = rndId;
    if (callback != null) {
      callbackResults[rndId] = callback;
      try {
        await TdClient.clientSend(_client, event);
      } catch (e) {
        print(e);
      }
    } else {
      final completer = Completer<TdObject>();
      results[rndId] = completer;
      await TdClient.clientSend(_client, event);
      return completer.future;
    }
  }

  /// Synchronously executes TDLib request. May be called from any thread.
  /// Only a few requests can be executed synchronously.
  /// Returned pointer will be deallocated by TDLib during next call to clientReceive or clientExecute in the same thread, so it can't be used after that.
  Future<TdObject> execute(TdFunction event) async => await TdClient.clientExecute(_client, event);

  Future setAuthenticationPhoneNumber(
    String phoneNumber, {
    void Function(TdError) onError,
  }) async {
    final result = await send(
      SetAuthenticationPhoneNumber(
        phoneNumber: phoneNumber,
        settings: PhoneNumberAuthenticationSettings(
          allowFlashCall: false,
          isCurrentPhoneNumber: false,
          allowSmsRetrieverApi: false,
        ),
      ),
    );
    if (result is TdError && onError != null) {
      onError(result);
    }
  }

  Future checkAuthenticationCode(
    String code, {
    void Function(TdError) onError,
  }) async {
    final result = await send(
      CheckAuthenticationCode(
        code: code,
      ),
    );
    if (result is TdError && onError != null) {
      onError(result);
    }
  }

  Future savePassword(
    String password, {
    void Function(TdError) onError,
  }) async {
    final result = await send(
      CheckAuthenticationPassword(
        password: password,
      ),
    );
    if (result is TdError && onError != null) {
      onError(result);
    }
  }
}
