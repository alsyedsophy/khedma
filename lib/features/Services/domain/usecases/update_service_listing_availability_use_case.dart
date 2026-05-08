import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Services/domain/entities/service_listing_entity.dart';
import 'package:khedma/features/Services/domain/repositories/services_repo.dart';

class UpdateServiceListingAvailabilityUseCase
    implements
        UseCase<ServiceListingEntity, UpdateServiceListingAvailabilityParams> {
  final ServicesRepo servicesRepo;

  UpdateServiceListingAvailabilityUseCase({required this.servicesRepo});

  @override
  Future<Either<Failure, ServiceListingEntity>> call(
    UpdateServiceListingAvailabilityParams params,
  ) => servicesRepo.updateServiceListingAvailability(
    params.listingId,
    params.isAvailable,
  );
}

class UpdateServiceListingAvailabilityParams extends Equatable {
  final String listingId;
  final bool isAvailable;

  const UpdateServiceListingAvailabilityParams({
    required this.listingId,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [listingId, isAvailable];
}
