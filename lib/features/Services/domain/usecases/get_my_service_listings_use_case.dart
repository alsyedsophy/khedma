import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Services/domain/entities/service_listing_entity.dart';
import 'package:khedma/features/Services/domain/repositories/services_repo.dart';

class GetMyServiceListingsUseCase
    implements UseCase<List<ServiceListingEntity>, GetMyServiceListingsParams> {
  final ServicesRepo servicesRepo;

  GetMyServiceListingsUseCase({required this.servicesRepo});

  @override
  Future<Either<Failure, List<ServiceListingEntity>>> call(
    GetMyServiceListingsParams params,
  ) => servicesRepo.getMyServiceListings(params.providerId);
}

class GetMyServiceListingsParams extends Equatable {
  final String providerId;

  const GetMyServiceListingsParams({required this.providerId});

  @override
  List<Object?> get props => [providerId];
}
