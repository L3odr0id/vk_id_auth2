package com.kurmantaev.vk_id_auth

/// Базовый класс ошибки плагина.
abstract class VkIdAuthPluginError(
    /// Код.
    val code: String,

    /// Сообщение.
    val message: String,

    /// Подробности.
    val details: String,
)

/// Ошибка инициализации плагина.
class VkIdAuthPluginInitializationError(error: Exception) : VkIdAuthPluginError(
    "initialization_failed",
    "Initialization failed",
    "An error occurred while initializing the plugin. Type: ${error.javaClass.kotlin}. " +
            "Message: ${error.message}. StackTrace: ${error.stackTrace}"
)

/// Ошибка получения [Context].
class VkIdAuthPluginContextNullError : VkIdAuthPluginError(
    "context_null",
    "Context is null",
    "An error occurred while trying to retrieve the Context"
)


/// Ошибка получения [LifecycleOwner].
class VkIdAuthPluginLifecycleOwnerNullError : VkIdAuthPluginError(
    "lifecycle_owner_null",
    "LifecycleOwner is null",
    "An error occurred while trying to retrieve the LifecycleOwner"
)

/// Ошибка возникающая при отмене авторизации.
class VkIdAuthPluginAuthCancelledError : VkIdAuthPluginError(
    "auth_cancelled",
    "Auth cancelled",
    "Auth cancelled by user"
)

/// Ошибка возникающая при попытке использовать плагин до инициализации.
class VkIdAuthPluginNotInitializedError : VkIdAuthPluginError(
    "not_initialized",
    "Not initialized",
    "Plugin has not been initialized"
)

/// Неизвестная ошибка авторизации.
class VkIdAuthPluginUnknownError(error: Exception? = null) : VkIdAuthPluginError(
    "unknown",
    "Unknown error",
    "Unknown error. Type: ${error?.javaClass?.kotlin}. Message: ${error?.message}. " +
            "StackTrace: ${error?.stackTrace}"
)