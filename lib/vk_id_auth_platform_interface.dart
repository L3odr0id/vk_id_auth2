import 'package:meta/meta.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vk_id_auth2/entity/entity.dart';

import 'vk_id_auth_method_channel.dart';

@immutable
abstract base class VkIdAuthPlatform extends PlatformInterface {
  /// Constructs a VkIdAuthPlatform.
  VkIdAuthPlatform() : super(token: _token);

  static final Object _token = Object();

  static VkIdAuthPlatform _instance = MethodChannelVkIdAuth();

  /// The default instance of [VkIdAuthPlatform] to use.
  ///
  /// Defaults to [MethodChannelVkIdAuth].
  static VkIdAuthPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VkIdAuthPlatform] when
  /// they register themselves.
  static set instance(VkIdAuthPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns the name of the login() method.
  String get loginMethodName => "login";

  /// Returns the name of the initialization() method.
  String get initializeMethodName => "initialize";

  /// Returns the name of the isInitialized method.
  String get isInitializedMethodName => "isInitialized";

  /// Returns the name of the getUserData() method.
  String get getUserDataMethodName => "getUserData";

  /// Authorizes using VK ID SDK.
  Future<VkIdAuthData?> login(List<String> scope) =>
      throw UnimplementedError('login() has not been implemented.');

  /// Initializes the plugin.
  Future<void> initialize() =>
      throw UnimplementedError('initialize() has not been implemented.');

  /// Returns true if the plugin is initialized, false otherwise.
  Future<bool> get isInitialized =>
      throw UnimplementedError('isInitialized has not been implemented.');

  /// Returns true if the plugin is initialized, false otherwise.
  Future<Map<Object?, Object?>?> getUserData() => throw UnimplementedError(
        '$getUserDataMethodName has not been implemented.',
      );
}
