import Flutter

/// Класс ошибки плагина.
final class VkIdAuthPluginError {
    /// Код.
    private let code: String

    /// Сообщение.
    private let message: String

    /// Подробности.
    private let details: String

    /// Ошибка.
    private let error: Error?

    private init(code: String, message: String, details: String, error: Error? = nil) {
        self.code = code
        self.message = message
        self.details = details
        self.error = error
        var logMessage = "[VkIdAuthPluginError] | Code: \(code). Message: \(message). Details: \(details)"
        if (error != nil) {
            logMessage += ". Error description: \(error!.localizedDescription)"
        }
        VkIdAuthPluginLogger.log(logMessage)
    }

    /// Конвертирует [VkIdAuthPluginError] в [FlutterError].
    private var toFlutterError: FlutterError {
        return FlutterError(code: code, message: message, details: details)
    }
    
    /// Ошибка получения строки CLIENT_ID из info.plist.
    static let readClientIdError: FlutterError = VkIdAuthPluginError(code: "cant_read_client_id",
                                                  message: "Failed to get CLIENT_ID",
                                                  details: "An error occurred while trying to get the CLIENT_ID").toFlutterError
    
    /// Ошибка получения строки CLIENT_SECRET из info.plist.
    static let readClientSecretError: FlutterError = VkIdAuthPluginError(code: "cant_read_client_secret",
                                                  message: "Failed to get CLIENT_SECRET",
                                                  details: "An error occurred while trying to get the CLIENT_SECRET").toFlutterError
    
    /// Ошибка получения [UIViewController].
    static let uiViewControllerNullError: FlutterError = VkIdAuthPluginError(code: "ui_view_controller_null",
                                                                         message: "UIViewController is null",
                                                                         details: "An error occurred while trying to retrieve the UIViewController").toFlutterError
    
    /// Ошибка возникающая при отмене авторизации.
    static let authCancelledError: FlutterError = VkIdAuthPluginError(code: "auth_cancelled",
                                                                      message: "Auth cancelled",
                                                                      details: "Auth cancelled by user").toFlutterError
    
    /// Ошибка возникающая при попытке использовать плагин до инициализации.
    static let notInitializedError: FlutterError = VkIdAuthPluginError(code: "not_initialized",
                                                                      message: "Not initialized",
                                                                      details: "Plugin has not been initialized").toFlutterError
    
    /// Ошибка возникающая при попытке авторизации, когда она уже в процессе.
    static let authAlreadyInProgress: FlutterError = VkIdAuthPluginError(code: "auth_already_in_progress",
                                                                      message: "Auth already in progress",
                                                                      details: "Authorization was called when auth is already in progress").toFlutterError
    
    /// Возвращает ошибку инициализации плагина.
    static public func initializationError(error: Error?) -> FlutterError {
        return VkIdAuthPluginError(code: "initialization_failed",
                                   message: "Initialization failed",
                                   details: "An error occurred while initializing the plugin",
                                   error: error).toFlutterError
    }
    
    /// Неизвестная ошибка авторизации.
    static public func unknownError(error: Error?) -> FlutterError {
        return VkIdAuthPluginError(code: "unknown",
                                   message: "Unknown error",
                                   details: "An unknown error occurred during authorization",
                                   error: error).toFlutterError
    }
}
