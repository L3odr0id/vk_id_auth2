import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:vk_id_auth2/entity/entity.dart';

import 'vk_id_auth_platform_interface.dart';

/// An implementation of [VkIdAuthPlatform] that uses method channels.
@immutable
final class MethodChannelVkIdAuth extends VkIdAuthPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('vk_id_auth');

  @override
  Future<VkIdAuthData?> login(List<String> scope) async {
    final map = await methodChannel
        .invokeMethod<Map<Object?, Object?>>(loginMethodName, {'scope': scope});
    if (map == null) return null;
    return VkIdAuthData.fromMap(map);
  }

  @override
  Future<void> initialize() =>
      methodChannel.invokeMethod<void>(initializeMethodName);

  @override
  Future<bool> get isInitialized async {
    final isInitialized =
        await methodChannel.invokeMethod<bool>(isInitializedMethodName);
    return isInitialized ?? false;
  }

  @override
  Future<Map<Object?, Object?>?> getUserData() async {
    final map = await methodChannel
        .invokeMethod<Map<Object?, Object?>>(getUserDataMethodName);
    return map;
  }
}
