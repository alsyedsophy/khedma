import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khedma/core/Utils/accept_offer_result.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Services/domain/repositories/services_repo.dart';

class AcceptOfferUseCase
    implements UseCase<AcceptOfferResult, AcceptOfferParams> {
  final ServicesRepo servicesRepo;

  AcceptOfferUseCase({required this.servicesRepo});

  @override
  Future<Either<Failure, AcceptOfferResult>> call(AcceptOfferParams params) =>
      servicesRepo.acceptOffer(params.offerId, params.requestId);
}

class AcceptOfferParams extends Equatable {
  final String offerId;
  final String requestId;

  const AcceptOfferParams({required this.offerId, required this.requestId});

  @override
  List<Object?> get props => [offerId, requestId];
}
