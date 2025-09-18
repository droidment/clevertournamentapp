import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_service.dart';
import '../models/tournament_model.dart';

final tournamentRepositoryProvider = Provider<TournamentRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TournamentRepository(client);
});

class TournamentDraft {
  const TournamentDraft({
    required this.name,
    this.description,
    this.sport,
    this.format,
    this.startDate,
    this.endDate,
    this.location,
  });

  final String name;
  final String? description;
  final TournamentSport? sport;
  final TournamentFormat? format;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? location;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      if (description != null) 'description': description,
      if (sport != null) 'sport': _mapSportToJson(sport!),
      if (format != null) 'format': _mapFormatToJson(format!),
      if (startDate != null) 'start_date': startDate!.toIso8601String(),
      if (endDate != null) 'end_date': endDate!.toIso8601String(),
      if (location != null) 'location': location,
    };
  }
}

class TournamentRepository {
  TournamentRepository(this._client);

  final SupabaseClient _client;

  Future<List<TournamentModel>> fetchTournaments({int limit = 50}) async {
    final dynamic response = await _client
        .from('tournaments')
        .select()
        .order('start_date', ascending: true)
        .limit(limit);

    final List<dynamic> rows = response as List<dynamic>;
    return rows
        .cast<Map<String, dynamic>>()
        .map(TournamentModel.fromJson)
        .toList();
  }

  Future<TournamentModel> fetchTournament(String id) async {
    final Map<String, dynamic> response =
        await _client.from('tournaments').select().eq('id', id).single();

    return TournamentModel.fromJson(response);
  }

  Future<TournamentModel> createTournament(TournamentDraft draft) async {
    final Map<String, dynamic> response =
        await _client
            .from('tournaments')
            .insert(draft.toJson())
            .select()
            .single();

    return TournamentModel.fromJson(response);
  }

  Future<TournamentModel> updateTournament(
    String id,
    TournamentDraft draft,
  ) async {
    final Map<String, dynamic> response = await _client
        .from('tournaments')
        .update(draft.toJson())
        .eq('id', id)
        .select()
        .single();

    return TournamentModel.fromJson(response);
  }

  Future<void> deleteTournament(String id) async {
    await _client.from('tournaments').delete().eq('id', id);
  }
}

String _mapSportToJson(TournamentSport sport) => switch (sport) {
  TournamentSport.volleyball => 'volleyball',
  TournamentSport.pickleball => 'pickleball',
  TournamentSport.other => 'other',
};

String _mapFormatToJson(TournamentFormat format) => switch (format) {
  TournamentFormat.roundRobin => 'round_robin',
  TournamentFormat.singleElimination => 'single_elimination',
  TournamentFormat.doubleElimination => 'double_elimination',
  TournamentFormat.swissSystem => 'swiss_system',
  TournamentFormat.hybridPoolPlayoff => 'hybrid_pool_playoff',
};
