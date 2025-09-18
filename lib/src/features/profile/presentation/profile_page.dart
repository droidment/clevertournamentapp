import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/profile_controller.dart';
import '../models/profile_model.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  bool _didPopulate = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<ProfileModel?>>(currentProfileProvider, (
      AsyncValue<ProfileModel?>? previous,
      AsyncValue<ProfileModel?> next,
    ) {
      next.whenData((ProfileModel? profile) {
        if (profile != null && !_didPopulate) {
          _nameController.text = profile.fullName ?? '';
          _phoneController.text = profile.phone ?? '';
          _didPopulate = true;
        }
      });
    });

    final profileAsync = ref.watch(currentProfileProvider);
    final bool isLoading = profileAsync.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        actions: <Widget>[
          TextButton(
            onPressed: isLoading ? null : _onSave,
            child: const Text('Save'),
          ),
        ],
      ),
      body: profileAsync.when(
        data:
            (ProfileModel? profile) => _ProfileForm(
              formKey: _formKey,
              nameController: _nameController,
              phoneController: _phoneController,
              isSaving: isLoading,
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (Object error, StackTrace stackTrace) => _ProfileErrorView(
              error: error,
              onRetry:
                  () =>
                      ref
                          .read(currentProfileProvider.notifier)
                          .refreshProfile(),
            ),
      ),
    );
  }

  Future<void> _onSave() async {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final notifier = ref.read(currentProfileProvider.notifier);
    try {
      await notifier.saveProfile(
        fullName: _nameController.text,
        phone: _phoneController.text,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated.')));
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to save profile: $error'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

class _ProfileForm extends StatelessWidget {
  const _ProfileForm({
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.isSaving,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Tell us about you',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your profile helps organizers stay in touch and keeps team registrations consistent.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: nameController,
                      enabled: !isSaving,
                      decoration: const InputDecoration(
                        labelText: 'Full name',
                        hintText: 'Alex Johnson',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: phoneController,
                      enabled: !isSaving,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                        hintText: '(555) 123-4567',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileErrorView extends StatelessWidget {
  const _ProfileErrorView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

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
            Icon(Icons.cloud_off_outlined, size: 72, color: colors.error),
            const SizedBox(height: 16),
            Text(
              'Unable to load profile',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
