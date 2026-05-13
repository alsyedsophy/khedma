import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khedma/features/Notification/data/models/notification_model.dart';
import 'package:khedma/features/Notification/domain/entities/notifcation_entity.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationEntity>> getNotifications({
    required String userId,
    String? type,
    bool? isRead,
    int? limit,
    DateTime? startAfter,
  });

  Future<void> markAsRead({
    required String userId,
    required String notificationId,
  });

  Future<void> markAllAsRead({required String userId});

  Future<NotificationPreferences> getPreferences({required String userId});

  Future<void> updatePreferences({
    required String userId,
    required NotificationPreferences prefs,
  });
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore _firestore;

  NotificationRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Future<List<NotificationEntity>> getNotifications({
    required String userId,
    String? type,
    bool? isRead,
    int? limit,
    DateTime? startAfter,
  }) async {
    Query query = _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true);

    if (type != null) {
      query = query.where('type', isEqualTo: type);
    }
    if (isRead != null) {
      query = query.where('isRead', isEqualTo: isRead);
    }
    if (startAfter != null) {
      query = query.where('timestamp', isLessThan: startAfter);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map(
          (doc) => NotificationModel.fromFirestore(
            (doc.data() as Map<String, dynamic>),
            doc.id,
          ),
        )
        .toList();
  }

  @override
  Future<void> markAsRead({
    required String userId,
    required String notificationId,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  @override
  Future<void> markAllAsRead({required String userId}) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  @override
  Future<NotificationPreferences> getPreferences({
    required String userId,
  }) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notification_preferences')
        .doc('settings')
        .get();

    if (doc.exists) {
      return NotificationPreferencesModel.fromFirestore(
        (doc.data() as Map<String, dynamic>),
      );
    }

    // Return default preferences if none exist
    return const NotificationPreferences(
      generalEnabled: true,
      soundEnabled: true,
      vibrateEnabled: true,
      categoryToggles: {
        'general': true,
        'new_service': true,
        'payment': true,
        'offer_update': true,
      },
    );
  }

  @override
  Future<void> updatePreferences({
    required String userId,
    required NotificationPreferences prefs,
  }) async {
    final model = NotificationPreferencesModel.fromEntity(prefs);
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notification_preferences')
        .doc('settings')
        .set(model.toFirestore());
  }
}
