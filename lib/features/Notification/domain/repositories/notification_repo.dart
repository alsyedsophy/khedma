import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Notification/domain/entities/notifcation_entity.dart';

abstract class NotificationRepo {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    String? type,
    bool? isRead,
    int? limit,
    DateTime? startAfter,
    required String userId,
  });

  Future<Either<Failure, void>> markAsRead(String id, String userId);

  Future<Either<Failure, void>> markAllAsRead(String userId);

  Future<Either<Failure, NotificationPreferences>> getPreferences(
    String userId,
  );

  Future<Either<Failure, void>> updatePreferences(
    NotificationPreferences prefs,
    String userId,
  );
}