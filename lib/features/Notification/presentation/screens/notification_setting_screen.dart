import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/Widgets/app_button.dart';
import 'package:khedma/core/Widgets/app_error_widget.dart';
import 'package:khedma/core/Widgets/app_loading.dart';
import 'package:khedma/core/di/dependency_injections.dart';
import 'package:khedma/core/extensions/app_extensions.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';
import 'package:khedma/features/Notification/domain/entities/notifcation_entity.dart';
import 'package:khedma/features/Notification/presentation/cubit/notification_settings_cubit.dart';
import 'package:khedma/features/Notification/presentation/cubit/notification_settings_state.dart';

class NotificationSettingScreen extends StatelessWidget {
  const NotificationSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = sl<AuthCubit>().state.user?.id;
    return _SettingsView(userId: userId);
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView({required this.userId});
  final String? userId;

  NotificationPreferences? _prefs(NotificationSettingsState state) {
    if (state is SettingsLoaded) return state.preferences;
    if (state is SettingsSaved) return state.preferences;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: BlocConsumer<NotificationSettingsCubit, NotificationSettingsState>(
        listener: (context, state) {
          if (state is SettingsSaved) {
            context.showSuccess('Settings saved');
          } else if (state is SettingsError) {
            context.showError(state.message);
          }
        },
        builder: (context, state) {
          final prefs = _prefs(state);

          if (prefs != null) {
            return AppLoadingOverlay(
              isLoading: state is SettingsSaving,
              child: _SettingsContent(prefs: prefs, userId: userId),
            );
          }

          if (state is SettingsError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: userId != null
                  ? () => context.read<NotificationSettingsCubit>().load(
                      userId: userId!,
                    )
                  : null,
            );
          }

          if (userId == null) {
            return const AppErrorWidget(
              message: 'Sign in required to manage notifications.',
            );
          }

          return const AppLoading();
        },
      ),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  const _SettingsContent({required this.prefs, required this.userId});
  final NotificationPreferences prefs;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    // final cubit = context.read<NotificationSettingsCubit>();
    return ListView(
      padding: AppSpacing.h_16.allPadding,
      children: [
        SwitchListTile(
          title: const Text('Enable notifications'),
          subtitle: const Text('Master switch for all notifications'),
          value: prefs.generalEnabled,
          onChanged: (value) => _safeToggle(
            context,
            () =>
                context.read<NotificationSettingsCubit>().toggleGeneral(value),
          ),
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('Sound'),
          value: prefs.soundEnabled,
          onChanged: prefs.generalEnabled
              ? (value) => _safeToggle(
                  context,
                  () => context.read<NotificationSettingsCubit>().toggleSound(
                    value,
                  ),
                )
              : null,
        ),
        SwitchListTile(
          title: const Text('Vibration'),
          value: prefs.vibrateEnabled,
          onChanged: prefs.generalEnabled
              ? (value) => _safeToggle(
                  context,
                  () => context.read<NotificationSettingsCubit>().toggleVibrate(
                    value,
                  ),
                )
              : null,
        ),
        const Divider(),
        Padding(
          padding: AppSpacing.h_8.allPadding,
          child: Text('Categories', style: AppTypography.titleLarge),
        ),
        ...prefs.categoryToggles.entries.map(
          (e) => SwitchListTile(
            title: Text(_categoryLabel(e.key)),
            value: e.value,
            onChanged: prefs.generalEnabled
                ? (value) => _safeToggle(
                    context,
                    () => context
                        .read<NotificationSettingsCubit>()
                        .toggleCategory(e.key, value),
                  )
                : null,
          ),
        ),
        AppSpacing.h_24.verticalSpace,
        AppButton(
          label: 'Save',
          isLoading: false,
          onPressed: userId != null
              ? () => context.read<NotificationSettingsCubit>().save(
                  userId: userId!,
                )
              : null,
          width: double.infinity,
        ),
      ],
    ).paddingHorizontal(AppSpacing.w_16);
  }

  String _categoryLabel(String key) {
    const labels = {
      'general': 'General',
      'new_service': 'New Services',
      'payment': 'Payments',
      'offer_update': 'Offer Updates',
    };
    return labels[key] ?? key;
  }

  void _safeToggle(BuildContext context, VoidCallback action) {
    final cubit = context.read<NotificationSettingsCubit>();
    if (!cubit.isClosed) {
      action();
    }
  }
}
