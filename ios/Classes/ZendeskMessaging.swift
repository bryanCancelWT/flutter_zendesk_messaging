import UIKit
import ZendeskSDKMessaging
import ZendeskSDK

public class ZendeskMessaging: NSObject {
    let TAG = "[ZendeskMessaging]"

    /// Method channel callback keys
    private static var initializeSuccess: String = "initialize_success"
    private static var initializeFailure: String = "initialize_failure"
    private static var loginSuccess: String = "login_success"
    private static var loginFailure: String = "login_failure"
    private static var logoutSuccess: String = "logout_success"
    private static var logoutFailure: String = "logout_failure"
    private static var  getUnreadMessageCountSuccess: String = "get_unread_message_count_success"
    private static var  getUnreadMessageCountFailure: String = "get_unread_message_count_failure"

    /// non os errors
    private static var alreadyInitialized: String = "alreadyInitialized"
    private static var notInitialized: String = "notInitialized"
    private static var invalidParameter: String = "invalidParameter"
    private static var nullActivity: String = "nullActivity"
    private static var failedToLogout: String = "failedToLogout"
    private static var noMessagingController: String = "noMessagingController"
    private static var noRootController: String = "noRootController"
    
    /// other
    private var zendeskPlugin: SwiftZendeskMessagingPlugin? = nil
    private var channel: FlutterMethodChannel? = nil

    init(flutterPlugin: SwiftZendeskMessagingPlugin, channel: FlutterMethodChannel) {
        self.zendeskPlugin = flutterPlugin
        self.channel = channel
    }

    func _errorToMap(error: Error) -> [String: Any] {
        if let nsError = error as? NSError {
            return nsError.zendeskError;
        } else {
            let errorString = String(describing: error)
            return ["nonOSError": "unknown error type - \(errorString)"]
        }
    }

    /// Initialize
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/getting_started/#initialize-the-sdk
    /// 
    /// Call Zendesk.initialize(withChannelKey: ,messagingFactory: ,completionHandler:).
    /// 
    /// If successful, an instance of messaging is returned. You don't have to keep a reference to the returned instance because you can access it anytime by using Zendesk.instance.
    func initialize(result: @escaping FlutterResult, channelKey: String?) {
        if (self.zendeskPlugin?.isInitialized == true) {
            result(FlutterError(code: ZendeskMessaging.alreadyInitialized, message: "", details: nil))
            return
        }

        if(channelKey == nil || channelKey!.isEmpty){
            result(FlutterError(code: ZendeskMessaging.invalidParameter, message: "", details: nil))
            return
        }

        Zendesk.initialize(withChannelKey: channelKey!, messagingFactory: DefaultMessagingFactory()) { result in
            DispatchQueue.main.async {
                 switch result {
                    case .success(let s):
                        self.zendeskPlugin?.isInitialized = true
                        self.channel?.invokeMethod(ZendeskMessaging.initializeSuccess, arguments: [:])
                    break
                    case .failure(let error):
                        self.channel?.invokeMethod(ZendeskMessaging.initializeFailure, arguments: self._errorToMap(error: error))
                    break
                }
            }
        }

        result(nil)
    }

    
    /// Show the conversation
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/getting_started/#show-the-conversation
    /// 
    /// Call the messagingViewController() method as part of the messaging reference returned during initialization.
    func show(result: @escaping FlutterResult, rootViewController: UIViewController?) {
        if (self.zendeskPlugin?.isInitialized == false) {
            result(FlutterError(code: ZendeskMessaging.notInitialized, message: "", details: nil))
            return
        }

        guard let messagingViewController = Zendesk.instance?.messaging?.messagingViewController() as? UIViewController else {
            result(FlutterError(code: ZendeskMessaging.noMessagingController, message: "", details: nil))
            return
        }

        guard let rootViewController = rootViewController else {
            result(FlutterError(code: ZendeskMessaging.noRootController, message: "", details: nil))
            return
        }

        // Check if rootViewController is already presenting another view controller
        if let presentedVC = rootViewController.presentedViewController {
            // Check if the presentedVC is the same instance as messagingViewController
            if presentedVC === messagingViewController {
                result(nil)
                return
            } else {
                // Dismiss current and present new, or just present new
                presentedVC.dismiss(animated: true) {
                    rootViewController.present(messagingViewController, animated: true, completion: nil)
                }
            }
        } else {
            // No view controller is being presented, present the new one
            rootViewController.present(messagingViewController, animated: true, completion: nil)
        }

        result(nil)
    }

