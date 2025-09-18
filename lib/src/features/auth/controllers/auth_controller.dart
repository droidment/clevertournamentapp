import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
      final repository = ref.watch(authRepositoryProvider);
      return AuthController(repository);
    });

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._repository) : super(const AsyncData(null));

  final AuthRepository _repository;

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      await _repository.signInWithEmail(email: email, password: password);
      state = const AsyncData(null);
    } on AuthException catch (error, stackTrace) {
      state = AsyncError<Object>(error, stackTrace);
    } catch (error, stackTrace) {
      state = AsyncError<Object>(error, stackTrace);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      await _repository.signInWithGoogle();
      state = const AsyncData(null);
    } on AuthException catch (error, stackTrace) {
      state = AsyncError<Object>(error, stackTrace);
    } catch (error, stackTrace) {
      state = AsyncError<Object>(error, stackTrace);
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      await _repository.signUpWithEmail(email: email, password: password);
      state = const AsyncData(null);
    } on AuthException catch (error, stackTrace) {
      state = AsyncError<Object>(error, stackTrace);
    } catch (error, stackTrace) {
      state = AsyncError<Object>(error, stackTrace);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await _repository.signOut();
      state = const AsyncData(null);
    } on AuthException catch (error, stackTrace) {
      state = AsyncError<Object>(error, stackTrace);
    } catch (error, stackTrace) {
      state = AsyncError<Object>(error, stackTrace);
    }
  }
}
