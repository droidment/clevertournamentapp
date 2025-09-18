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
  late final TextEditingController _contactEmailController;
  late final TextEditingController _contactPhoneController;
  bool _isSubmitting = false;
  String? _submissionError;
  @override
  void initState() {
    super.initState();
    final authState = widget.ref.read(authSessionProvider);
    final user = authState.valueOrNull;
    _teamNameController = TextEditingController();
    _contactEmailController = TextEditingController(text: user?.email ?? '');
    _contactPhoneController = TextEditingController();
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
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
                      controller: _contactEmailController,
                      decoration: const InputDecoration(
                        labelText: 'Contact email',
                        hintText: 'captain@email.com',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contactPhoneController,
                      decoration: const InputDecoration(
                        labelText: 'Contact phone',
                        hintText: '(555) 123-4567',
                      ),
                      keyboardType: TextInputType.phone,
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
          contactEmail:
              _contactEmailController.text.trim().isEmpty
                  ? null
                  : _contactEmailController.text.trim(),
          contactPhone:
              _contactPhoneController.text.trim().isEmpty
                  ? null
                  : _contactPhoneController.text.trim(),
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
