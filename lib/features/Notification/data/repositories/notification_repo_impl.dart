import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/core/network/network_info.dart';
import 'package:khedma/features/Notification/domain/entities/notifcation_entity.dart';
import 'package:khedma/features/Notification/domain/repositories/notification_repo.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepoImpl implements NotificationRepo {
  final NotificationRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  NotificationRepoImpl({
    required NotificationRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    String? type,
    bool? isRead,
    int? limit,
    DateTime? startAfter,
    String? userId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await _remoteDataSource.getNotifications(
        userId: userId!,
        type: type,
        isRead: isRead,
        limit: limit,
        startAfter: startAfter,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id, String userId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _remoteDataSource.markAsRead(userId: userId, notificationId: id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead(String userId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _remoteDataSource.markAllAsRead(userId: userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationPreferences>> getPreferences(
    String userId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result =
          await _remoteDataSource.getPreferences(userId: userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePreferences(
    NotificationPreferences prefs,
    String userId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _remoteDataSource.updatePreferences(
        userId: userId,
        prefs: prefs,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}