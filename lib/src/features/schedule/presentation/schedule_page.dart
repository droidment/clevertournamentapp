import 'package:clevertournamentapp/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Profile',
            onPressed: () => context.goNamed(AppRoute.profile.name),
            icon: const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person_outline, size: 18),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.calendar_today_outlined,
                size: 72,
                color: colors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Scheduling coming soon',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                "You'll soon be able to auto-generate match grids, drag-and-drop reschedule games, and publish real-time updates for teams.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
