import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';
import '../models/app_user.dart';

final authSessionProvider = StreamProvider<AppUser?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.sessionStream().map((session) {
    final user = session?.user;
    if (user == null) {
      return null;
    }
    return AppUser.fromSupabaseUser(user);
  });
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authSessionProvider);
  return authState.maybeWhen(data: (user) => user != null, orElse: () => false);
});
