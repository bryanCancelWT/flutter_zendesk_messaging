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

  /// No Completers
  /// - can only return a failure from native
  Future<Failure?> show();
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

  static Future<Result<ZendeskUser, Failure>> loginUser(String jwt) async {
    return await zendeskService!.loginUser(jwt);
  }

  static Future<Failure?> logoutUser() async {
    return await zendeskService!.logoutUser();
  }

  static Future<Failure?> show() async {
    return await zendeskService!.show();
  }
}
