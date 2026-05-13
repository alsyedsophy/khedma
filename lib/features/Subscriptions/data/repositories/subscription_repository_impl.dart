import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/extentions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/plan_entity.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_remote_data_source.dart';
import '../models/plan_model.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SubscriptionRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PlanEntity>>> getPlans() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final plansModel = await remoteDataSource.getPlans();
      return Right(plansModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> purchasePlan(
    PlanEntity plan,
    String userId,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final planModel = PlanModel.fromEntity(plan);
      final subscriptionModel = await remoteDataSource.purchasePlan(
        planModel,
        userId,
      );

      return Right(subscriptionModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> getCurrentSubscription(
    String userId,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final subscriptionModel = await remoteDataSource.getCurrentSubscription(
        userId,
      );
      return Right(subscriptionModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> restorePurchases(
    String userId,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final subscriptionModel = await remoteDataSource.restorePurchases(userId);
      return Right(subscriptionModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isSubscriptionActive(String userId) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final isActive = await remoteDataSource.isSubscriptionActive(userId);
      return Right(isActive);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> hasQuota(
    String userId, {
    required bool isClient,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final hasQuota = await remoteDataSource.hasQuota(
        userId,
        isClient: isClient,
      );
      return Right(hasQuota);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> incrementQuota(
    String userId, {
    required bool isClient,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      await remoteDataSource.incrementQuota(userId, isClient: isClient);
      return const Right(null);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
