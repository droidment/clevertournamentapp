import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../../../core/supabase/supabase_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepository(client);
});

class AuthRepository {
  AuthRepository(this._client);

  final SupabaseClient _client;

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return _client.auth.signUp(email: email, password: password);
  }

  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: EnvConfig.redirectUrlOrNull,
      queryParams: const <String, String>{
        'access_type': 'offline',
        'prompt': 'consent',
      },
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Session? currentSession() => _client.auth.currentSession;

  User? currentUser() => _client.auth.currentUser;

  Stream<Session?> sessionStream() async* {
    yield _client.auth.currentSession;
    yield* _client.auth.onAuthStateChange.map((AuthState data) => data.session);
  }
}
