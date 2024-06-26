import 'dart:async';

import 'package:flutter/services.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:zendesk_messaging/failure.dart';
import 'package:zendesk_messaging/service.dart';
import 'package:zendesk_messaging/zendesk_pigeon.dart';

extension ZendeskErrorExtn on ZendeskError {
  static ZendeskError fromArgs(Map? args) {
    return ZendeskError(
      /// android
      messageAndroid: args?["messageAndroid"],
      toStringAndroid: args?["toStringAndroid"],

      /// iOS
      codeIOS: args?["codeIOS"],
      domainIOS: args?["domainIOS"],
      userInfoIOS: (args?["userInfoIOS"] as Map?).pigeonMap,
      localizedDescriptionIOS: args?["localizedDescriptionIOS"],
      localizedRecoveryOptionsIOS: args?["localizedRecoveryOptionsIOS"],
      localizedRecoverySuggestionIOS: args?["localizedRecoverySuggestionIOS"],
      localizedFailureReasonIOS: args?["localizedFailureReasonIOS"],
    );
  }
}

extension on Map<dynamic, dynamic>? {
  Map<String?, String?>? get pigeonMap {
    if (this == null) return null;
    Map<String?, String?> outputMap = {};
    this!.forEach((key, value) {
      outputMap[key?.toString()] = value?.toString();
    });
    return outputMap;
  }
}

class ZendeskMessagingObserver {
  ZendeskMessagingObserver(this.removeOnCall, this.func);
  final bool removeOnCall;
  final Function(Map? args) func;
}

enum ZendeskMessagingMessageType {
  initializeSuccess,
  initializeFailure,
  loginSuccess,
  loginFailure,
  logoutSuccess,
  logoutFailure,
  getUnreadMessageCountSuccess,
  getUnreadMessageCountFailure,
}

class ZendeskServiceChannel implements ZendeskService {
  static const MethodChannel _channel = MethodChannel('zendesk_messaging');

  /// Allow end-user to use local observer when calling some methods
  static final Map<ZendeskMessagingMessageType, ZendeskMessagingObserver>
      _observers = {};

  /// Add an observer for a specific type
  static _setObserver(
    ZendeskMessagingMessageType type,
    Function(Map? args)? func, {
    bool removeOnCall = true,
  }) {
    if (func == null) {
      _observers.remove(type);
    } else {
      _observers[type] = ZendeskMessagingObserver(removeOnCall, func);
    }
  }

  /// Attach a global observer for incoming messages
  static void setMessageHandler(
    Function(ZendeskMessagingMessageType type, Map? arguments)? handler,
  ) {
    _handler = handler;
  }

  ///
  ///
  ///
  /// Initialize Service
  ///
  ///
  ///

  /// initialization of the service itself
  bool _hasInitialized = false;

  @override
  Future<Failure?> initializeService() async {
    if (_hasInitialized) return null;
    try {
      _channel.setMethodCallHandler(_onMethodCall);
      _hasInitialized = true;
      return null;
    } catch (e, s) {
      return Failure(e, s);
    }
  }

  /// Handle incoming message from platforms (iOS and Android)
  static Future<dynamic> _onMethodCall(final MethodCall call) async {
    if (!channelMethodToMessageType.containsKey(call.method)) {
      return;
    }

    final type = channelMethodToMessageType[call.method]!;
    final globalHandler = _handler;
    if (globalHandler != null) {
      globalHandler(type, call.arguments);
    }

    // call all observers too
    final observer = _observers[type];
    if (observer != null) {
      observer.func(call.arguments);
      if (observer.removeOnCall) {
        _setObserver(type, null);
      }
    }
  }

  static const channelMethodToMessageType = {
    'initialize_success': ZendeskMessagingMessageType.initializeSuccess,
    'initialize_failure': ZendeskMessagingMessageType.initializeFailure,
    'login_success': ZendeskMessagingMessageType.loginSuccess,
    'login_failure': ZendeskMessagingMessageType.loginFailure,
    'logout_success': ZendeskMessagingMessageType.logoutSuccess,
    'logout_failure': ZendeskMessagingMessageType.logoutFailure,
  };

  /// Global handler, all channel method calls will trigger this observer
  static Function(ZendeskMessagingMessageType type, Map? arguments)? _handler;

  ///
  ///
  ///
  /// Initialize Zendesk
  ///
  ///
  ///

