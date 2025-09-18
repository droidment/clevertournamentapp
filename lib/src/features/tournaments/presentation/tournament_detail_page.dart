import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../teams/controllers/tournament_teams_controller.dart';
import '../../teams/models/team_model.dart';
import '../../teams/presentation/team_registration_dialog.dart';
import '../controllers/tournaments_list_controller.dart';
import '../models/tournament_model.dart';

class TournamentDetailPage extends ConsumerWidget {
  const TournamentDetailPage({required this.tournamentId, super.key});
  final String tournamentId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentAsync = ref.watch(tournamentDetailProvider(tournamentId));
    return tournamentAsync.when(
      data:
          (tournament) => _TournamentDetailLoaded(
            tournamentId: tournamentId,
            tournament: tournament,
          ),
      loading: () => const _TournamentDetailLoading(),
      error:
          (error, stackTrace) => _TournamentDetailErrorView(
            error: error,
            onRetry: () => ref.refresh(tournamentDetailProvider(tournamentId)),
          ),
    );
  }
}

class _TournamentDetailLoaded extends ConsumerWidget {
  const _TournamentDetailLoaded({
    required this.tournamentId,
    required this.tournament,
  });
  final String tournamentId;
  final TournamentModel tournament;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> handleRefresh() {
      return ref.refresh(tournamentDetailProvider(tournamentId).future);
    }

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(tournament.name),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Overview'),
              Tab(text: 'Teams'),
              Tab(text: 'Pools'),
              Tab(text: 'Schedule'),
              Tab(text: 'Standings'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            RefreshIndicator(
              onRefresh: handleRefresh,
              child: _OverviewTab(tournament: tournament),
            ),
            _TeamsTab(tournament: tournament),
            const _PlaceholderTab(
              icon: Icons.grid_view_outlined,
              title: 'Pools',
              description:
                  'Pool management and team assignments will appear here soon.',
            ),
            const _PlaceholderTab(
              icon: Icons.calendar_today_outlined,
              title: 'Schedule',
              description:
                  'Auto-generated schedules and manual adjustments are in progress.',
            ),
            const _PlaceholderTab(
              icon: Icons.leaderboard_outlined,
              title: 'Standings',
              description:
                  'Live standings dashboards will arrive once scoring is wired up.',
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.tournament});
  final TournamentModel tournament;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chips = <Widget>[
      _StatusChip(status: tournament.status),
      if (tournament.sport != null)
        Chip(
          avatar: const Icon(Icons.sports_volleyball_outlined, size: 18),
          label: Text(_sportLabel(tournament.sport!)),
        ),
      if (tournament.format != null)
        Chip(
          avatar: const Icon(Icons.table_chart_outlined, size: 18),
          label: Text(_formatLabel(tournament.format!)),
        ),
    ];
    final String dateRange = _formatDateRange(
      tournament.startDate,
      tournament.endDate,
    );
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      children: <Widget>[
        Text(tournament.name, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 12),
        Wrap(spacing: 12, runSpacing: 8, children: chips),
        const SizedBox(height: 24),
        if (dateRange.isNotEmpty)
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Dates',
            value: dateRange,
          ),
        if (tournament.location?.isNotEmpty ?? false)
          _DetailRow(
            icon: Icons.place_outlined,
            label: 'Location',
            value: tournament.location!,
          ),
        if (tournament.venueAddress?.isNotEmpty ?? false)
          _DetailRow(
            icon: Icons.location_city_outlined,
            label: 'Venue',
            value: tournament.venueAddress!,
          ),
        if (tournament.description?.isNotEmpty ?? false) ...<Widget>[
          const SizedBox(height: 24),
          Text('About', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(tournament.description!, style: theme.textTheme.bodyLarge),
        ],
        const SizedBox(height: 32),
        Text('Next steps', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          'Manage pools, schedules, and registrations from the upcoming tabs. These sections will unlock as the feature set grows.',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _TeamsTab extends ConsumerWidget {
  const _TeamsTab({required this.tournament});
  final TournamentModel tournament;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(
      tournamentTeamsControllerProvider(tournament.id),
    );
    final controller = ref.read(
      tournamentTeamsControllerProvider(tournament.id).notifier,
    );
    Future<void> handleRegisterTeam() async {
      await showTeamRegistrationDialog(context, ref, tournament.id);
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: teamsAsync.when(
        data: (teams) {
          if (teams.isEmpty) {
            return _TeamsEmptyState(onRegister: handleRegisterTeam);
          }
          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return _TeamsHeader(
                  registeredCount: teams.length,
                  maxTeams: tournament.maxTeams,
                  onRegister: handleRegisterTeam,
                );
              }
              final team = teams[index - 1];
              return _TeamCard(team: team);
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: teams.length + 1,
          );
        },
        loading: () => const _TeamsLoadingView(),
        error:
            (error, stackTrace) =>
                _TeamsErrorView(error: error, onRetry: controller.refresh),
      ),
    );
  }
}