    /// Unread Messages
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/getting_started/#unread-messages
    /// 
    /// When the user receives a new message, an event is triggered with the updated total number of unread messages. 
    /// To subscribe to this event, add an event observer to your Zendesk SDK instance. 
    /// See Events for the necessary steps to observe unread messages.
    /// 
    /// In addition, you can retrieve the current total number of unread messages by calling getUnreadMessageCount() on Messaging on your Zendesk SDK instance.
    ///
    /// You can find a demo app showcasing this feature in our Zendesk SDK Demo app github.
    func getUnreadMessageCount(result: @escaping FlutterResult) {
        if (self.zendeskPlugin?.isInitialized == false) {
            result(FlutterError(code: ZendeskMessaging.notInitialized, message: "", details: nil))
            return
        }

        /// TODO: handle the edge case here
        let count = Zendesk.instance?.messaging?.getUnreadMessageCount()

        result(count ?? 0)
     }

    /// TODO https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#clickable-links-delegate

    /// TODO https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#events

    /// 
    ///
    /// 
    /// Authentication
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#authentication
    ///
    /// The Zendesk SDK allows authentication of end users so that their identity can be verified by agents using Zendesk. 
    /// A detailed article on the steps to set up authentication for your account is here. 
    /// The steps mentioned in this article should be completed before beginning the steps below.
    ///
    /// You can find a demo app demonstrating the capability of user authentication on our Demo app repository.
    /// 
    /// Authentication Errors
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#authentication-errors
    ///
    /// All authentication errors can be observed through Events.
    ///
    /// The most common error that will happen here is a HTTP 401 error. 
    /// In this case a new JWT should be generated and a call made to loginUser.
    ///
    /// Authentication Lifecycle
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#authentication-lifecycle
    /// 
    /// Once loginUser is successful, the user remains authenticated until the token expires or an error occurs.
    ///
    /// On expiry, the server will send back a 401 HTTP error, which can be caught by using the event listener. 
    /// The user will not be able to interact with Zendesk anymore and will need to be authenticated again using loginUser. 
    /// If the now unauthenticated user tries to open a conversation, they will be presented with the conversation screen and an error. 
    /// The conversation itself will not be shown.
    ///
    /// As the SDK doesn't renew the token itself, you will have to handle the re-authentication process.
    ///
    ///
    ///