  @override
  Future<Failure?> initializeZendesk(String channelKey) async {
    Completer<ZendeskError?> completer = Completer<ZendeskError?>();

    try {
      _setObserver(ZendeskMessagingMessageType.initializeSuccess, (Map? args) {
        completer.complete(null);
      });

      _setObserver(ZendeskMessagingMessageType.initializeFailure, (Map? args) {
        completer.complete(ZendeskErrorExtn.fromArgs(args));
      });

      await _channel.invokeMethod('initialize', {'channelKey': channelKey});
    } on PlatformException catch (e, s) {
      return Failure(e, s);
    }

    ZendeskError? result = await completer.future;
    return result != null ? Failure(result) : null;
  }

  ///
  ///
  ///
  /// Show
  ///
  ///
  ///

  @override
  Future<Failure?> show() async {
    try {
      await _channel.invokeMethod('show');
      return null;
    } on PlatformException catch (e, s) {
      return Failure(e, s);
    }
  }

  ///
  ///
  ///
  /// Get Unread Message Count
  ///
  ///
  ///

  @override
  Future<Result<int, Failure>> getUnreadMessageCount() async {
    try {
      return Result<int, Failure>.success(
        await _channel.invokeMethod('getUnreadMessageCount'),
      );
    } on PlatformException catch (e, s) {
      return Result<int, Failure>.error(Failure(e, s));
    }
  }

  ///
  ///
  ///
  /// Login User
  ///
  ///
  ///

  @override
  Future<Result<ZendeskUser, Failure>> loginUser(String jwt) async {
    Completer<Result<ZendeskUser, Failure>> completer =
        Completer<Result<ZendeskUser, Failure>>();

    try {
      _setObserver(ZendeskMessagingMessageType.loginSuccess, (Map? args) {
        completer.complete(Result<ZendeskUser, Failure>.success(
          ZendeskUser(id: args?['id'], externalId: args?['externalId']),
        ));
      });

      _setObserver(ZendeskMessagingMessageType.loginFailure, (Map? args) {
        completer.complete(Result<ZendeskUser, Failure>.error(
          Failure(ZendeskErrorExtn.fromArgs(args)),
        ));
      });

      await _channel.invokeMethod('loginUser', {'jwt': jwt});
    } on PlatformException catch (e, s) {
      return Result<ZendeskUser, Failure>.error(Failure(e, s));
    }

    return await completer.future;
  }

  ///
  ///
  ///
  /// Logout User
  ///
  ///
  ///

  @override
  Future<Failure?> logoutUser() async {
    Completer<ZendeskError?> completer = Completer<ZendeskError?>();

    try {
      _setObserver(ZendeskMessagingMessageType.logoutSuccess, (Map? args) {
        completer.complete(null);
      });

      _setObserver(ZendeskMessagingMessageType.logoutFailure, (Map? args) {
        completer.complete(ZendeskErrorExtn.fromArgs(args));
      });

      await _channel.invokeMethod('logoutUser');
    } on PlatformException catch (e, s) {
      return Failure(e, s);
    }

    ZendeskError? result = await completer.future;
    return result != null ? Failure(result) : null;
  }

  ///
  ///
  ///
  /// Other
  ///
  ///
  ///

  @override
  Future<Failure?> setConversationTags(List<String> tags) async {
    try {
      await _channel.invokeMethod('setConversationTags', {'tags': tags});
      return null;
    } on PlatformException catch (e, s) {
      return Failure(e, s);
    }
  }

  @override
  Future<Failure?> clearConversationTags() async {
    try {
      await _channel.invokeMethod('clearConversationTags');
      return null;
    } on PlatformException catch (e, s) {
      return Failure(e, s);
    }
  }

  @override
  Future<Failure?> setConversationFields(Map<String, String> fields) async {
    try {
      await _channel.invokeMethod('setConversationFields', {'fields': fields});
      return null;
    } on PlatformException catch (e, s) {
      return Failure(e, s);
    }
  }

  @override
  Future<Failure?> clearConversationFields() async {
    try {
      await _channel.invokeMethod('clearConversationFields');
      return null;
    } on PlatformException catch (e, s) {
      return Failure(e, s);
    }
  }

  @override
  Future<Failure?> invalidate() async {
    try {
      await _channel.invokeMethod('invalidate');
      return null;
    } on PlatformException catch (e, s) {
      return Failure(e, s);
    }
  }

  @override
  Future<Result<bool, Failure>> getIsInitialized() async {
    try {
      return Result<bool, Failure>.success(
        await _channel.invokeMethod('getIsInitialized'),
      );
    } on PlatformException catch (e, s) {
      return Result<bool, Failure>.error(Failure(e, s));
    }
  }

  @override
  Future<Result<bool, Failure>> getIsLoggedIn() async {
    try {
      return Result<bool, Failure>.success(
        await _channel.invokeMethod('getIsLoggedIn'),
      );
    } on PlatformException catch (e, s) {
      return Result<bool, Failure>.error(Failure(e, s));
    }
  }
}