class _TeamsHeader extends StatelessWidget {
  const _TeamsHeader({
    required this.registeredCount,
    required this.onRegister,
    this.maxTeams,
  });
  final int registeredCount;
  final int? maxTeams;
  final Future<void> Function() onRegister;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final subtitle =
        maxTeams != null
            ? '$registeredCount of $maxTeams teams registered'
            : '$registeredCount teams registered';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Team registrations',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => onRegister(),
              icon: const Icon(Icons.app_registration),
              label: const Text('Register team'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard({required this.team});
  final TeamModel team;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final registrationStatus =
        team.registrationStatus ?? TeamRegistrationStatus.pending;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(team.name, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 6),
                      if (team.city != null || team.state != null)
                        Text(
                          [
                            if (team.city?.isNotEmpty ?? false) team.city!,
                            if (team.state?.isNotEmpty ?? false) team.state!,
                          ].join(', '),
                          style: theme.textTheme.bodyMedium,
                        ),
                      if (team.jerseyColor != null &&
                          team.jerseyColor!.isNotEmpty)
                        Text(
                          'Jersey color: \${team.jerseyColor}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.primary,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _teamStatusBackground(registrationStatus, colors),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _teamStatusLabel(registrationStatus),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: _teamStatusForeground(registrationStatus, colors),
                    ),
                  ),
                ),
              ],
            ),
            if (team.seed != null) ...<Widget>[
              const SizedBox(height: 12),
              Text(
                'Seed ${team.seed}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TeamsEmptyState extends StatelessWidget {
  const _TeamsEmptyState({required this.onRegister});
  final Future<void> Function() onRegister;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: <Widget>[
        const SizedBox(height: 120),
        Icon(Icons.groups_outlined, size: 72, color: colors.primary),
        const SizedBox(height: 16),
        Text(
          'No teams yet',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Be the first to register for this tournament. Share your team details and the organizer will confirm your spot.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        Align(
          child: FilledButton.icon(
            onPressed: () => onRegister(),
            icon: const Icon(Icons.app_registration),
            label: const Text('Register a team'),
          ),
        ),
      ],
    );
  }
}

class _TeamsLoadingView extends StatelessWidget {
  const _TeamsLoadingView();
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

class _TeamsErrorView extends StatelessWidget {
  const _TeamsErrorView({required this.error, required this.onRetry});
  final Object error;
  final Future<void> Function() onRetry;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: <Widget>[
        const SizedBox(height: 120),
        Icon(Icons.cloud_off_outlined, size: 72, color: colors.error),
        const SizedBox(height: 16),
        Text(
          'Unable to load teams',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          '$error',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
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

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({
    required this.icon,
    required this.title,
    required this.description,
  });
  final IconData icon;
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 72, color: colors.primary),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _TournamentDetailLoading extends StatelessWidget {
  const _TournamentDetailLoading();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _TournamentDetailErrorView extends StatelessWidget {
  const _TournamentDetailErrorView({
    required this.error,
    required this.onRetry,
  });
  final Object error;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Tournament')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.cloud_off_outlined, size: 72, color: colors.error),
              const SizedBox(height: 16),
              Text(
                'Unable to load tournament',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: theme.textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final TournamentStatus? status;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final resolvedStatus = status ?? TournamentStatus.draft;
    final label = _statusLabel(resolvedStatus);
    final colorPair = _statusChipColors(resolvedStatus, colors);
    return Chip(
      backgroundColor: colorPair.$1,
      label: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(color: colorPair.$2),
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

String _sportLabel(TournamentSport sport) => switch (sport) {
  TournamentSport.volleyball => 'Volleyball',
  TournamentSport.pickleball => 'Pickleball',
  TournamentSport.other => 'Other sport',
};
String _formatLabel(TournamentFormat format) => switch (format) {
  TournamentFormat.roundRobin => 'Round robin',
  TournamentFormat.singleElimination => 'Single elimination',
  TournamentFormat.doubleElimination => 'Double elimination',
  TournamentFormat.swissSystem => 'Swiss system',
  TournamentFormat.hybridPoolPlayoff => 'Hybrid pool & playoff',
};
String _statusLabel(TournamentStatus status) => switch (status) {
  TournamentStatus.draft => 'Draft',
  TournamentStatus.registrationOpen => 'Registration open',
  TournamentStatus.registrationClosed => 'Registration closed',
  TournamentStatus.inProgress => 'In progress',
  TournamentStatus.completed => 'Completed',
  TournamentStatus.cancelled => 'Cancelled',
};
(Color, Color) _statusChipColors(
  TournamentStatus status,
  ColorScheme colors,
) => switch (status) {
  TournamentStatus.draft => (colors.surfaceVariant, colors.onSurfaceVariant),
  TournamentStatus.registrationOpen => (
    colors.primaryContainer,
    colors.onPrimaryContainer,
  ),
  TournamentStatus.registrationClosed => (
    colors.surfaceVariant,
    colors.onSurfaceVariant,
  ),
  TournamentStatus.inProgress => (
    colors.tertiaryContainer,
    colors.onTertiaryContainer,
  ),
  TournamentStatus.completed => (
    colors.secondaryContainer,
    colors.onSecondaryContainer,
  ),
  TournamentStatus.cancelled => (
    colors.errorContainer,
    colors.onErrorContainer,
  ),
};
String _teamStatusLabel(TeamRegistrationStatus status) => switch (status) {
  TeamRegistrationStatus.pending => 'Pending approval',
  TeamRegistrationStatus.approved => 'Approved',
  TeamRegistrationStatus.rejected => 'Rejected',
};
Color _teamStatusBackground(
  TeamRegistrationStatus status,
  ColorScheme colors,
) => switch (status) {
  TeamRegistrationStatus.pending => colors.surfaceVariant,
  TeamRegistrationStatus.approved => colors.primaryContainer,
  TeamRegistrationStatus.rejected => colors.errorContainer,
};
Color _teamStatusForeground(
  TeamRegistrationStatus status,
  ColorScheme colors,
) => switch (status) {
  TeamRegistrationStatus.pending => colors.onSurfaceVariant,
  TeamRegistrationStatus.approved => colors.onPrimaryContainer,
  TeamRegistrationStatus.rejected => colors.onErrorContainer,
};
