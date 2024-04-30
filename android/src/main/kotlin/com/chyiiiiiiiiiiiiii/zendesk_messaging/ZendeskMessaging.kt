import android.content.Intent
import com.chyiiiiiiiiiiiiii.zendesk_messaging.ZendeskMessagingPlugin
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import zendesk.android.Zendesk
import zendesk.android.ZendeskResult
import zendesk.android.ZendeskUser
import zendesk.messaging.android.DefaultMessagingFactory

class ZendeskMessaging(private val plugin: ZendeskMessagingPlugin, private val channel: MethodChannel) {
    companion object {
        const val tag = "[ZendeskMessaging]"

        /// Method channel callback keys
        const val initializeSuccess: String = "initialize_success"
        const val initializeFailure: String = "initialize_failure"
        const val loginSuccess: String = "login_success"
        const val loginFailure: String = "login_failure"
        const val logoutSuccess: String = "logout_success"
        const val logoutFailure: String = "logout_failure"

        /// non os errors
        const val alreadyInitialized: String = "already initialized"
        const val notInitialized: String = "not initialized"
        const val failedToLogout: String = "failed to logout"
    }
    
    fun _errorToMap(error: Any): Map<String, String> {
        return if (error is Throwable) {
            error.zendeskError
        } else {
            mapOf("nonOSError" to "Unknown error type - $error")
        }
    }

    /// Initialize
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/getting_started/#initialize-the-sdk
    /// 
    /// Initialize the SDK in the onCreate method of your Application class. 
    /// To do this, you'll need your channel key, which you can find in the Zendesk Admin Center. 
    ///
    /// If you don't have admin access to Zendesk, ask a Zendesk admin to get the information for you.
    ///
    /// The snippets below give an example of a Messaging initialization in both Kotlin and Java.

    /// TODO: isInitialized check - try catch wrap
    fun initialize(channelKey: String) {
        if (plugin.isInitialized) {
            channel.invokeMethod(initializeFailure, mapOf("nonOSError" to alreadyInitialized))
            return
        }
     
        Zendesk.initialize(
            plugin.activity!!,
            channelKey,
            successCallback = { value ->
                plugin.isInitialized = true
                channel.invokeMethod(initializeSuccess, null)
            },
            failureCallback = { error ->
                plugin.isInitialized = false
                channel.invokeMethod(initializeFailure, _errorToMap(error))
            },
            messagingFactory = DefaultMessagingFactory(),
        )
    }


    /// Show the conversation
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/getting_started/#show-the-conversation
    /// 
    /// If Zendesk.initialize() is successful, you can use the code snippets below anywhere in your app to show the conversation screen.
    /// If Zendesk.initialize() is not successful, a stub implementation of the Zendesk class is returned that logs to the console.
    fun show() {
        Zendesk.instance.messaging.showMessaging(plugin.activity!!, Intent.FLAG_ACTIVITY_NEW_TASK)
        println("$tag - show")
    }

    /// Unread Messages
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/getting_started/#unread-messages
    /// 
    /// When the user receives a new message, an event is triggered with the updated total number of unread messages. 
    /// To subscribe to this event, add an event listener to your Zendesk SDK instance. 
    /// See Events for the necessary steps to observe unread messages.
    /// 
    /// In addition, you can retrieve the current total number of unread messages by calling getUnreadMessageCount() on Messaging on your Zendesk SDK instance.
    /// 
    /// You can find a demo app showcasing this feature in our Zendesk SDK Demo app github.
    /// TODO: 

    /// TODO: https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#clickable-links-delegate
    /// TODO: https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#events

    ///
    ///
    ///
    /// Authentication
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#authentication
    ///
    /// The Zendesk SDK allows authentication of end users so that their identity can be verified by agents using Zendesk. 
    /// A detailed article on the steps to set up authentication for your account is here. 
    /// The steps mentioned in this article should be completed before beginning the steps below.
    ///
    /// You can find a demo app demonstrating the capability of user authentication on our Demo app repository.
    ///
    /// Authentication Errors
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#authentication-errors
    ///
    /// All authentication errors can be observed through Events.
    ///
    /// The most common error that will happen here is a HTTP 401 error. 
    /// In this case a new JWT should be generated and a call made to loginUser.
    ///
    /// Authentication Lifecycle
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#authentication-lifecycle
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
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#loginuser
    ///
    /// To authenticate a user call the loginUser API with your own JWT. You can create your own JWT following our Creating a JWT token section.
    fun loginUser(jwt: String) {
        if(plugin.isInitialized == false) {
            channel.invokeMethod(loginFailure, mapOf("nonOSError" to notInitialized))
            return
        }

        Zendesk.instance.loginUser(
            jwt,
            { value: ZendeskUser? ->
                plugin.isLoggedIn = true;
                value?.let {
                    channel.invokeMethod(loginSuccess, mapOf("id" to it.id, "externalId" to it.externalId))
                } ?: run {
                    channel.invokeMethod(loginSuccess, mapOf("id" to null, "externalId" to null))
                }
            },
            { error: Throwable? ->
                channel.invokeMethod(loginFailure, _errorToMap(error))
            })
    }

