import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/tournament_repository.dart';
import '../models/tournament_model.dart';

final tournamentDetailProvider = FutureProvider.autoDispose
    .family<TournamentModel, String>((ref, String id) async {
      final repository = ref.watch(tournamentRepositoryProvider);
      return repository.fetchTournament(id);
    });

final tournamentsListControllerProvider = StateNotifierProvider.autoDispose<
  TournamentsListController,
  AsyncValue<List<TournamentModel>>
>((ref) {
  final repository = ref.watch(tournamentRepositoryProvider);
  return TournamentsListController(repository, ref)..load();
});

class TournamentsListController
    extends StateNotifier<AsyncValue<List<TournamentModel>>> {
  TournamentsListController(this._repository, this._ref)
    : super(const AsyncValue.loading());

  final TournamentRepository _repository;
  final Ref _ref;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final tournaments = await _repository.fetchTournaments();
      state = AsyncValue.data(tournaments);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    try {
      final tournaments = await _repository.fetchTournaments();
      state = AsyncValue.data(tournaments);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<TournamentModel> createTournament(TournamentDraft draft) async {
    try {
      final created = await _repository.createTournament(draft);
      final current = state.value ?? <TournamentModel>[];
      state = AsyncValue.data(<TournamentModel>[created, ...current]);

      _ref.invalidate(tournamentDetailProvider(created.id));
      return created;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<TournamentModel> updateTournament(
    String id,
    TournamentDraft draft,
  ) async {
    try {
      final updated = await _repository.updateTournament(id, draft);
      final current = state.value ?? <TournamentModel>[];
      final next = current
          .map((t) => t.id == id ? updated : t)
          .toList(growable: false);
      state = AsyncValue.data(next);
      _ref.invalidate(tournamentDetailProvider(id));
      return updated;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteTournament(String id) async {
    try {
      await _repository.deleteTournament(id);
      final current = state.value ?? <TournamentModel>[];
      final next = current.where((t) => t.id != id).toList(growable: false);
      state = AsyncValue.data(next);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}
