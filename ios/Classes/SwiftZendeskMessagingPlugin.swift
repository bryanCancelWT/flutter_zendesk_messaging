import Flutter
import UIKit

public class SwiftZendeskMessagingPlugin: NSObject, FlutterPlugin {
    let TAG = "[SwiftZendeskMessagingPlugin]"
    private var channel: FlutterMethodChannel
    var isInitialized = false
    var isLoggedIn = false
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "zendesk_messaging", binaryMessenger: registrar.messenger())
        let instance = SwiftZendeskMessagingPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        DispatchQueue.main.async {
            self.processMethodCall(call, result: result)
        }
    }

    private func processMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = call.method
        let arguments = call.arguments as? Dictionary<String, Any>
        let zendeskMessaging = ZendeskMessaging(flutterPlugin: self, channel: channel)

        switch(method){
            case "initialize":
                zendeskMessaging.initialize(result: result, channelKey: arguments?["channelKey"] as? String)
            case "show":
                zendeskMessaging.show(result: result, rootViewController: UIApplication.shared.delegate?.window??.rootViewController)
            case "getUnreadMessageCount":
                zendeskMessaging.getUnreadMessageCount(result: result)
                break
            case "loginUser":
                zendeskMessaging.loginUser(result: result, jwt: arguments?["jwt"] as? String)
            case "logoutUser":
                zendeskMessaging.logoutUser(result: result)
            default:
                result(FlutterMethodNotImplemented)
        }
    }

}
