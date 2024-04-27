import 'package:multiple_result/multiple_result.dart';
import 'package:zendesk_messaging/failure.dart';
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

class WTZendeskMessaging {
  /// toggle between native service and pigeon service
  static SocureApiService? socureApiService;

  /// start up the
  /// - [MethodChannel]
  /// - pigeon version of a [MethodChannel]
  ///
  /// NO TOAST ON ERROR
  static Future<Failure?> init() async {
    socureApiService = SocureApiServicePigeon();
    return await socureApiService!.init();
  }

  /// Flow
  /// - checks and potentially requests [Permission.locationWhenInUse] IF [LocationIs.notNeeded] == false
  /// - [SocureApiService.fingerprint]
  /// - [SecureStorage.setDeviceSessionID] IF fingerprinting succeeds
  ///
  /// SHOWS TOAST ON ERROR
  static Future<FingerPrintError?> _fingerprint(
    BuildContext context, {
    required LocationIs locationIs,
    Duration normalHumanReactionTime = const Duration(milliseconds: 200),
    required bool willIgnoreFailure,
  }) async {
    WTEither<FingerPrintError, FingerPrintSuccess> fingerprintResult =
        await socureApiService!.fingerprint();

    return fingerPrintError;
  }

  /// Flow
  /// - [SocureApiService.configure]
  /// - [_fingerprint]
  ///
  /// NOTE: we could techincally save ourselves from reconfiguring the app double in many cases
  /// - but configuration is basically instant and extra code would be a waste
  ///
  /// NOTE: we could also tehnically save a finger print with a particular fingerprint
  /// - but this would be less safe in certain very specific exceptions
  /// - and it also doesn't take much time to fingerprint
  ///
  /// so in both cases, we don't optimize things for good reason
  ///
  /// SHOW TOAST ON ERRORS
  static Future<Failure?> configureAndFingerprint(
    BuildContext context, {
    required String sdkKey,
    required LocationIs locationIs,
    bool willIgnoreFingerprintFailure = false,
  }) async {
    Failure? configFailure = await socureApiService!.configure(
      sdkKey,
      omitLocation: locationIs == LocationIs.notNeeded,
    );

    if (fingerPrintError != null) return Failure(fingerPrintError);

    return null;
  }

  /// SHOW TOAST ON ERROR
  static Future<WTEither<DocVError, DocVSuccess>> docV() async {
    WTEither<DocVError, DocVSuccess> docVResult =
        await socureApiService!.docV();
    return docVResult;
  }
}
