import 'package:meta/meta.dart';
import 'package:vk_id_auth2/entity/entity.dart';

/// Data received in case of successful authorization using VK ID SDK.
@immutable
class VkIdAuthData {
  /// Access token.
  final String token;

  /// User ID.
  final int userId;

  /// User data. First name, last name, email, phone.
  final VkIdUserData userData;

  /// Creates data received in case of successful authorization using
  /// VK ID SDK.
  const VkIdAuthData._({
    required this.token,
    required this.userId,
    required this.userData,
  });

  /// Converts Map<Object?, Object?> to VkIdAuthData.
  factory VkIdAuthData.fromMap(Map<Object?, Object?> map) => VkIdAuthData._(
        token: map['token'] as String,
        userId: map['userId'] as int,
        userData: VkIdUserData.fromMap(
          map['userData'] as Map<Object?, Object?>,
        ),
      );
}
