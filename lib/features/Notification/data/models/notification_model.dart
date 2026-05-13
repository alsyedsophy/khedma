import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khedma/features/Notification/domain/entities/notifcation_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
    required super.isRead,
    required super.timestamp,
    super.relatedServiceId,
    super.relatedRequestId,
  });

  factory NotificationModel.fromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    return NotificationModel(
      id: id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      type: NotificationType.fromString(data['type'] ?? 'general'),
      isRead: data['isRead'] ?? false,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      relatedServiceId: data['relatedServiceId'] ?? '',
      relatedRequestId: data['relatedRequestId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'body': body,
      'type': type.value,
      'isRead': isRead,
      'timestamp': Timestamp.fromDate(timestamp),
      'relatedServiceId': relatedServiceId,
      'relatedRequestId': relatedRequestId,
    };
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      type: entity.type,
      isRead: entity.isRead,
      timestamp: entity.timestamp,
      relatedServiceId: entity.relatedServiceId,
      relatedRequestId: entity.relatedRequestId,
    );
  }

  factory NotificationModel.fromPreferencesFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    return NotificationModel(
      id: id,
      title: '',
      body: '',
      type: NotificationType.general,
      isRead: true,
      timestamp: DateTime.now(),
    );
  }
}

class NotificationPreferencesModel extends NotificationPreferences {
  const NotificationPreferencesModel({
    required super.generalEnabled,
    required super.soundEnabled,
    required super.vibrateEnabled,
    required super.categoryToggles,
  });

  factory NotificationPreferencesModel.fromFirestore(
    Map<String, dynamic> data,
  ) {
    final categoryToggles =
        (data['categoryToggles'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(key, value as bool),
        ) ??
        {};

    return NotificationPreferencesModel(
      generalEnabled: data['generalEnabled'] ?? true,
      soundEnabled: data['soundEnabled'] ?? true,
      vibrateEnabled: data['vibrateEnabled'] ?? true,
      categoryToggles: categoryToggles,
    );
  }

  factory NotificationPreferencesModel.fromEntity(
    NotificationPreferences entity,
  ) {
    return NotificationPreferencesModel(
      generalEnabled: entity.generalEnabled,
      soundEnabled: entity.soundEnabled,
      vibrateEnabled: entity.vibrateEnabled,
      categoryToggles: Map.from(entity.categoryToggles),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'generalEnabled': generalEnabled,
      'soundEnabled': soundEnabled,
      'vibrateEnabled': vibrateEnabled,
      'categoryToggles': categoryToggles,
    };
  }
}
