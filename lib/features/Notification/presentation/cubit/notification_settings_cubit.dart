import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/features/Notification/domain/entities/notifcation_entity.dart';
import 'package:khedma/features/Notification/domain/usecases/get_preferences_use_case.dart';
import 'package:khedma/features/Notification/domain/usecases/update_preferences_use_case.dart';
import 'notification_settings_state.dart';

class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  final GetPreferencesUseCase _getPreferences;
  final UpdatePreferencesUseCase _updatePreferences;

  NotificationSettingsCubit({
    required GetPreferencesUseCase getPreferences,
    required UpdatePreferencesUseCase updatePreferences,
  }) : _getPreferences = getPreferences,
       _updatePreferences = updatePreferences,
       super(SettingsInitial());

  Future<void> load({required String userId}) async {
    emit(SettingsLoading());
    final result = await _getPreferences(GetPreferencesParams(userId));
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (prefs) => emit(SettingsLoaded(prefs)),
    );
  }

  // Mutate local copy within state; callers should get current prefs via state when loaded.
  void _mutate(
    NotificationPreferences Function(NotificationPreferences) updater,
  ) {
    if (isClosed || state is! SettingsLoaded) {
      return;
    }
    if (state is SettingsLoaded) {
      final current = (state as SettingsLoaded).preferences;
      emit(SettingsLoaded(updater(current)));
    }
  }

  void toggleGeneral(bool value) =>
      _mutate((p) => p.copyWith(generalEnabled: value));
  void toggleSound(bool value) =>
      _mutate((p) => p.copyWith(soundEnabled: value));
  void toggleVibrate(bool value) =>
      _mutate((p) => p.copyWith(vibrateEnabled: value));
  void toggleCategory(String key, bool value) => _mutate(
    (p) => p.copyWith(categoryToggles: {...p.categoryToggles, key: value}),
  );

  Future<void> save({required String userId}) async {
    if (state is! SettingsLoaded) return;
    final prefs = (state as SettingsLoaded).preferences;
    emit(SettingsSaving());
    final result = await _updatePreferences(
      UpdatePreferencesParams(prefs, userId),
    );
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) => emit(SettingsSaved(prefs)),
    );
  }
}
