import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_service.dart';
import '../../auth/models/app_user.dart';
import '../models/profile_model.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ProfileRepository(client);
});

class ProfileRepository {
  ProfileRepository(this._client);

  final SupabaseClient _client;

  Future<ProfileModel> fetchProfile(String id) async {
    final Map<String, dynamic>? response =
        await _client.from('profiles').select().eq('id', id).maybeSingle();

    if (response == null) {
      throw StateError('Profile not found for id $id');
    }

    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> fetchOrCreateProfile(AppUser user) async {
    final Map<String, dynamic>? existing =
        await _client.from('profiles').select().eq('id', user.id).maybeSingle();

    if (existing != null) {
      return ProfileModel.fromJson(existing);
    }

    final payload = <String, dynamic>{
      'id': user.id,
      'email': user.email,
      if (user.fullName != null && user.fullName!.isNotEmpty)
        'full_name': user.fullName,
      if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
        'avatar_url': user.avatarUrl,
    };

    final Map<String, dynamic> inserted =
        await _client.from('profiles').insert(payload).select().single();

    return ProfileModel.fromJson(inserted);
  }

  Future<ProfileModel> updateProfile(
    String id, {
    required String fullName,
    String? phone,
  }) async {
    final payload = <String, dynamic>{
      'full_name': fullName,
      'updated_at': DateTime.now().toIso8601String(),
      'phone': phone,
    };

    final Map<String, dynamic> response =
        await _client
            .from('profiles')
            .update(payload)
            .eq('id', id)
            .select()
            .single();

    await _client.auth.updateUser(
      UserAttributes(
        data: <String, dynamic>{
          'full_name': fullName,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
        },
      ),
    );

    return ProfileModel.fromJson(response);
  }
}
