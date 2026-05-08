import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Services/domain/repositories/services_repo.dart';

class RejectOfferUseCase implements UseCase<void, RejectOfferParams> {
  final ServicesRepo servicesRepo;

  RejectOfferUseCase({required this.servicesRepo});

  @override
  Future<Either<Failure, void>> call(RejectOfferParams params) =>
      servicesRepo.rejectOffer(params.offerId);
}

class RejectOfferParams extends Equatable {
  final String offerId;

  const RejectOfferParams({required this.offerId});

  @override
  List<Object?> get props => [offerId];
}
