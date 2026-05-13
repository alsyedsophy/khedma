import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Subscriptions/domain/entities/plan_entity.dart';
import 'package:khedma/features/Subscriptions/domain/entities/subscription_entity.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, List<PlanEntity>>> getPlans();
  Future<Either<Failure, SubscriptionEntity>> purchasePlan(
    PlanEntity plan,
    String userId,
  ); // شراء خطة اشتراك معينه
  Future<Either<Failure, SubscriptionEntity>> getCurrentSubscription(
    String userId,
  );
  Future<Either<Failure, SubscriptionEntity>> restorePurchases(String userId);
  Future<Either<Failure, bool>> isSubscriptionActive(String userId);
  Future<Either<Failure, bool>> hasQuota(
    String userId, {
    required bool isClient,
  });
  Future<Either<Failure, void>> incrementQuota(
    String userId, {
    required bool isClient,
  });
}