    /// LogoutUser
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#logoutuser
    ///
    /// To unauthenticate a user call the logoutUser API.
    ///
    /// This is primarily for authenticated users but calling logoutUser for an unauthenticated user will clear all of their data, 
    /// including their conversation history. 
    /// Please note that there is no way for us to recover this data, so only use this for testing purposes. 
    /// The next time the unauthenticated user enters the conversation screen a new user and conversation will be created for them.
    fun logoutUser() {
        if(plugin.isInitialized == false) {
            channel.invokeMethod(logoutFailure, mapOf("nonOSError" to notInitialized))
            return
        }

        GlobalScope.launch (Dispatchers.Main)  {
            try {
                Zendesk.instance.logoutUser(successCallback = {
                    plugin.isLoggedIn = false;
                    channel.invokeMethod(logoutSuccess, null)
                }, failureCallback = {
                    channel.invokeMethod(logoutFailure, mapOf("nonOSError" to failedToLogout))
                });
            } catch (error: Throwable) {
                channel.invokeMethod(logoutFailure, mapOf("nonOSError" to failedToLogout))
            }
        }
    }

    /// TODO https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#visitor-path

    /// TODO https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#proactive-messaging

    /// TODO: https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#customization

    /// TODO: https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#messaging-metadata

    /// 
    ///
    /// Conversation Fields
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#conversation-fields
    ///
    ///
    ///

    /// Set Conversation Fields
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#set-conversation-fields
    ///
    /// Allows values for conversation fields to be set in the SDK to add contextual data about the conversation.
    /// Zendesk.instance.messaging.setConversationFields(fields: Map<String, Any>)
    /// 
    /// Conversation fields must first be created as custom ticket fields and configured to allow their values to be set by end users in Admin Center. 
    /// To use conversation fields, see Using Messaging Metadata with the Zendesk Web Widgets and SDKs.
    /// 
    /// The values stored are persisted, and will be applied to all conversations going forward. 
    /// To remove conversation fields stored in the SDK, use the ClearConversationFields API.
    /// 
    /// Note: Conversation fields are not immediately associated with a conversation when the API is called. 
    /// Calling the API will store the conversation fields, 
    /// but those fields will only be applied to a conversation when end users either start a new conversation or send a new message in an existing conversation.
    /// 
    /// System ticket fields, such as the Priority field, are not supported.
    /// 
    /// Parameters
    /// fields: Map<String, Any>: It is a collection of key-value pairs.
    ///
    /// Type	Description
    /// String	id of custom ticket field
    /// Any	value of custom ticket field
    /// 
    /// Note: Supported types for Any are string, number and boolean.
    /// TODO: 

    /// Clear Conversation Fields
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#clear-conversation-fields
    /// 
    /// You can clear conversation fields from the SDK storage when the client side context changes. 
    /// To do this, use the clearConversationFields API. This removes all stored conversation fields from the SDK storage.
    ///
    /// Note: This API does not affect conversation fields already applied to the conversation.
    /// TODO: 

    /// 
    ///
    /// Conversation Tags
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#conversation-tags
    ///
    ///
    ///

    /// Set Conversation Tags
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#set-conversation-tags
    /// 
    /// Allows custom conversation tags to be set in the SDK to add contextual data about the conversation.
    ///
    /// Zendesk.instance.messaging.setConversationTags(tags: List<String>)
    ///
    /// To use conversation tags, refer to Using Messaging Metadata with the Zendesk Web Widgets and SDKs.
    ///
    /// Note: Conversation tags are not immediately associated with a conversation when the API is called. 
    /// It will only be applied to a conversation when end users either start a new conversation or send a new message in an existing conversation.
    /// TODO: 

    /// Clear Conversation Tags
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#clear-conversation-tags
    /// 
    /// Allows you to clear conversation tags from SDK storage when the client side context changes. 
    /// To do this, use the clearConversationTags API. This removes all stored conversation tags from the SDK storage.
    ///
    /// Note: This API does not affect conversation tags already applied to the conversation.
    /// TODO: 

    /// TODO https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#postback-buttons-in-messaging

    /// Invalidate the SDK
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/android/advanced_integration/#invalidate-the-sdk
    ///
    /// Invalidating the Zendesk SDK refers to the process of stopping its current instance. 
    /// Upon instance invalidation, Zendesk SDK nullifies the invalidated instance and references to the internal storages are lost. 
    /// This ensures that unused data does not accumulate over time, freeing up system resources. 
    /// When the end user logs out, the Zendesk SDK removes all user details from local storages and terminates the real-time connection. 
    /// Invalidating the Zendesk SDK instance means that no messages nor notifications will be received.
    /// TODO: 
}

val Throwable.zendeskError: Map<String, String>
    get() = mapOf(
        "messageAndroid" to this.message.orEmpty(),
        "toStringAndroid" to this.toString()
    )