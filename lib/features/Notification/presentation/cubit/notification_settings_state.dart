import 'package:equatable/equatable.dart';
import 'package:khedma/features/Notification/domain/entities/notifcation_entity.dart';

abstract class NotificationSettingsState extends Equatable {
  const NotificationSettingsState();
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends NotificationSettingsState {}

class SettingsLoading extends NotificationSettingsState {}

class SettingsLoaded extends NotificationSettingsState {
  final NotificationPreferences preferences;
  const SettingsLoaded(this.preferences);
  @override
  List<Object?> get props => [preferences];
}

class SettingsSaving extends NotificationSettingsState {}

class SettingsSaved extends NotificationSettingsState {
  final NotificationPreferences preferences;
  const SettingsSaved(this.preferences);
  @override
  List<Object?> get props => [preferences];
}

class SettingsError extends NotificationSettingsState {
  final String message;
  const SettingsError(this.message);
  @override
  List<Object?> get props => [message];
}