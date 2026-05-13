import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Subscriptions/domain/entities/plan_entity.dart';
import 'package:khedma/features/Subscriptions/domain/entities/subscription_entity.dart';
import 'package:khedma/features/Subscriptions/domain/repositories/subscription_repository.dart';

class PurchasePlanUseCase {
  final SubscriptionRepository repository;
  PurchasePlanUseCase(this.repository);
  Future<Either<Failure, SubscriptionEntity>> call(
    PlanEntity plan,
    String userId,
  ) async => await repository.purchasePlan(plan, userId);
}
