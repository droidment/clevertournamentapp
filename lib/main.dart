import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/core/config/env.dart';
import 'src/core/supabase/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  EnvConfig.validate();
  await SupabaseService.initialize();

  runApp(const ProviderScope(child: CleverTournamentApp()));
}
