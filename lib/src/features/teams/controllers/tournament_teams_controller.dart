import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/team_repository.dart';
import '../models/team_model.dart';

final tournamentTeamsControllerProvider = StateNotifierProvider.autoDispose
    .family<TournamentTeamsController, AsyncValue<List<TeamModel>>, String>((
      ref,
      String tournamentId,
    ) {
      final repository = ref.watch(teamRepositoryProvider);
      return TournamentTeamsController(repository, tournamentId)..load();
    });

class TournamentTeamsController
    extends StateNotifier<AsyncValue<List<TeamModel>>> {
  TournamentTeamsController(this._repository, this._tournamentId)
    : super(const AsyncValue.loading());

  final TeamRepository _repository;
  final String _tournamentId;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final teams = await _repository.fetchTeamsForTournament(_tournamentId);
      state = AsyncValue.data(teams);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    try {
      final teams = await _repository.fetchTeamsForTournament(_tournamentId);
      state = AsyncValue.data(teams);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<TeamModel> registerTeam(TeamDraft draft) async {
    try {
      final created = await _repository.createTeam(draft);
      final current = state.value ?? <TeamModel>[];
      state = AsyncValue.data(<TeamModel>[created, ...current]);
      return created;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}
