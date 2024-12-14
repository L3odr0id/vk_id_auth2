package com.kurmantaev.vk_id_auth

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.lifecycle.LifecycleOwner
import com.vk.id.VKID
import com.vk.id.VKIDUser
import com.vk.id.auth.VKIDAuthParams
import com.vk.id.refreshuser.VKIDGetUserCallback
import com.vk.id.refreshuser.VKIDGetUserFail
import com.vk.id.refreshuser.VKIDGetUserParams
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** VkIdAuthPlugin */
class VkIdAuthPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    /// ТЕГ плагина. Подставляется как 'tag' во всех логах.
    private val tag: String = "VkIdAuthPlugin"

    /// Название [MethodChannel] плагина.
    private val methodChannelName: String = "vk_id_auth"

    /// Название метода initialize().
    private val initializeMethodName: String = "initialize"

    /// Название метода login().
    private val loginMethodName: String = "login"
    private val scopeLoginArg = "scope"

    /// Название метода getUserData().
    private val getUserDataName: String = "getUserData"

    /// Название метода isInitialized.
    private val isInitializedMethodName: String = "isInitialized"

    /// Канал связи между Flutter и нативом для вызова методов плагина.
    private var channel: MethodChannel? = null

    private var isInitCalled: Boolean = false

    /// Текущая [Activity].
    private var activity: Activity? = null

    /// Экземпляр класса для вызова авторизации через [VKID].
    private var vkIdAuthCallback: VkIdAuthPluginCallback? = null

    /// Обработчик на вызов методов плагина.
    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            initializeMethodName -> {
                Log.d(tag, "[$initializeMethodName] was called")
                initialize(result)
            }

            loginMethodName -> {
                Log.d(tag, "[$loginMethodName] was called")
                val scope = call.argument<List<String>>(scopeLoginArg) ?: listOf()
                login(result, scope)
            }

            isInitializedMethodName -> {
                Log.d(tag, "[$isInitializedMethodName] was called")
                result.success(isInitialized)
            }

            getUserDataName -> {
                Log.d(tag, "[$getUserDataName] was called")
//        val scope = call.argument<List<String>>(scopeLoginArg) ?: listOf()
                getUserData(result, listOf())
            }

            else -> {
                Log.e(tag, "${call.method} has not been implemented")
                result.notImplemented()
            }
        }
    }

    /// Возвращает текущий [LifecycleOwner].
    private val lifecycleOwner: LifecycleOwner?
        get() {
            if (activity is LifecycleOwner) return activity as LifecycleOwner
            return null
        }

    /// Возвращает true, если плагин инициализирован, иначе false.
    private val isInitialized: Boolean get() = isInitCalled

    /// Инициализирует плагин.
    private fun initialize(result: Result) {
        try {
            val context: Context =
                activity?.applicationContext ?: return result.pluginErrorToFlutter(
                    VkIdAuthPluginContextNullError()
                )
            VKID.init(context)
            isInitCalled = true
            result.success(null)
        } catch (error: Exception) {
            Log.e(
                tag, "[$initializeMethodName] caught exception of type " +
                        "[${error.javaClass.kotlin}]. Message: ${error.message}. " +
                        "StackTrace: ${error.stackTrace}"
            )
            result.pluginErrorToFlutter(VkIdAuthPluginInitializationError(error))
        }
    }

    /// Авторизирует с помощью VK ID SDK.
    private fun login(result: Result, userScopes: List<String>) {
        try {
            if (!isInitialized) return result.pluginErrorToFlutter(VkIdAuthPluginNotInitializedError())
            val lifecycleOwner: LifecycleOwner = lifecycleOwner
                ?: return result.pluginErrorToFlutter(VkIdAuthPluginLifecycleOwnerNullError())

            vkIdAuthCallback = VkIdAuthPluginCallback(tag, result)
            VKID.instance.authorize(lifecycleOwner, vkIdAuthCallback!!, VKIDAuthParams {
                scopes = userScopes.toSet()
            }
            )
        } catch (error: Exception) {
            Log.e(
                tag, "[$loginMethodName] caught exception of type " +
                        "[${error.javaClass.kotlin}]. Message: ${error.message}. " +
                        "StackTrace: ${error.stackTrace}"
            )
            result.pluginErrorToFlutter(VkIdAuthPluginUnknownError(error))
        }
    }

    /// Получить данные юзера
    private fun getUserData(result: Result, scopes: List<String>) {
        try {
            if (!isInitialized) return result.pluginErrorToFlutter(VkIdAuthPluginNotInitializedError())
            val lifecycleOwner: LifecycleOwner = lifecycleOwner
                ?: return result.pluginErrorToFlutter(VkIdAuthPluginLifecycleOwnerNullError())

            val vkGetUserCallback = object : VKIDGetUserCallback {
                override fun onFail(fail: VKIDGetUserFail) {
                    result.error(fail.description, null, null)
                }

                override fun onSuccess(user: VKIDUser) {
                    result.success(user.toMap)
                }
            }

            VKID.instance.getUserData(lifecycleOwner, vkGetUserCallback)
        } catch (error: Exception) {
            Log.e(
                tag, "[$getUserDataName] caught exception of type " +
                        "[${error.javaClass.kotlin}]. Message: ${error.message}. " +
                        "StackTrace: ${error.stackTrace}"
            )
            result.pluginErrorToFlutter(VkIdAuthPluginUnknownError(error))
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, methodChannelName)
        channel?.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
        activity = null
        vkIdAuthCallback = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        channel?.setMethodCallHandler(this)
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        channel?.setMethodCallHandler(null)
        activity = null
        vkIdAuthCallback = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        channel?.setMethodCallHandler(this)
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        channel?.setMethodCallHandler(null)
        activity = null
        vkIdAuthCallback = null
    }
}
