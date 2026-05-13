import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Subscriptions/domain/entities/plan_entity.dart';
import 'package:khedma/features/Subscriptions/domain/repositories/subscription_repository.dart';

class GetPlansUseCase {
  final SubscriptionRepository repository;
  GetPlansUseCase(this.repository);
  Future<Either<Failure, List<PlanEntity>>> call() async =>
      await repository.getPlans();
}
