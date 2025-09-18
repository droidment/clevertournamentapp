import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@immutable
class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
  });

  factory AppUser.fromSupabaseUser(User user) {
    final metadata = user.userMetadata ?? <String, dynamic>{};
    final possibleNameKeys = <String>['full_name', 'name', 'display_name'];
    String? resolvedName;
    for (final key in possibleNameKeys) {
      final value = metadata[key];
      if (value is String && value.trim().isNotEmpty) {
        resolvedName = value.trim();
        break;
      }
    }

    final avatar = metadata['avatar_url'];

    return AppUser(
      id: user.id,
      email: user.email ?? '',
      fullName: resolvedName,
      avatarUrl: avatar is String && avatar.isNotEmpty ? avatar : null,
    );
  }

  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;

  AppUser copyWith({String? fullName, String? avatarUrl}) {
    return AppUser(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppUser &&
        other.id == id &&
        other.email == email &&
        other.fullName == fullName &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode => Object.hash(id, email, fullName, avatarUrl);
}
