import 'package:meta/meta.dart';
import 'package:vk_id_auth2/entity/entity.dart';

import 'vk_id_auth_platform_interface.dart';

/// Class interface for using VK ID SDK platform methods.
@immutable
abstract interface class IVkIdAuth {
  /// Authorizes using VK ID SDK.
  Future<VkIdAuthData?> login([List<String> scope = const []]);

  /// Initializes the plugin.
  Future<void> initialize();

  /// Returns true if the plugin is initialized, false otherwise.
  Future<bool> get isInitialized;

  /// Initializes the plugin.
  Future<Map<Object?, Object?>?> getUserData();
}

/// Class for using VK ID SDK platform methods.
@immutable
final class VkIdAuth implements IVkIdAuth {
  /// Creates a class for using VK ID SDK platform methods.
  const VkIdAuth();

  @override
  Future<VkIdAuthData?> login([List<String> scope = const []]) =>
      VkIdAuthPlatform.instance.login(scope);

  @override
  Future<void> initialize() => VkIdAuthPlatform.instance.initialize();

  @override
  Future<bool> get isInitialized => VkIdAuthPlatform.instance.isInitialized;

  @override
  Future<Map<Object?, Object?>?> getUserData() =>
      VkIdAuthPlatform.instance.getUserData();
}
