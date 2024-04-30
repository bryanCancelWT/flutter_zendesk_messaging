import 'package:pigeon/pigeon.dart';

/// flutter pub run pigeon --input pigeons/zendesk_pigeon.dart
@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/zendesk_pigeon.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/app/src/main/kotlin/com/zendeskpigeon/ZendeskPigeon.kt',
    kotlinOptions: KotlinOptions(),
    swiftOut: 'ios/Runner/ZendeskPigeon.swift',
    swiftOptions: SwiftOptions(),
    dartPackageName: 'com.zendeskpigeon.api',
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

class ZendeskUser {
  final String? id;
  final String? externalId;

  ZendeskUser({
    this.id,
    this.externalId,
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

  void startInitialize(String channelKey);
  void startLoginUser(String jwt);
  void startLogoutUser();

  /// this goes pretty much only one way - return an error or don't
  @async
  ZendeskError? show();
}

@FlutterApi()
abstract class ZendeskCallbacks {
  /// complete [ZendeskApi.startInitialize]
  void initializeSuccess();
  void initializeError(ZendeskError error);

  /// complete [ZendeskApi.startLoginUser]
  void loginUserSuccess(ZendeskUser user);
  void loginUserError(ZendeskError error);

  /// complete [ZendeskApi.startLogoutUser]
  void logoutUserSuccess();
  void logoutUserError(ZendeskError error);
}
