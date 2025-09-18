import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_service.dart';
import '../models/team_model.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TeamRepository(client);
});

class TeamDraft {
  const TeamDraft({
    required this.tournamentId,
    required this.name,
    this.captainId,
    required this.city,
    required this.state,
    this.jerseyColor,
  });

  final String tournamentId;
  final String name;
  final String? captainId;
  final String city;
  final String state;
  final String? jerseyColor;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'tournament_id': tournamentId,
      'name': name,
      if (captainId != null) 'captain_id': captainId,
      'city': city,
      'state': state,
      if (jerseyColor != null && jerseyColor!.isNotEmpty)
        'jersey_color': jerseyColor,
    };
  }
}

class TeamRepository {
  TeamRepository(this._client);

  final SupabaseClient _client;

  Future<List<TeamModel>> fetchTeamsForTournament(String tournamentId) async {
    final dynamic response = await _client
        .from('teams')
        .select()
        .eq('tournament_id', tournamentId)
        .order('created_at');

    final rows = response as List<dynamic>;
    return rows
        .cast<Map<String, dynamic>>()
        .map(TeamModel.fromJson)
        .toList(growable: false);
  }

  Future<TeamModel> createTeam(TeamDraft draft) async {
    final Map<String, dynamic> response =
        await _client.from('teams').insert(draft.toJson()).select().single();

    return TeamModel.fromJson(response);
  }
}
