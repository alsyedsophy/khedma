import 'package:dartz/dartz.dart';
import 'package:khedma/core/constants/app_emums.dart';
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
  Future<Either<Failure, SubscriptionEntity>> restorePurchases(
    String userId,
  ); // لحل مشكلة التبديل بين الهاتف اواللاب او  اى جهاز بنفس الحساب
  Future<Either<Failure, bool>> hasCridets(String userId);
  Future<Either<Failure, void>> consumeCridet(String userId);
}
