import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';

import '../repositories/subscription_repository.dart';

class CheckQuotasUseCase {
  final SubscriptionRepository repository;
  CheckQuotasUseCase(this.repository);
  Future<Either<Failure, bool>> call(String userId) async =>
      await repository.hasCridets(userId);
}
