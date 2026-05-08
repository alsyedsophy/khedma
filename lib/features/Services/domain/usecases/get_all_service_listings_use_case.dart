import 'package:dartz/dartz.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Services/domain/entities/service_listing_entity.dart';
import 'package:khedma/features/Services/domain/repositories/services_repo.dart';

class GetAllServiceListingsUseCase
    implements UseCase<List<ServiceListingEntity>, NoParams> {
  final ServicesRepo servicesRepo;

  GetAllServiceListingsUseCase({required this.servicesRepo});

  @override
  Future<Either<Failure, List<ServiceListingEntity>>> call(NoParams params) =>
      servicesRepo.getAllServiceListings();
}
