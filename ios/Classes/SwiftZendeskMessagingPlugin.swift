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
                zendeskMessaging.initialize(channelKey: arguments?["channelKey"] as? String)
                 result(nil) 
            case "show":
                result(zendeskMessaging.show(rootViewController: UIApplication.shared.delegate?.window??.rootViewController))
            case "loginUser":
                zendeskMessaging.loginUser(jwt: arguments?["jwt"] as? String)
                 result(nil) 
            case "logoutUser":
                zendeskMessaging.logoutUser()
                 result(nil) 
            default:
                result(FlutterMethodNotImplemented)
        }
    }

}
