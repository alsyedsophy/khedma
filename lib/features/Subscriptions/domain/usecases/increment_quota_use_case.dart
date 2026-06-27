import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';

import '../repositories/subscription_repository.dart';

class IncrementQuotaUseCase {
  final SubscriptionRepository repository;
  IncrementQuotaUseCase(this.repository);
  Future<Either<Failure, void>> call(String userId) async =>
      await repository.consumeCridet(userId);
}
