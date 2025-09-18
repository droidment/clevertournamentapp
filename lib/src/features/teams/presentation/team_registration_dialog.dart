import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controllers/auth_session_providers.dart';
import '../../auth/models/app_user.dart';
import '../controllers/tournament_teams_controller.dart';
import '../data/team_repository.dart';

Future<void> showTeamRegistrationDialog(
  BuildContext context,
  WidgetRef ref,
  String tournamentId,
) {
  return showDialog<void>(
    context: context,
    builder:
        (BuildContext context) =>
            _TeamRegistrationDialog(ref: ref, tournamentId: tournamentId),
  );
}

class _TeamRegistrationDialog extends ConsumerStatefulWidget {
  const _TeamRegistrationDialog({
    required this.ref,
    required this.tournamentId,
  });

  final WidgetRef ref;
  final String tournamentId;

  @override
  ConsumerState<_TeamRegistrationDialog> createState() =>
      _TeamRegistrationDialogState();
}

class _TeamRegistrationDialogState
    extends ConsumerState<_TeamRegistrationDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _teamNameController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _jerseyColorController;

  bool _isSubmitting = false;
  String? _submissionError;

  @override
  void initState() {
    super.initState();
    _teamNameController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _jerseyColorController = TextEditingController();
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _jerseyColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final authState = ref.watch(authSessionProvider);
    final user = authState.valueOrNull;

    return AlertDialog(
      title: const Text('Register a team'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (_submissionError != null) ...<Widget>[
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _submissionError!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onErrorContainer,
                    ),
                  ),
                ),
              ],
              if (user != null) ...<Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Team captain', style: theme.textTheme.labelMedium),
                      const SizedBox(height: 4),
                      Text(
                        user.fullName ?? user.email,
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        user.email,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _teamNameController,
                      decoration: const InputDecoration(
                        labelText: 'Team name',
                        hintText: 'Downtown Spikers',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Team name is required.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        hintText: 'Austin',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'City is required.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(
                        labelText: 'State / Province',
                        hintText: 'Texas',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'State or province is required.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _jerseyColorController,
                      decoration: const InputDecoration(
                        labelText: 'Jersey color (optional)',
                        hintText: 'Navy blue',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : () => _submit(user),
          child:
              _isSubmitting
                  ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Text('Register team'),
        ),
      ],
    );
  }

  Future<void> _submit(AppUser? user) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _submissionError = null;
    });

    try {
      final notifier = ref.read(
        tournamentTeamsControllerProvider(widget.tournamentId).notifier,
      );
      await notifier.registerTeam(
        TeamDraft(
          tournamentId: widget.tournamentId,
          name: _teamNameController.text.trim(),
          captainId: user?.id,
          captainEmail: user?.email,
          captainName: user?.fullName,
          city: _cityController.text.trim(),
          state: _stateController.text.trim(),
          jerseyColor:
              _jerseyColorController.text.trim().isEmpty
                  ? null
                  : _jerseyColorController.text.trim(),
        ),
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Team registered.')));
      }
    } catch (error) {
      setState(() {
        _submissionError = 'Could not register the team. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
