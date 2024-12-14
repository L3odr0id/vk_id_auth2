package com.kurmantaev.vk_id_auth

import android.util.Log
import com.vk.id.AccessToken
import com.vk.id.VKIDAuthFail
import com.vk.id.auth.VKIDAuthCallback
import io.flutter.plugin.common.MethodChannel

/// Класс для вызова авторизации через [VKID].
class VkIdAuthPluginCallback(
    /// Тег плагина.
    private val tag: String,

    /// Класс с методами вызывающими результат авторизации.
    private val result: MethodChannel.Result,
) : VKIDAuthCallback {

    /// Обработчик на успешную авторизацию.
    override fun onAuth(accessToken: AccessToken) {
        Log.d(tag, "Auth succeeded")
        result.success(accessToken.toMap)
    }

    /// Обработчик на неудачу при авторизации.
    override fun onFail(fail: VKIDAuthFail) =
        when (fail) {
            is VKIDAuthFail.Canceled -> {
                Log.e(
                    tag, "[VkIdAuthCallback.onFail] | VKIDAuthFail: " +
                            "[${fail.javaClass.kotlin}]. Description: ${fail.description}"
                )
                result.pluginErrorToFlutter(VkIdAuthPluginAuthCancelledError())
            }

            else -> {
                Log.e(
                    tag, "[VkIdAuthCallback.onFail] | VKIDAuthFail: " +
                            "[${fail.javaClass.kotlin}]. Description: ${fail.description}"
                )
                result.pluginErrorToFlutter(VkIdAuthPluginUnknownError())
            }
        }
}