import 'package:meta/meta.dart';

/// User data.
@immutable
class VkIdUserData {
  /// Name of user.
  final String firstName;

  /// Last name of user.
  final String lastName;

  /// Users email.
  final String? email;

  /// Users phone.
  final String? phone;

  /// Creates user data.
  const VkIdUserData._({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  /// Convert Map<Object?, Object?> to VkIdUserData.
  factory VkIdUserData.fromMap(Map<Object?, Object?> map) => VkIdUserData._(
        firstName: map['firstName'] as String,
        lastName: map['lastName'] as String,
        email: map['email'] as String?,
        phone: map['phone'] as String?,
      );
}
