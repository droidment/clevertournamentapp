import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controllers/auth_session_providers.dart';
import '../../auth/models/app_user.dart';
import '../data/profile_repository.dart';
import '../models/profile_model.dart';

final currentProfileProvider =
    AutoDisposeAsyncNotifierProvider<CurrentProfileNotifier, ProfileModel?>(
      CurrentProfileNotifier.new,
    );

class CurrentProfileNotifier extends AutoDisposeAsyncNotifier<ProfileModel?> {
  late final ProfileRepository _repository;

  @override
  Future<ProfileModel?> build() async {
    _repository = ref.watch(profileRepositoryProvider);
    final AppUser? user = await ref.watch(authSessionProvider.future);
    if (user == null) {
      return null;
    }
    return _repository.fetchOrCreateProfile(user);
  }

  Future<void> saveProfile({required String fullName, String? phone}) async {
    final AppUser? user = await ref.watch(authSessionProvider.future);
    if (user == null) {
      return;
    }

    final String trimmedPhone = phone?.trim() ?? '';

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.updateProfile(
        user.id,
        fullName: fullName.trim(),
        phone: trimmedPhone.isEmpty ? null : trimmedPhone,
      ),
    );
  }

  Future<void> refreshProfile() async {
    final AppUser? user = await ref.watch(authSessionProvider.future);
    if (user == null) {
      state = const AsyncData(null);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.fetchProfile(user.id));
  }
}
