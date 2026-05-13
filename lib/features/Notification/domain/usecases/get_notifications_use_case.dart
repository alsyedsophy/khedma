import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/features/Notification/domain/entities/notifcation_entity.dart';
import 'package:khedma/features/Notification/domain/repositories/notification_repo.dart';

class GetNotificationsParams {
  final String? type;
  final bool? isRead;
  final int? limit;
  final DateTime? startAfter;
  final String userId;

  GetNotificationsParams({
    this.type,
    this.isRead,
    this.limit,
    this.startAfter,
    required this.userId,
  });
}

class GetNotificationsUseCase
    extends UseCase<List<NotificationEntity>, GetNotificationsParams> {
  final NotificationRepo _repo;

  GetNotificationsUseCase(this._repo);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
    GetNotificationsParams params,
  ) async {
    return _repo.getNotifications(
      type: params.type,
      isRead: params.isRead,
      limit: params.limit,
      startAfter: params.startAfter,
      userId: params.userId,
    );
  }
}