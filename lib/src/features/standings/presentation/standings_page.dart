import 'package:flutter/material.dart';

class StandingsPage extends StatelessWidget {
  const StandingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Standings')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.leaderboard_outlined,
                size: 72,
                color: colors.secondary,
              ),
              const SizedBox(height: 16),
              Text(
                'Standings dashboards on the way',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Soon you\'ll track pool results, tie-breakers, and leaderboards automatically as scores stream in.',
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
