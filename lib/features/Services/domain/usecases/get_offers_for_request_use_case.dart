import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Services/domain/entities/service_offer_entity.dart';
import 'package:khedma/features/Services/domain/repositories/services_repo.dart';

class GetOffersForRequestUseCase
    implements UseCase<List<ServiceOfferEntity>, GetOffersForRequestParams> {
  final ServicesRepo servicesRepo;

  GetOffersForRequestUseCase({required this.servicesRepo});

  @override
  Future<Either<Failure, List<ServiceOfferEntity>>> call(
    GetOffersForRequestParams params,
  ) => servicesRepo.getOffersForRequest(params.requestId);
}

class GetOffersForRequestParams extends Equatable {
  final String requestId;

  const GetOffersForRequestParams({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}
