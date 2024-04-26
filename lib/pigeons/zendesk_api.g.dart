// Autogenerated from Pigeon (v17.3.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

PlatformException _createConnectionError(String channelName) {
  return PlatformException(
    code: 'channel-error',
    message: 'Unable to establish connection on channel: "$channelName".',
  );
}

List<Object?> wrapResponse({Object? result, PlatformException? error, bool empty = false}) {
  if (empty) {
    return <Object?>[];
  }
  if (error == null) {
    return <Object?>[result];
  }
  return <Object?>[error.code, error.message, error.details];
}

/// platform agnostic error
class ZendeskError {
  ZendeskError({
    this.messageAndroid,
    this.toStringAndroid,
    this.codeIOS,
    this.domainIOS,
    this.userInfoIOS,
    this.localizedDescriptionIOS,
    this.localizedRecoveryOptionsIOS,
    this.localizedRecoverySuggestionIOS,
    this.localizedFailureReasonIOS,
    this.nonOSError,
  });

  ///
  ///
  ///
  /// Android
  ///
  ///
  ///
  /// the detail message string.
  /// - NULLABLE natively
  String? messageAndroid;

  /// Returns the short description of this throwable consisting of the exception class name (fully qualified if possible) followed by the exception message if it is not null.
  String? toStringAndroid;

  ///
  ///
  ///
  /// iOS
  ///
  ///
  ///
  /// The error code.
  int? codeIOS;

  /// A string containing the error domain.
  String? domainIOS;

  /// The user info dictionary.
  /// - Map<String,dynamic> natively
  Map<String?, String?>? userInfoIOS;

  /// A string containing the localized description of the error.
  String? localizedDescriptionIOS;

  /// An array containing the localized titles of buttons appropriate for displaying in an alert panel.
  /// - NULLABLE natively
  List<String?>? localizedRecoveryOptionsIOS;

  /// A string containing the localized recovery suggestion for the error.
  /// - NULLABLE natively
  String? localizedRecoverySuggestionIOS;

  /// A string containing the localized explanation of the reason for the error.
  /// - NULLABLE natively
  String? localizedFailureReasonIOS;

  ///
  ///
  ///
  /// Other
  ///
  ///
  ///
  String? nonOSError;

  Object encode() {
    return <Object?>[
      messageAndroid,
      toStringAndroid,
      codeIOS,
      domainIOS,
      userInfoIOS,
      localizedDescriptionIOS,
      localizedRecoveryOptionsIOS,
      localizedRecoverySuggestionIOS,
      localizedFailureReasonIOS,
      nonOSError,
    ];
  }

  static ZendeskError decode(Object result) {
    result as List<Object?>;
    return ZendeskError(
      messageAndroid: result[0] as String?,
      toStringAndroid: result[1] as String?,
      codeIOS: result[2] as int?,
      domainIOS: result[3] as String?,
      userInfoIOS: (result[4] as Map<Object?, Object?>?)?.cast<String?, String?>(),
      localizedDescriptionIOS: result[5] as String?,
      localizedRecoveryOptionsIOS: (result[6] as List<Object?>?)?.cast<String?>(),
      localizedRecoverySuggestionIOS: result[7] as String?,
      localizedFailureReasonIOS: result[8] as String?,
      nonOSError: result[9] as String?,
    );
  }
}

class _ZendeskApiCodec extends StandardMessageCodec {
  const _ZendeskApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is ZendeskError) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return ZendeskError.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class ZendeskApi {
  /// Constructor for [ZendeskApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  ZendeskApi({BinaryMessenger? binaryMessenger})
      : __pigeon_binaryMessenger = binaryMessenger;
  final BinaryMessenger? __pigeon_binaryMessenger;

  static const MessageCodec<Object?> pigeonChannelCodec = _ZendeskApiCodec();

  ///
  ///
  ///
  /// paired with callbacks below
  ///
  ///
  ///
  Future<void> initialize(String channelKey) async {
    const String __pigeon_channelName = 'dev.flutter.pigeon.com.wtzendesk.api.ZendeskApi.initialize';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[channelKey]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> loginUser(String jwt) async {
    const String __pigeon_channelName = 'dev.flutter.pigeon.com.wtzendesk.api.ZendeskApi.loginUser';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[jwt]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> logoutUser() async {
    const String __pigeon_channelName = 'dev.flutter.pigeon.com.wtzendesk.api.ZendeskApi.logoutUser';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(null) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> getUnreadMessageCount() async {
    const String __pigeon_channelName = 'dev.flutter.pigeon.com.wtzendesk.api.ZendeskApi.getUnreadMessageCount';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(null) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return;
    }
  }

  /// this goes pretty much only one way - return an error or don't
  Future<ZendeskError?> invalidate() async {
    const String __pigeon_channelName = 'dev.flutter.pigeon.com.wtzendesk.api.ZendeskApi.invalidate';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(null) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return (__pigeon_replyList[0] as ZendeskError?);
    }
  }

  Future<ZendeskError?> show() async {
    const String __pigeon_channelName = 'dev.flutter.pigeon.com.wtzendesk.api.ZendeskApi.show';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(null) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return (__pigeon_replyList[0] as ZendeskError?);
    }
  }

  Future<ZendeskError?> setConversationTags(List<String?> tags) async {
    const String __pigeon_channelName = 'dev.flutter.pigeon.com.wtzendesk.api.ZendeskApi.setConversationTags';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[tags]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return (__pigeon_replyList[0] as ZendeskError?);
    }
  }

  Future<ZendeskError?> clearConversationTags() async {
    const String __pigeon_channelName = 'dev.flutter.pigeon.com.wtzendesk.api.ZendeskApi.clearConversationTags';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(null) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return (__pigeon_replyList[0] as ZendeskError?);
    }
  }

  Future<ZendeskError?> setConversationFields(Map<String?, String?> fields) async {
    const String __pigeon_channelName = 'dev.flutter.pigeon.com.wtzendesk.api.ZendeskApi.setConversationFields';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[fields]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return (__pigeon_replyList[0] as ZendeskError?);
    }
  }

  Future<ZendeskError?> clearConversationFields() async {
    const String __pigeon_channelName = 'dev.flutter.pigeon.com.wtzendesk.api.ZendeskApi.clearConversationFields';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(null) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return (__pigeon_replyList[0] as ZendeskError?);
    }
  }
}

