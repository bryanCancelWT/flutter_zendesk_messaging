import 'dart:io';

import 'package:multiple_result/multiple_result.dart';
import 'package:zendesk_messaging/failure.dart';
import 'package:zendesk_messaging/service_channel.dart';
import 'package:zendesk_messaging/service_pigeon.dart';
import 'package:zendesk_messaging/zendesk_pigeon.dart';

abstract class ZendeskService {
  Future<Failure?> initializeService();
  Future<Failure?> initializeZendesk(String channelKey);
  Future<Failure?> show();
  Future<Result<int, Failure>> getUnreadMessageCount();
  Future<Result<ZendeskUser, Failure>> loginUser(String jwt);
  Future<Failure?> logoutUser();
  Future<Failure?> setConversationTags(List<String> tags);
  Future<Failure?> clearConversationTags();
  Future<Failure?> setConversationFields(Map<String, String> fields);
  Future<Failure?> clearConversationFields();
  Future<Failure?> invalidate();
  Future<Result<bool, Failure>> getIsInitialized();
  Future<Result<bool, Failure>> getIsLoggedIn();
}

class ZendeskMessaging {
  static ZendeskService? zendeskService;

  /// Attach a global observer for incoming messages
  static void setMessageHandler(
    Function(ZendeskMessagingMessageType type, Map? arguments)? handler, {
    bool useChannelNotPigeon = true,
  }) {
    if (useChannelNotPigeon) {
      ZendeskServiceChannel.setMessageHandler(handler);
    }
  }

  /// wraps both initializations in one
  static Future<Failure?> initialize({
    bool useChannelNotPigeon = true,
    required String androidChannelKey,
    required String iosChannelKey,
  }) async {
    zendeskService =
        useChannelNotPigeon ? ZendeskServiceChannel() : ZendeskServicePigeon();
    Failure? failure = await zendeskService!.initializeService();
    if (failure != null) return failure;
    return await zendeskService!.initializeZendesk(
      Platform.isIOS ? iosChannelKey : androidChannelKey,
    );
  }

  static Future<Failure?> show() async {
    return await zendeskService!.show();
  }

  static Future<Result<int, Failure>> getUnreadMessageCount() async {
    return await zendeskService!.getUnreadMessageCount();
  }

  static Future<Result<ZendeskUser, Failure>> loginUser(String jwt) async {
    return await zendeskService!.loginUser(jwt);
  }

  static Future<Failure?> logoutUser() async {
    return await zendeskService!.logoutUser();
  }

  static Future<Failure?> setConversationTags(List<String> tags) async {
    return await zendeskService!.setConversationTags(tags);
  }

  static Future<Failure?> clearConversationTags() async {
    return await zendeskService!.clearConversationTags();
  }

  static Future<Failure?> setConversationFields(
    Map<String, String> fields,
  ) async {
    return await zendeskService!.setConversationFields(fields);
  }

  static Future<Failure?> clearConversationFields() async {
    return await zendeskService!.clearConversationFields();
  }

  static Future<Failure?> invalidate() async {
    return await zendeskService!.invalidate();
  }

  static Future<Result<bool, Failure>> getIsInitialized() async {
    return await zendeskService!.getIsInitialized();
  }

  static Future<Result<bool, Failure>> getIsLoggedIn() async {
    return await zendeskService!.getIsLoggedIn();
  }
}

// Extension on ZendeskUser to include serialization and utility methods.
extension ZendeskUserExtensions on ZendeskUser {
  // Converts a ZendeskUser instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'externalId': externalId,
    };
  }

  // Creates a ZendeskUser instance from a JSON map.
  static ZendeskUser fromJson(Map<String, dynamic> json) {
    return ZendeskUser(
      id: json['id'] as String?,
      externalId: json['externalId'] as String?,
    );
  }
}

// Extension on ZendeskError to include serialization and utility methods.
extension ZendeskErrorExtensions on ZendeskError {
  // Converts a ZendeskError instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'messageAndroid': messageAndroid,
      'toStringAndroid': toStringAndroid,
      'codeIOS': codeIOS,
      'domainIOS': domainIOS,
      'userInfoIOS': userInfoIOS,
      'localizedDescriptionIOS': localizedDescriptionIOS,
      'localizedRecoveryOptionsIOS':
          localizedRecoveryOptionsIOS?.map((item) => item).toList(),
      'localizedRecoverySuggestionIOS': localizedRecoverySuggestionIOS,
      'localizedFailureReasonIOS': localizedFailureReasonIOS,
    };
  }

  // Creates a ZendeskError instance from a JSON map.
  static ZendeskError fromJson(Map<String, dynamic> json) {
    return ZendeskError(
      messageAndroid: json['messageAndroid'] as String?,
      toStringAndroid: json['toStringAndroid'] as String?,
      codeIOS: json['codeIOS'] as int?,
      domainIOS: json['domainIOS'] as String?,
      userInfoIOS: (json['userInfoIOS'] as Map<String?, dynamic>?)
          ?.map((key, value) => MapEntry(key, value.toString())),
      localizedDescriptionIOS: json['localizedDescriptionIOS'] as String?,
      localizedRecoveryOptionsIOS:
          (json['localizedRecoveryOptionsIOS'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList(),
      localizedRecoverySuggestionIOS:
          json['localizedRecoverySuggestionIOS'] as String?,
      localizedFailureReasonIOS: json['localizedFailureReasonIOS'] as String?,
    );
  }
}
