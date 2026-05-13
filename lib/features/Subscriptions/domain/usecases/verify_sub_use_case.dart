import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Subscriptions/domain/repositories/subscription_repository.dart';

class VerifySubUseCase {
  final SubscriptionRepository repository;
  VerifySubUseCase(this.repository);
  Future<Either<Failure, bool>> call(String userId) async =>
      await repository.isSubscriptionActive(userId);
}
