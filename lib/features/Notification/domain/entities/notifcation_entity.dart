import 'package:equatable/equatable.dart';

enum NotificationType {
  general('general'),
  newService('new_service'),
  payment('payment'),
  offerUpdate('offer_update');

  final String value;
  const NotificationType(this.value);

  factory NotificationType.fromString(String value) {
    return NotificationType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => NotificationType.general,
    );
  }
}

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final DateTime timestamp;
  final String? relatedServiceId;
  final String? relatedRequestId;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.timestamp,
    this.relatedServiceId,
    this.relatedRequestId,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    bool? isRead,
    DateTime? timestamp,
    String? relatedServiceId,
    String? relatedRequestId,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      timestamp: timestamp ?? this.timestamp,
      relatedServiceId: relatedServiceId ?? this.relatedServiceId,
      relatedRequestId: relatedRequestId ?? this.relatedRequestId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        type,
        isRead,
        timestamp,
        relatedServiceId,
        relatedRequestId,
      ];
}

class NotificationPreferences extends Equatable {
  final bool generalEnabled;
  final bool soundEnabled;
  final bool vibrateEnabled;
  final Map<String, bool> categoryToggles;

  const NotificationPreferences({
    required this.generalEnabled,
    required this.soundEnabled,
    required this.vibrateEnabled,
    required this.categoryToggles,
  });

  NotificationPreferences copyWith({
    bool? generalEnabled,
    bool? soundEnabled,
    bool? vibrateEnabled,
    Map<String, bool>? categoryToggles,
  }) {
    return NotificationPreferences(
      generalEnabled: generalEnabled ?? this.generalEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrateEnabled: vibrateEnabled ?? this.vibrateEnabled,
      categoryToggles: categoryToggles ?? this.categoryToggles,
    );
  }

  @override
  List<Object?> get props => [
        generalEnabled,
        soundEnabled,
        vibrateEnabled,
        categoryToggles,
      ];
}