class _ZendeskCallbacksCodec extends StandardMessageCodec {
  const _ZendeskCallbacksCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is ZendeskError) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return ZendeskError.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class ZendeskCallbacks {
  static const MessageCodec<Object?> pigeonChannelCodec = _ZendeskCallbacksCodec();

  /// complete [ZendeskApi.initialize]
  void initializeSuccess();

  void initializeError(ZendeskError error);

  /// complete [ZendeskApi.loginUser]
  void loginUserSuccess();

  void loginUserError(ZendeskError error);

  /// complete [ZendeskApi.logoutUser]
  void logoutUserSuccess();

  void logoutUserError(ZendeskError error);

  /// complete [ZendeskApi.getUnreadMessageCount]
  void getUnreadMessageCountSuccess();

  void getUnreadMessageCountError(ZendeskError error);

  static void setup(ZendeskCallbacks? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.com.wtzendesk.api.ZendeskCallbacks.initializeSuccess', pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        __pigeon_channel.setMessageHandler(null);
      } else {
        __pigeon_channel.setMessageHandler((Object? message) async {
          try {
            api.initializeSuccess();
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.com.wtzendesk.api.ZendeskCallbacks.initializeError', pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        __pigeon_channel.setMessageHandler(null);
      } else {
        __pigeon_channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.com.wtzendesk.api.ZendeskCallbacks.initializeError was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final ZendeskError? arg_error = (args[0] as ZendeskError?);
          assert(arg_error != null,
              'Argument for dev.flutter.pigeon.com.wtzendesk.api.ZendeskCallbacks.initializeError was null, expected non-null ZendeskError.');
          try {
            api.initializeError(arg_error!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.com.wtzendesk.api.ZendeskCallbacks.loginUserSuccess', pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        __pigeon_channel.setMessageHandler(null);
      } else {
        __pigeon_channel.setMessageHandler((Object? message) async {
          try {
            api.loginUserSuccess();
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.com.wtzendesk.api.ZendeskCallbacks.loginUserError', pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        __pigeon_channel.setMessageHandler(null);
      } else {
        __pigeon_channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.com.wtzendesk.api.ZendeskCallbacks.loginUserError was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final ZendeskError? arg_error = (args[0] as ZendeskError?);
          assert(arg_error != null,
              'Argument for dev.flutter.pigeon.com.wtzendesk.api.ZendeskCallbacks.loginUserError was null, expected non-null ZendeskError.');
          try {
            api.loginUserError(arg_error!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.com.wtzendesk.api.ZendeskCallbacks.logoutUserSuccess', pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        __pigeon_channel.setMessageHandler(null);
      } else {
        __pigeon_channel.setMessageHandler((Object? message) async {
          try {
            api.logoutUserSuccess();
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.com.wtzendesk.api.ZendeskCallbacks.logoutUserError', pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        __pigeon_channel.setMessageHandler(null);
      } else {
        __pigeon_channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.com.wtzendesk.api.ZendeskCallbacks.logoutUserError was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final ZendeskError? arg_error = (args[0] as ZendeskError?);
          assert(arg_error != null,
              'Argument for dev.flutter.pigeon.com.wtzendesk.api.ZendeskCallbacks.logoutUserError was null, expected non-null ZendeskError.');
          try {
            api.logoutUserError(arg_error!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.com.wtzendesk.api.ZendeskCallbacks.getUnreadMessageCountSuccess', pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        __pigeon_channel.setMessageHandler(null);
      } else {
        __pigeon_channel.setMessageHandler((Object? message) async {
          try {
            api.getUnreadMessageCountSuccess();
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.com.wtzendesk.api.ZendeskCallbacks.getUnreadMessageCountError', pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        __pigeon_channel.setMessageHandler(null);
      } else {
        __pigeon_channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.com.wtzendesk.api.ZendeskCallbacks.getUnreadMessageCountError was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final ZendeskError? arg_error = (args[0] as ZendeskError?);
          assert(arg_error != null,
              'Argument for dev.flutter.pigeon.com.wtzendesk.api.ZendeskCallbacks.getUnreadMessageCountError was null, expected non-null ZendeskError.');
          try {
            api.getUnreadMessageCountError(arg_error!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
  }
}
