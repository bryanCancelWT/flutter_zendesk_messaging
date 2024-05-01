import 'dart:async';

import 'package:flutter/services.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:zendesk_messaging/failure.dart';
import 'package:zendesk_messaging/service.dart';
import 'package:zendesk_messaging/zendesk_pigeon.dart';

class ZendeskServicePigeon implements ZendeskService, ZendeskCallbacks {
  bool _hasInitialized = false;
  late ZendeskApi zendeskApi;

  ///
  ///
  ///
  /// Initialize Service
  ///
  ///
  ///

  @override
  Future<Failure?> initializeService() async {
    if (_hasInitialized) return null;
    try {
      zendeskApi = ZendeskApi();
      ZendeskCallbacks.setup(ZendeskServicePigeon());
      _hasInitialized = true;
      return null;
    } catch (e, s) {
      return Failure(e, s);
    }
  }

  ///
  ///
  ///
  /// Initialize Zendesk
  ///
  ///
  ///

  static Completer<ZendeskError?>? initializeZendeskCompleter;

  @override
  Future<Failure?> initializeZendesk(String channelKey) async {
    try {
      await zendeskApi.startInitialize(channelKey);
    } on PlatformException catch (e, s) {
      return Failure(e, s);
    }

    initializeZendeskCompleter = Completer<ZendeskError?>();
    ZendeskError? result = await initializeZendeskCompleter!.future;
    return result != null ? Failure(result) : null;
  }

  @override
  initializeSuccess() {
    initializeZendeskCompleter!.complete(null);
  }

  @override
  initializeError(ZendeskError zendeskError) {
    initializeZendeskCompleter!.complete(zendeskError);
  }

  ///
  ///
  ///
  /// Login User
  ///
  ///
  ///

  static Completer<Result<ZendeskUser, ZendeskError>>? loginUserCompleter;

  @override
  Future<Result<ZendeskUser, Failure>> loginUser(String jwt) async {
    try {
      await zendeskApi.startLoginUser(jwt);
    } on PlatformException catch (e, s) {
      return Result<ZendeskUser, Failure>.error(Failure(e, s));
    }

    loginUserCompleter = Completer<Result<ZendeskUser, ZendeskError>>();

    return (await loginUserCompleter!.future).when(
      (success) => Result<ZendeskUser, Failure>.success(success),
      (error) => Result<ZendeskUser, Failure>.error(Failure(error)),
    );
  }

  @override
  loginUserSuccess(ZendeskUser zendeskUser) {
    loginUserCompleter!.complete(
      Result<ZendeskUser, ZendeskError>.success(zendeskUser),
    );
  }

  @override
  loginUserError(ZendeskError zendeskError) {
    loginUserCompleter!.complete(
      Result<ZendeskUser, ZendeskError>.error(zendeskError),
    );
  }

  ///
  ///
  ///
  /// Logout User
  ///
  ///
  ///

  static Completer<ZendeskError?>? logoutUserCompleter;

  @override
  Future<Failure?> logoutUser() async {
    try {
      await zendeskApi.startLogoutUser();
    } on PlatformException catch (e, s) {
      return Failure(e, s);
    }

    logoutUserCompleter = Completer<ZendeskError?>();
    ZendeskError? result = await logoutUserCompleter!.future;
    return result != null ? Failure(result) : null;
  }

  @override
  logoutUserSuccess() {
    logoutUserCompleter!.complete(null);
  }

  @override
  logoutUserError(ZendeskError zendeskError) {
    logoutUserCompleter!.complete(zendeskError);
  }

  ///
  ///
  ///
  /// No Completers
  /// - can only return a failure from native
  ///
  ///
  ///

  @override
  Future<Result<int, Failure>> getUnreadMessageCount() async {
    try {
      return Result<int, Failure>.success(
        await zendeskApi.startGetUnreadMessageCount(),
      );
    } on PlatformException catch (e, s) {
      return Result<int, Failure>.error(Failure(e, s));
    }
  }

  @override
  Future<Failure?> show() async {
    try {
      await zendeskApi.show();
      return null;
    } on PlatformException catch (e, s) {
      return Failure(e, s);
    }
  }
}
