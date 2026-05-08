import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Services/domain/entities/service_offer_entity.dart';
import 'package:khedma/features/Services/domain/repositories/services_repo.dart';

class GetMyOffersUseCase
    implements UseCase<List<ServiceOfferEntity>, GetMyOffersParams> {
  final ServicesRepo servicesRepo;

  GetMyOffersUseCase({required this.servicesRepo});

  @override
  Future<Either<Failure, List<ServiceOfferEntity>>> call(
    GetMyOffersParams params,
  ) => servicesRepo.getMyOffers(params.providerId);
}

class GetMyOffersParams extends Equatable {
  final String providerId;

  const GetMyOffersParams({required this.providerId});

  @override
  List<Object?> get props => [providerId];
}