    /// LoginUser
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#loginuser
    /// 
    /// To authenticate a user call the loginUser API with your own JWT.
    func loginUser(result: @escaping FlutterResult, jwt: String?) {
        if (self.zendeskPlugin?.isInitialized == false) {
            result(FlutterError(code: ZendeskMessaging.notInitialized, message: "", details: nil))
            return
        }

        if(jwt == nil || jwt!.isEmpty){
            result(FlutterError(code: ZendeskMessaging.invalidParameter, message: "", details: nil))
            return
        }

        Zendesk.instance?.loginUser(with: jwt!) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.zendeskPlugin?.isLoggedIn = true
                    self.channel?.invokeMethod(ZendeskMessaging.loginSuccess, arguments: ["id": user.id, "externalId": user.externalId])
                    break
                case .failure(let error):
                    self.channel?.invokeMethod(ZendeskMessaging.loginFailure, arguments: self._errorToMap(error: error))
                    break
                }
            }
        }

        result(nil)
    }
    
    /// LogoutUser
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#logoutuser
    /// 
    /// To unauthenticate a user call the logoutUser API.
    /// 
    /// This is primarily for authenticated users but calling logoutUser for an unauthenticated user will clear all of their data, 
    /// including their conversation history. 
    /// Please note that there is no way for us to recover this data, so only use this for testing purposes. 
    /// The next time the unauthenticated user enters the conversation screen a new user and conversation will be created for them.
    func logoutUser(result: @escaping FlutterResult) {
        if (self.zendeskPlugin?.isInitialized == false) {
            result(FlutterError(code: ZendeskMessaging.notInitialized, message: "", details: nil))
            return
        }
        
        Zendesk.instance?.logoutUser { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.zendeskPlugin?.isLoggedIn = false
                    self.channel?.invokeMethod(ZendeskMessaging.logoutSuccess, arguments: [])
                    break
                case .failure(let error):
                    self.channel?.invokeMethod(ZendeskMessaging.logoutFailure, arguments: self._errorToMap(error: error))
                    break
                }
            }
        }
    }

    /// TODO https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#visitor-path

    /// TODO https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#proactive-messaging

    /// TODO https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#customization

    /// TODO https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#messaging-metadata

    /// 
    ///
    /// Conversation Fields
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#conversation-fields
    ///
    ///
    ///

    /// Set Conversation Fields
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#set-conversation-fields
    /// 
    /// Allows values for conversation fields to be set in the SDK to add contextual data about the conversation.
    /// Zendesk.instance.messaging.setConversationFields(_ fields: [String : AnyHashable])
    ///
    /// Conversation fields must first be created as custom ticket fields and configured to allow their values to be set by end users in Admin Center. 
    /// To use conversation fields, see Using Messaging Metadata with the Zendesk Web Widgets and SDKs.
    /// 
    /// The values stored are persisted, and will be applied to all conversations going forward. 
    /// To remove conversation fields stored in the SDK, use the clearConversationFields API.
    ///
    /// Note: Conversation fields are not immediately associated with a conversation when the API is called. 
    /// Calling the API will store the conversation fields, 
    /// but those fields will only be applied to a conversation when end users either start a new conversation or send a new message in an existing conversation.
    ///
    /// Note: An event for handling failed validation checks on conversation fields set using the setConversationFields API will be added in an upcoming release of the Zendesk SDK.
    ///
    /// System ticket fields, such as the Priority field, are not supported.
    /// 
    /// Parameters
    /// fields: [String : AnyHashable]: Is a dictionary of key-value pairs.
    ///
    /// Type	Description
    /// String	id of custom ticket field
    /// AnyHashable	value of the custom ticket field
    /// 
    /// Note: The supported types for AnyHashable are string, number and boolean.
    func setConversationFields(result: @escaping FlutterResult, fields: [String: String]?) {
        if (self.zendeskPlugin?.isInitialized == false) {
            result(FlutterError(code: ZendeskMessaging.notInitialized, message: "", details: nil))
            return
        }

        /// TODO: handle the edge case here
        Zendesk.instance?.messaging?.setConversationFields(fields)

        result(nil)
    }

    /// Clear Conversation Fields
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#clear-conversation-fields
    /// 
    /// You can clear conversation fields from the SDK storage when the client side context changes. 
    /// To do this, use the clearConversationFields API. This removes all stored conversation fields from the SDK storage.
    ///
    /// Note: This API does not affect conversation fields already applied to the conversation.
    func clearConversationFields(result: @escaping FlutterResult) {
        if (self.zendeskPlugin?.isInitialized == false) {
            result(FlutterError(code: ZendeskMessaging.notInitialized, message: "", details: nil))
            return
        }

        /// TODO: handle the edge case here
        Zendesk.instance?.messaging?.clearConversationFields()

        result(nil)
    }

    /// 
    ///
    /// Conversation Tags
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#conversation-tags
    ///
    ///
    ///

    /// Set Conversation Tags
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#set-conversation-tags
    ///
    /// Allows custom conversation tags to be set in the SDK to add contextual data about the conversation.
    ///
    /// Zendesk.instance.messaging.setConversationTags(_ tags: [String])
    ///
    /// To use conversation tags, refer to Using Messaging Metadata with the Zendesk Web Widgets and SDKs.
    /// 
    /// Note: Conversation tags are not immediately associated with a conversation when the API is called. 
    /// It will only be applied to a conversation when end users either start a new conversation or send a new message in an existing conversation.
    func setConversationTags(result: @escaping FlutterResult, tags: [String]?) {
        if (self.zendeskPlugin?.isInitialized == false) {
            result(FlutterError(code: ZendeskMessaging.notInitialized, message: "", details: nil))
            return
        }

        /// TODO: handle the edge case here
        Zendesk.instance?.messaging?.setConversationTags(tags)

        result(nil)
    }

    /// Clear Conversation Tags
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#clear-conversation-tags
    ///
    /// Allows you to clear conversation tags from SDK storage when the client side context changes. 
    /// To do this, use the clearConversationTags API. This removes all stored conversation tags from the SDK storage.
    /// 
    /// Note: This API does not affect conversation tags already applied to the conversation.
    func clearConversationTags(result: @escaping FlutterResult) {
        if (self.zendeskPlugin?.isInitialized == false) {
            result(FlutterError(code: ZendeskMessaging.notInitialized, message: "", details: nil))
            return
        }

        /// TODO: handle the edge case here
        Zendesk.instance?.messaging?.clearConversationTags()

        result(nil)
    }

    /// TODO https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#postback-buttons-in-messaging

    /// TODO https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#swift-concurrency-asyncawait

    /// Invalidate the SDK
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#invalidate-the-sdk
    /// Invalidating the Zendesk SDK will end its current instance. 
    /// The invalidate() function now supports clearing the internal storage through a boolean parameter. 
    /// When the parameter is set to true it will clear all non essential data to ensure this data doesn't accumulate over time. 
    /// If clearing storage not intended to be performed during invalidation, it will be cleared when the end user logs out. 
    /// The default value of the parameter is set to false to keep the previous behaviour of the SDK. 
    /// It is important to remember that once the Zendesk SDK is invalidated no messages nor notifications will be received.
    func invalidate(result: @escaping FlutterResult) {
        if (self.zendeskPlugin?.isInitialized == false) {
            result(FlutterError(code: ZendeskMessaging.notInitialized, message: "", details: nil))
            return
        }

        Zendesk.invalidate()
        self.zendeskPlugin?.isInitialized = false

        result(nil)
    }

    func getIsInitialized(result: @escaping FlutterResult) {
        if (self.zendeskPlugin?.isInitialized == false) {
            result(FlutterError(code: ZendeskMessaging.notInitialized, message: "", details: nil))
            return
        }

        result(self.zendeskPlugin?.isInitialized == true)
    }

    func getIsLoggedIn(result: @escaping FlutterResult) {
        if (self.zendeskPlugin?.isInitialized == false) {
            result(FlutterError(code: ZendeskMessaging.notInitialized, message: "", details: nil))
            return
        }
        result(self.zendeskPlugin?.isLoggedIn == true)
    }
}

extension NSError {
    func _toStringString(input: [String: Any]?) -> [String: String]? {
        guard let input = input, !input.isEmpty else {
            return nil
        }
        var stringDictionary: [String: String] = [:]
        for (key, value) in input {
            stringDictionary[key] = String(describing: value)
        }
        return stringDictionary
    }


    var zendeskError: [String: Any] {
        return [
            "codeIOS" : self.code,
            "domainIOS" : self.domain,
            "userInfoIOS" : _toStringString(input : self.userInfo),
            "localizedDescriptionIOS" : self.localizedDescription,
            "localizedRecoveryOptionsIOS" : self.localizedRecoveryOptions,
            "localizedRecoverySuggestionIOS" : self.localizedRecoverySuggestion,
            "localizedFailureReasonIOS" : self.localizedFailureReason,
        ]
    }
}