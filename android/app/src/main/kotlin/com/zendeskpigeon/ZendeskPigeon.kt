// Autogenerated from Pigeon (v17.3.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon


import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  if (exception is FlutterError) {
    return listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    return listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

private fun createConnectionError(channelName: String): FlutterError {
  return FlutterError("channel-error",  "Unable to establish connection on channel: '$channelName'.", "")}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

/**
 * platform agnostic error
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class ZendeskError (
  /**
   *
   *
   *
   * Android
   *
   *
   *
   * the detail message string.
   * - NULLABLE natively
   */
  val messageAndroid: String? = null,
  /** Returns the short description of this throwable consisting of the exception class name (fully qualified if possible) followed by the exception message if it is not null. */
  val toStringAndroid: String? = null,
  /**
   *
   *
   *
   * iOS
   *
   *
   *
   * The error code.
   */
  val codeIOS: Long? = null,
  /** A string containing the error domain. */
  val domainIOS: String? = null,
  /**
   * The user info dictionary.
   * - Map<String,dynamic> natively
   */
  val userInfoIOS: Map<String?, String?>? = null,
  /** A string containing the localized description of the error. */
  val localizedDescriptionIOS: String? = null,
  /**
   * An array containing the localized titles of buttons appropriate for displaying in an alert panel.
   * - NULLABLE natively
   */
  val localizedRecoveryOptionsIOS: List<String?>? = null,
  /**
   * A string containing the localized recovery suggestion for the error.
   * - NULLABLE natively
   */
  val localizedRecoverySuggestionIOS: String? = null,
  /**
   * A string containing the localized explanation of the reason for the error.
   * - NULLABLE natively
   */
  val localizedFailureReasonIOS: String? = null,
  /**
   *
   *
   *
   * Other
   *
   *
   *
   */
  val nonOSError: String? = null

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): ZendeskError {
      val messageAndroid = list[0] as String?
      val toStringAndroid = list[1] as String?
      val codeIOS = list[2].let { if (it is Int) it.toLong() else it as Long? }
      val domainIOS = list[3] as String?
      val userInfoIOS = list[4] as Map<String?, String?>?
      val localizedDescriptionIOS = list[5] as String?
      val localizedRecoveryOptionsIOS = list[6] as List<String?>?
      val localizedRecoverySuggestionIOS = list[7] as String?
      val localizedFailureReasonIOS = list[8] as String?
      val nonOSError = list[9] as String?
      return ZendeskError(messageAndroid, toStringAndroid, codeIOS, domainIOS, userInfoIOS, localizedDescriptionIOS, localizedRecoveryOptionsIOS, localizedRecoverySuggestionIOS, localizedFailureReasonIOS, nonOSError)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      messageAndroid,
      toStringAndroid,
      codeIOS,
      domainIOS,
      userInfoIOS,
      localizedDescriptionIOS,
      localizedRecoveryOptionsIOS,
      localizedRecoverySuggestionIOS,
      localizedFailureReasonIOS,
      nonOSError,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class ZendeskUser (
  val id: String? = null,
  val externalId: String? = null

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): ZendeskUser {
      val id = list[0] as String?
      val externalId = list[1] as String?
      return ZendeskUser(id, externalId)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      id,
      externalId,
    )
  }
}

@Suppress("UNCHECKED_CAST")
private object ZendeskApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          ZendeskError.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is ZendeskError -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface ZendeskApi {
  /**
   *
   *
   *
   * paired with callbacks below
   *
   *
   *
   */
  fun startInitialize(channelKey: String)
  fun startLoginUser(jwt: String)
  fun startLogoutUser()
  fun startGetUnreadMessageCount()
  /** this goes pretty much only one way - return an error or don't */
  fun show(callback: (Result<ZendeskError?>) -> Unit)

