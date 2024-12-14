package com.kurmantaev.vk_id_auth

import com.vk.id.AccessToken
import com.vk.id.VKIDUser
import io.flutter.plugin.common.MethodChannel

/// Расширение над классом [AccessToken] VK ID SDK для конвертации объекта [AccessToken]
/// в [Map<String, Any?>].
val AccessToken.toMap: Map<String, Any?>
    get() = mapOf<String, Any?>(
        "token" to token,
        "userId" to userID,
        "userData" to userData.toMap,
    )

/// Расширение над классом [VKIDUser] VK ID SDK для конвертации объекта [VKIDUser] в
/// [Map<String, Any?>].
val VKIDUser.toMap: Map<String, Any?>
    get() = mapOf<String, Any?>(
        "firstName" to firstName,
        "lastName" to lastName,
        "email" to email,
        "phone" to phone
    )

/// Отправляет [VkIdAuthPluginError] в Flutter.
fun MethodChannel.Result.pluginErrorToFlutter(error: VkIdAuthPluginError) = error(
    error.code,
    error.message,
    error.details
)