import 'package:dartz/dartz.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Services/domain/entities/serice_request_entity.dart';
import 'package:khedma/features/Services/domain/repositories/services_repo.dart';

class GetOpenRequestsUseCase
    implements UseCase<List<ServiceRequestEntity>, NoParams> {
  final ServicesRepo servicesRepo;

  GetOpenRequestsUseCase({required this.servicesRepo});

  @override
  Future<Either<Failure, List<ServiceRequestEntity>>> call(NoParams params) {
    return servicesRepo.getOpenRequests();
  }
}
