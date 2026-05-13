import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Subscriptions/domain/entities/subscription_entity.dart';
import 'package:khedma/features/Subscriptions/domain/repositories/subscription_repository.dart';

class RestorePurchasesUseCase {
  final SubscriptionRepository repository;

  RestorePurchasesUseCase(this.repository);

  Future<Either<Failure, SubscriptionEntity>> call(String userId) async =>
      await repository.restorePurchases(userId);
}
