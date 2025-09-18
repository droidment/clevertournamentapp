import 'package:flutter/foundation.dart';

/// Centralized environment configuration for compile-time values.
@immutable
class EnvConfig {
  const EnvConfig._();

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://htuibmikqrsouqjrpotl.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh0dWlibWlrcXJzb3VxanJwb3RsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgxMjA3MDcsImV4cCI6MjA3MzY5NjcwN30.lICkLobpH0mx8NgJDc8BptLg7t-CP5u2gnvGXGXnR2k',
  );

  static const String supabaseRedirectUrl = String.fromEnvironment(
    'SUPABASE_REDIRECT_URL',
    defaultValue: '',
  );

  static String? get redirectUrlOrNull =>
      supabaseRedirectUrl.isEmpty ? null : supabaseRedirectUrl;

  static void validate() {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw StateError(
        'Supabase configuration missing. Provide SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define.',
      );
    }
  }

  static Map<String, String> maskedValues() => <String, String>{
    'supabaseUrl': supabaseUrl,
    'supabaseAnonKey':
        supabaseAnonKey.isEmpty
            ? ''
            : '${supabaseAnonKey.substring(0, 6)}...${supabaseAnonKey.substring(supabaseAnonKey.length - 4)}',
    'supabaseRedirectUrl': supabaseRedirectUrl,
  };
}
