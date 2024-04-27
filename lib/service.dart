import 'dart:io';

import 'package:multiple_result/multiple_result.dart';
import 'package:zendesk_messaging/failure.dart';
import 'package:zendesk_messaging/service_channel.dart';
import 'package:zendesk_messaging/service_pigeon.dart';
import 'package:zendesk_messaging/zendesk_pigeon.dart';

abstract class ZendeskService {
  /// Seperate
  Future<Failure?> initializeService();

  /// Completers
  Future<Failure?> initializeZendesk(String channelKey);
  Future<Result<ZendeskUser, Failure>> loginUser(String jwt);
  Future<Failure?> logoutUser();
  Future<Result<int, Failure>> getUnreadMessageCount();

  /// No Completers
  /// - can only return a failure from native
  Future<Failure?> invalidate();
  Future<Failure?> show();
  Future<Failure?> setConversationTags(List<String> tags);
  Future<Failure?> clearConversationTags();
  Future<Failure?> setConversationFields(Map<String, String> fields);
  Future<Failure?> clearConversationFields();

  /// Other
  /// - can only fail while being called from flutter
  Future<Result<bool, Failure>> isInitialized();
  Future<Result<bool, Failure>> isLoggedIn();
}

class ZendeskMessaging {
  static ZendeskService? zendeskService;
  static bool? useChannelNotPigeonGlobal;

  /// Attach a global observer for incoming messages
  static void setMessageHandler(
    Function(ZendeskMessagingMessageType type, Map? arguments)? handler,
  ) {
    if (useChannelNotPigeonGlobal!) {
      ZendeskServiceChannel.setMessageHandler(handler);
    }
  }

  /// wraps both initializations in one
  static Future<Failure?> initialize({
    bool useChannelNotPigeon = true,
    required String androidChannelKey,
    required String iosChannelKey,
  }) async {
    useChannelNotPigeonGlobal = useChannelNotPigeon;
    zendeskService = useChannelNotPigeonGlobal!
        ? ZendeskServiceChannel()
        : ZendeskServicePigeon();
    Failure? failure = await zendeskService!.initializeService();
    if (failure != null) return failure;
    return await zendeskService!.initializeZendesk(
      Platform.isIOS ? iosChannelKey : androidChannelKey,
    );
  }

  static Future<Result<ZendeskUser, Failure>> loginUser(String jwt) async {
    return await zendeskService!.loginUser(jwt);
  }

  static Future<Failure?> logoutUser() async {
    return await zendeskService!.logoutUser();
  }

  static Future<Result<int, Failure>> getUnreadMessageCount() async {
    return await zendeskService!.getUnreadMessageCount();
  }

  static Future<Failure?> invalidate() async {
    return await zendeskService!.invalidate();
  }

  static Future<Failure?> show() async {
    return await zendeskService!.show();
  }

  static Future<Failure?> setConversationTags(
    List<String> tags,
  ) async {
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

  static Future<Result<bool, Failure>> isInitialized() async {
    return await zendeskService!.isInitialized();
  }

  static Future<Result<bool, Failure>> isLoggedIn() async {
    return await zendeskService!.isLoggedIn();
  }
}
