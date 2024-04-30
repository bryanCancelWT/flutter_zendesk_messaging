package com.chyiiiiiiiiiiiiii.zendesk_messaging

import ZendeskMessaging
import android.app.Activity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler


class ZendeskMessagingPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// Register the plugin with the Flutter Engine and unregister it when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    var activity: Activity? = null

    /// stat vars
    var isInitialized: Boolean = false
    var isLoggedIn: Boolean = false

    /// TODO: eventually add all the other zendesk functions we know exist
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        val zendeskMessaging = ZendeskMessaging(this, channel)
        when (call.method) {
            "initialize" -> {
                zendeskMessaging.initialize(call.argument<String>("channelKey"))
            }
            "show" -> {
                result.success(zendeskMessaging.show());
            }
            "getUnreadMessageCount" -> {
                zendeskMessaging.getUnreadMessageCount()
            }
            "loginUser" -> {
                zendeskMessaging.loginUser(call.argument<String>("jwt"))
            }
            "logoutUser" -> {
                zendeskMessaging.logoutUser()
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "zendesk_messaging")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}