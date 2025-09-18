import 'package:clevertournamentapp/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../controllers/tournaments_list_controller.dart';
import '../models/tournament_model.dart';
import 'tournament_create_dialog.dart';

class TournamentsPage extends ConsumerWidget {
  const TournamentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentsState = ref.watch(tournamentsListControllerProvider);
    final controller = ref.read(tournamentsListControllerProvider.notifier);

    Future<void> handleCreate() async {
      final String? createdId = await showTournamentCreateDialog(context, ref);
      if (!context.mounted || createdId == null) {
        return;
      }
      context.goNamed(
        AppRoute.tournamentDetail.name,
        pathParameters: <String, String>{'id': createdId},
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tournament created.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournaments'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Profile',
            onPressed: () => context.goNamed(AppRoute.profile.name),
            icon: const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person_outline, size: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: FilledButton.icon(
              onPressed: handleCreate,
              icon: const Icon(Icons.add),
              label: const Text('Create tournament'),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: tournamentsState.when(
          data: (tournaments) {
            if (tournaments.isEmpty) {
              return _EmptyState(onCreate: handleCreate);
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              itemBuilder: (BuildContext context, int index) {
                final tournament = tournaments[index];
                return _TournamentCard(tournament: tournament);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: tournaments.length,
            );
          },
          loading: () => const _LoadingView(),
          error:
              (error, stackTrace) =>
                  _ErrorView(error: error, onRetry: controller.load),
        ),
      ),
    );
  }
}

class _TournamentCard extends StatelessWidget {
  const _TournamentCard({required this.tournament});

  final TournamentModel tournament;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String dateRange = _formatDateRange(
      tournament.startDate,
      tournament.endDate,
    );
    final String subtitle = [
      if (dateRange.isNotEmpty) dateRange,
      if (tournament.location?.isNotEmpty ?? false) tournament.location!,
    ].join(' | ');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(tournament.name, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 6),
                      if (subtitle.isNotEmpty)
                        Text(subtitle, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                _StatusPill(status: tournament.status),
              ],
            ),
            if (tournament.description?.isNotEmpty ?? false) ...<Widget>[
              const SizedBox(height: 12),
              Text(tournament.description!, style: theme.textTheme.bodyMedium),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: <Widget>[
                if (tournament.sport != null)
                  Chip(
                    avatar: const Icon(
                      Icons.sports_volleyball_outlined,
                      size: 18,
                    ),
                    label: Text(_formatSportLabel(tournament.sport!)),
                  ),
                if (tournament.format != null)
                  Chip(
                    avatar: const Icon(Icons.table_chart_outlined, size: 18),
                    label: Text(_formatFormatLabel(tournament.format!)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                onPressed:
                    () => context.goNamed(
                      AppRoute.tournamentDetail.name,
                      pathParameters: <String, String>{'id': tournament.id},
                    ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('View details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final TournamentStatus? status;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TournamentStatus resolved = status ?? TournamentStatus.draft;
    final (Color bg, Color fg, String label) = switch (resolved) {
      TournamentStatus.draft => (
        colors.surfaceContainerHighest,
        colors.onSurface,
        'Draft',
      ),
      TournamentStatus.registrationOpen => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
        'Registration open',
      ),
      TournamentStatus.registrationClosed => (
        colors.surfaceContainerHighest,
        colors.onSurface,
        'Registration closed',
      ),
      TournamentStatus.inProgress => (
        colors.tertiaryContainer,
        colors.onTertiaryContainer,
        'In progress',
      ),
      TournamentStatus.completed => (
        colors.secondaryContainer,
        colors.onSecondaryContainer,
        'Completed',
      ),
      TournamentStatus.cancelled => (
        colors.errorContainer,
        colors.onErrorContainer,
        'Cancelled',
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: fg),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate});

  final Future<void> Function() onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: <Widget>[
        const SizedBox(height: 120),
        Icon(Icons.flag_outlined, size: 72, color: colors.primary),
        const SizedBox(height: 16),
        Text(
          'No tournaments yet',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'Start by creating your first tournament. You can add teams, configure pools, and publish schedules in minutes.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 24),
        Align(
          child: FilledButton.icon(
            onPressed: () => onCreate(),
            icon: const Icon(Icons.add),
            label: const Text('Create tournament'),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: <Widget>[
        const SizedBox(height: 120),
        Icon(
          Icons.cloud_off_outlined,
          size: 72,
          color: theme.colorScheme.error,
        ),
        const SizedBox(height: 16),
        Text(
          'Unable to load tournaments',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            '$error',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 24),
        Align(
          child: FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 120),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

String _formatDateRange(DateTime? start, DateTime? end) {
  if (start == null && end == null) {
    return '';
  }

  final DateFormat formatter = DateFormat('MMM d, yyyy');
  if (start != null && end != null) {
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }
  if (start != null) {
    return formatter.format(start);
  }
  return formatter.format(end!);
}

String _formatSportLabel(TournamentSport sport) => switch (sport) {
  TournamentSport.volleyball => 'Volleyball',
  TournamentSport.pickleball => 'Pickleball',
  TournamentSport.other => 'Other sport',
};

String _formatFormatLabel(TournamentFormat format) => switch (format) {
  TournamentFormat.roundRobin => 'Round robin',
  TournamentFormat.singleElimination => 'Single elimination',
  TournamentFormat.doubleElimination => 'Double elimination',
  TournamentFormat.swissSystem => 'Swiss system',
  TournamentFormat.hybridPoolPlayoff => 'Hybrid pool & playoff',
};