  companion object {
    /** The codec used by ZendeskApi. */
    val codec: MessageCodec<Any?> by lazy {
      ZendeskApiCodec
    }
    /** Sets up an instance of `ZendeskApi` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: ZendeskApi?) {
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.com.zendeskpigeon.api.ZendeskApi.startInitialize", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val channelKeyArg = args[0] as String
            var wrapped: List<Any?>
            try {
              api.startInitialize(channelKeyArg)
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.com.zendeskpigeon.api.ZendeskApi.startLoginUser", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val jwtArg = args[0] as String
            var wrapped: List<Any?>
            try {
              api.startLoginUser(jwtArg)
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.com.zendeskpigeon.api.ZendeskApi.startLogoutUser", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped: List<Any?>
            try {
              api.startLogoutUser()
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.com.zendeskpigeon.api.ZendeskApi.startGetUnreadMessageCount", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped: List<Any?>
            try {
              api.startGetUnreadMessageCount()
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.com.zendeskpigeon.api.ZendeskApi.show", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.show() { result: Result<ZendeskError?> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
@Suppress("UNCHECKED_CAST")
private object ZendeskCallbacksCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          ZendeskError.fromList(it)
        }
      }
      129.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          ZendeskUser.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is ZendeskError -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      is ZendeskUser -> {
        stream.write(129)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated class from Pigeon that represents Flutter messages that can be called from Kotlin. */
@Suppress("UNCHECKED_CAST")
class ZendeskCallbacks(private val binaryMessenger: BinaryMessenger) {
  companion object {
    /** The codec used by ZendeskCallbacks. */
    val codec: MessageCodec<Any?> by lazy {
      ZendeskCallbacksCodec
    }
  }
  /** complete [ZendeskApi.startInitialize] */
  fun initializeSuccess(callback: (Result<Unit>) -> Unit)
{
    val channelName = "dev.flutter.pigeon.com.zendeskpigeon.api.ZendeskCallbacks.initializeSuccess"
    val channel = BasicMessageChannel<Any?>(binaryMessenger, channelName, codec)
    channel.send(null) {
      if (it is List<*>) {
        if (it.size > 1) {
          callback(Result.failure(FlutterError(it[0] as String, it[1] as String, it[2] as String?)))
        } else {
          callback(Result.success(Unit))
        }
      } else {
        callback(Result.failure(createConnectionError(channelName)))
      } 
    }
  }
  fun initializeError(errorArg: ZendeskError, callback: (Result<Unit>) -> Unit)
{
    val channelName = "dev.flutter.pigeon.com.zendeskpigeon.api.ZendeskCallbacks.initializeError"
    val channel = BasicMessageChannel<Any?>(binaryMessenger, channelName, codec)
    channel.send(listOf(errorArg)) {
      if (it is List<*>) {
        if (it.size > 1) {
          callback(Result.failure(FlutterError(it[0] as String, it[1] as String, it[2] as String?)))
        } else {
          callback(Result.success(Unit))
        }
      } else {
        callback(Result.failure(createConnectionError(channelName)))
      } 
    }
  }
  /** complete [ZendeskApi.startLoginUser] */
  fun loginUserSuccess(userArg: ZendeskUser, callback: (Result<Unit>) -> Unit)
{
    val channelName = "dev.flutter.pigeon.com.zendeskpigeon.api.ZendeskCallbacks.loginUserSuccess"
    val channel = BasicMessageChannel<Any?>(binaryMessenger, channelName, codec)
    channel.send(listOf(userArg)) {
      if (it is List<*>) {
        if (it.size > 1) {
          callback(Result.failure(FlutterError(it[0] as String, it[1] as String, it[2] as String?)))
        } else {
          callback(Result.success(Unit))
        }
      } else {
        callback(Result.failure(createConnectionError(channelName)))
      } 
    }
  }
  fun loginUserError(errorArg: ZendeskError, callback: (Result<Unit>) -> Unit)
{
    val channelName = "dev.flutter.pigeon.com.zendeskpigeon.api.ZendeskCallbacks.loginUserError"
    val channel = BasicMessageChannel<Any?>(binaryMessenger, channelName, codec)
    channel.send(listOf(errorArg)) {
      if (it is List<*>) {
        if (it.size > 1) {
          callback(Result.failure(FlutterError(it[0] as String, it[1] as String, it[2] as String?)))
        } else {
          callback(Result.success(Unit))
        }
      } else {
        callback(Result.failure(createConnectionError(channelName)))
      } 
    }
  }
  /** complete [ZendeskApi.startLogoutUser] */
  fun logoutUserSuccess(callback: (Result<Unit>) -> Unit)
{
    val channelName = "dev.flutter.pigeon.com.zendeskpigeon.api.ZendeskCallbacks.logoutUserSuccess"
    val channel = BasicMessageChannel<Any?>(binaryMessenger, channelName, codec)
    channel.send(null) {
      if (it is List<*>) {
        if (it.size > 1) {
          callback(Result.failure(FlutterError(it[0] as String, it[1] as String, it[2] as String?)))
        } else {
          callback(Result.success(Unit))
        }
      } else {
        callback(Result.failure(createConnectionError(channelName)))
      } 
    }
  }
  fun logoutUserError(errorArg: ZendeskError, callback: (Result<Unit>) -> Unit)
{
    val channelName = "dev.flutter.pigeon.com.zendeskpigeon.api.ZendeskCallbacks.logoutUserError"
    val channel = BasicMessageChannel<Any?>(binaryMessenger, channelName, codec)
    channel.send(listOf(errorArg)) {
      if (it is List<*>) {
        if (it.size > 1) {
          callback(Result.failure(FlutterError(it[0] as String, it[1] as String, it[2] as String?)))
        } else {
          callback(Result.success(Unit))
        }
      } else {
        callback(Result.failure(createConnectionError(channelName)))
      } 
    }
  }
  /** complete [ZendeskApi.startGetUnreadMessageCount] */
  fun getUnreadMessageCountSuccess(countArg: Long, callback: (Result<Unit>) -> Unit)
{
    val channelName = "dev.flutter.pigeon.com.zendeskpigeon.api.ZendeskCallbacks.getUnreadMessageCountSuccess"
    val channel = BasicMessageChannel<Any?>(binaryMessenger, channelName, codec)
    channel.send(listOf(countArg)) {
      if (it is List<*>) {
        if (it.size > 1) {
          callback(Result.failure(FlutterError(it[0] as String, it[1] as String, it[2] as String?)))
        } else {
          callback(Result.success(Unit))
        }
      } else {
        callback(Result.failure(createConnectionError(channelName)))
      } 
    }
  }
  fun getUnreadMessageCountError(errorArg: ZendeskError, callback: (Result<Unit>) -> Unit)
{
    val channelName = "dev.flutter.pigeon.com.zendeskpigeon.api.ZendeskCallbacks.getUnreadMessageCountError"
    val channel = BasicMessageChannel<Any?>(binaryMessenger, channelName, codec)
    channel.send(listOf(errorArg)) {
      if (it is List<*>) {
        if (it.size > 1) {
          callback(Result.failure(FlutterError(it[0] as String, it[1] as String, it[2] as String?)))
        } else {
          callback(Result.success(Unit))
        }
      } else {
        callback(Result.failure(createConnectionError(channelName)))
      } 
    }
  }
}
