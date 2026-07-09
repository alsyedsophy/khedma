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
    super.payload,
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
      payload: data['payload'] != null
          ? Map<String, dynamic>.from(data['payload'])
          : null,
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
      'payload': payload,
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
      payload: entity.payload,
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
    return NotificationPreferencesModel(
      generalEnabled: data['generalEnabled'] ?? true,
      soundEnabled: data['soundEnabled'] ?? true,
      vibrateEnabled: data['vibrateEnabled'] ?? true,
      categoryToggles: data['categoryToggles'] != null
          ? Map<String, bool>.from(data['categoryToggles'])
          : {},
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
