import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../controllers/tournaments_list_controller.dart';
import '../data/tournament_repository.dart';
import '../models/tournament_model.dart';

Future<String?> showTournamentCreateDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext dialogContext) {
      return _TournamentCreateDialog(ref: ref);
    },
  );
}

class _TournamentCreateDialog extends ConsumerStatefulWidget {
  const _TournamentCreateDialog({required this.ref});

  final WidgetRef ref;

  @override
  ConsumerState<_TournamentCreateDialog> createState() =>
      _TournamentCreateDialogState();
}

class _TournamentCreateDialogState
    extends ConsumerState<_TournamentCreateDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;

  TournamentSport? _sport;
  TournamentFormat? _format;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _sport = TournamentSport.volleyball;
    _format = TournamentFormat.roundRobin;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Create tournament'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Tournament name',
                    hintText: 'Spring Invitational',
                  ),
                  validator: _validateRequired,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Optional details for teams and spectators',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TournamentSport>(
                  value: _sport,
                  decoration: const InputDecoration(labelText: 'Sport'),
                  items:
                      TournamentSport.values
                          .map(
                            (TournamentSport value) =>
                                DropdownMenuItem<TournamentSport>(
                                  value: value,
                                  child: Text(_sportLabel(value)),
                                ),
                          )
                          .toList(),
                  onChanged:
                      (TournamentSport? value) =>
                          setState(() => _sport = value),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TournamentFormat>(
                  value: _format,
                  decoration: const InputDecoration(labelText: 'Format'),
                  items:
                      TournamentFormat.values.map((TournamentFormat value) {
                        return DropdownMenuItem<TournamentFormat>(
                          value: value,
                          child: Text(_formatLabel(value)),
                        );
                      }).toList(),
                  onChanged:
                      (TournamentFormat? value) =>
                          setState(() => _format = value),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _DateField(
                        label: 'Start date',
                        value: _startDate,
                        onSelect:
                            (DateTime date) =>
                                setState(() => _startDate = date),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DateField(
                        label: 'End date',
                        value: _endDate,
                        onSelect:
                            (DateTime date) => setState(() => _endDate = date),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    hintText: 'City or venue name',
                  ),
                ),
                if (_startDate != null &&
                    _endDate != null &&
                    _endDate!.isBefore(_startDate!))
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'End date must be after the start date.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _submit,
          child:
              _isSaving
                  ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    if (_startDate != null &&
        _endDate != null &&
        _endDate!.isBefore(_startDate!)) {
      _showError('End date must be after the start date.');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);

    try {
      final draft = TournamentDraft(
        name: _nameController.text.trim(),
        description:
            _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
        sport: _sport,
        format: _format,
        startDate: _startDate,
        endDate: _endDate,
        location:
            _locationController.text.trim().isEmpty
                ? null
                : _locationController.text.trim(),
      );

      final created = await widget.ref
          .read(tournamentsListControllerProvider.notifier)
          .createTournament(draft);

      if (mounted) {
        Navigator.of(context).pop(created.id);
      }
    } catch (error) {
      setState(() => _isSaving = false);
      _showError('$error');
    }
  }

  void _showError(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}

class _DateField extends StatefulWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onSelect,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onSelect;

  @override
  State<_DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<_DateField> {
  static final DateFormat _formatter = DateFormat('MMM d, yyyy');

  @override
  Widget build(BuildContext context) {
    final String labelText =
        widget.value != null ? _formatter.format(widget.value!) : 'Select date';

    return OutlinedButton(
      onPressed: _pickDate,
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(labelText),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year - 1);
    final DateTime lastDate = DateTime(now.year + 5);

    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: widget.value ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selected != null) {
      widget.onSelect(selected);
    }
  }
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
