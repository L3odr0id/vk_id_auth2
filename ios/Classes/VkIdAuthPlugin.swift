import Flutter
import UIKit
import VKID

public class VkIdAuthPlugin: NSObject, FlutterPlugin {
    
  /// Название [MethodChannel] плагина.
  private static let methodChannelName: String = "vk_id_auth"
    
  /// Название метода initialize().
  private let initializeMethodName: String = "initialize"

  /// Название метода login().
  private let loginMethodName: String = "login"
    
  /// Название метода isInitialized.
  private let isInitializedMethodName: String = "isInitialized"

  enum LogInArg: String {
    case scope
}
    
  /// Экземпляр VKID.
  private var vkId: VKID? = nil
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: methodChannelName, binaryMessenger: registrar.messenger())
    let instance = VkIdAuthPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)
  }
    
  public func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        return vkId?.open(url: url) ?? false
    }
    
  public func detachFromEngine(for registrar: any FlutterPluginRegistrar) {
    vkId = nil
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case initializeMethodName:
      VkIdAuthPluginLogger.log("[\(initializeMethodName)] was called")
      initialize(result: result)
    case loginMethodName:
      VkIdAuthPluginLogger.log("[\(loginMethodName)] was called")
        if let arguments = call.arguments as? [String: Any],
                   let permissionsArg = arguments["scope"] as? [String] {
                    login(result: result, permissions: permissionsArg)
                } else {
                    VkIdAuthPluginLogger.log("Failed to extract 'scope' argument for login")
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing or invalid 'scope' argument", details: nil))
                }
    case isInitializedMethodName:
      VkIdAuthPluginLogger.log("[\(isInitializedMethodName)] was called")
      result(isInitialized)
    default:
      VkIdAuthPluginLogger.log("[\(call.method)] has not been implemented")
      result(FlutterMethodNotImplemented)
    }
  }
    
  /// Возвращает true, если плагин инициализирован, иначе false.
  var isInitialized: Bool {
      get {
        return vkId != nil
      }
  }

  /// Инициализирует плагин.
  private func initialize(result: @escaping FlutterResult) {
    do {
        guard let clientId = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String else {
            return result(VkIdAuthPluginError.readClientIdError)
        }
        guard let clientSecret = Bundle.main.object(forInfoDictionaryKey: "CLIENT_SECRET") as? String else {
            return result(VkIdAuthPluginError.readClientSecretError)
        }
        vkId = try VKID(
            config: Configuration(
                appCredentials: AppCredentials(
                    clientId: clientId,
                    clientSecret: clientSecret
                    )
            )
        )
        result(nil)
    } catch {
        result(VkIdAuthPluginError.initializationError(error: error))
    }
  }
    
  /// Авторизирует с помощью VK ID SDK.
  private func login(result: @escaping FlutterResult, permissions: [String]) {
          if (!isInitialized) {
              return result(VkIdAuthPluginError.notInitializedError)
          }
          guard let viewController: UIViewController = UIApplication.shared.keyWindow?.rootViewController else {
              return result(VkIdAuthPluginError.uiViewControllerNullError)
          }
          let uiKitPresenter: UIKitPresenter = UIKitPresenter.uiViewController(viewController)
          let authConfiguration = AuthConfiguration(
                scope: Scope(Set(permissions))
          )
      vkId?.authorize(with: authConfiguration, using: uiKitPresenter, completion: { authResult in
              do {
                let session = try authResult.get()
                VkIdAuthPluginLogger.log("Auth succeeded")
                  session.fetchUser { userFetchingResult in
        
                      do {
                          let user = try userFetchingResult.get()
                              var dictionary = Dictionary<String, Any?>()
                              let token = session.accessToken.value
                              let userId = user.id.value
                              let userData = user.toDictionary
                              dictionary.updateValue(token, forKey: "token")
                              dictionary.updateValue(userId, forKey: "userId")
                              dictionary.updateValue(userData, forKey: "userData")
                          return result(dictionary)
                      }catch{
                          return result(VkIdAuthPluginError.unknownError(error: error))
                      }
                  }
//                return result(session.toDictionary)
              } catch AuthError.cancelled {
                return result(VkIdAuthPluginError.authCancelledError)
              } catch AuthError.authAlreadyInProgress {
                return result(VkIdAuthPluginError.authAlreadyInProgress)
              } catch {
                return result(VkIdAuthPluginError.unknownError(error: error))
              }
            }
          )
  }
}
