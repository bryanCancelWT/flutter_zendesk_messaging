import 'package:pigeon/pigeon.dart';

/// flutter pub run pigeon --input pigeons/zendesk_api.dart
@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/pigeons/zendesk_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/app/src/main/kotlin/com/wtzendesk/WTZendesk.g.kt',
    kotlinOptions: KotlinOptions(),
    swiftOut: 'ios/Runner/WTZendesk.g.swift',
    swiftOptions: SwiftOptions(),
    dartPackageName: 'com.wtzendesk.api',
  ),
)

/// platform agnostic error
class ZendeskError {
  ///
  ///
  ///
  /// Android
  ///
  ///
  ///

  /// the detail message string.
  /// - NULLABLE natively
  final String? messageAndroid;

  /// Returns the short description of this throwable consisting of the exception class name (fully qualified if possible) followed by the exception message if it is not null.
  final String? toStringAndroid;

  ///
  ///
  ///
  /// iOS
  ///
  ///
  ///

  /// The error code.
  final int? codeIOS;

  /// A string containing the error domain.
  final String? domainIOS;

  /// The user info dictionary.
  /// - Map<String,dynamic> natively
  final Map<String?, String?>? userInfoIOS;

  /// A string containing the localized description of the error.
  final String? localizedDescriptionIOS;

  /// An array containing the localized titles of buttons appropriate for displaying in an alert panel.
  /// - NULLABLE natively
  final List<String?>? localizedRecoveryOptionsIOS;

  /// A string containing the localized recovery suggestion for the error.
  /// - NULLABLE natively
  final String? localizedRecoverySuggestionIOS;

  /// A string containing the localized explanation of the reason for the error.
  /// - NULLABLE natively
  final String? localizedFailureReasonIOS;

  ///
  ///
  ///
  /// Other
  ///
  ///
  ///

  final String? nonOSError;

  /// a combination of
  /// - https://developer.apple.com/documentation/foundation/nserror
  /// - https://kotlinlang.org/api/latest/jvm/stdlib/kotlin/-throwable/
  ZendeskError({
    /// android
    this.messageAndroid,
    this.toStringAndroid,

    /// iOS
    this.codeIOS,
    this.domainIOS,
    this.userInfoIOS,
    this.localizedDescriptionIOS,
    this.localizedRecoveryOptionsIOS,
    this.localizedRecoverySuggestionIOS,
    this.localizedFailureReasonIOS,

    /// other
    this.nonOSError,
  });
}

@HostApi()
abstract class ZendeskApi {
  ///
  ///
  ///
  /// paired with callbacks below
  ///
  ///
  ///

  void initialize(String channelKey);
  void loginUser(String jwt);
  void logoutUser();
  void getUnreadMessageCount();

  /// this goes pretty much only one way - return an error or don't
  @async
  ZendeskError? invalidate();
  @async
  ZendeskError? show();
  @async
  ZendeskError? setConversationTags(List<String> tags);
  @async
  ZendeskError? clearConversationTags();
  @async
  ZendeskError? setConversationFields(Map<String, String> fields);
  @async
  ZendeskError? clearConversationFields();
}

@FlutterApi()
abstract class ZendeskCallbacks {
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
}
