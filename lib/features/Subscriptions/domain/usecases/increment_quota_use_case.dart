import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';

import '../repositories/subscription_repository.dart';

class IncrementQuotaUseCase {
  final SubscriptionRepository repository;
  IncrementQuotaUseCase(this.repository);
  Future<Either<Failure, void>> call(
    String userId, {
    required bool isClient,
  }) async => await repository.incrementQuota(userId, isClient: isClient);
}
