import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Services/domain/repositories/services_repo.dart';

class DeleteServiceListingUseCase
    implements UseCase<void, DeleteServiceListingParams> {
  final ServicesRepo servicesRepo;

  DeleteServiceListingUseCase({required this.servicesRepo});

  @override
  Future<Either<Failure, void>> call(DeleteServiceListingParams params) =>
      servicesRepo.deleteServiceListing(params.listingId);
}

class DeleteServiceListingParams extends Equatable {
  final String listingId;

  const DeleteServiceListingParams({required this.listingId});

  @override
  List<Object?> get props => [listingId];
}
