import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Services/domain/entities/serice_request_entity.dart';
import 'package:khedma/features/Services/domain/repositories/services_repo.dart';

class GetMyRequestsUseCase
    implements UseCase<List<ServiceRequestEntity>, GetMyRequestsParams> {
  final ServicesRepo servicesRepo;

  GetMyRequestsUseCase({required this.servicesRepo});

  @override
  Future<Either<Failure, List<ServiceRequestEntity>>> call(
    GetMyRequestsParams params,
  ) => servicesRepo.getMyRequests(params.clientId);
}

class GetMyRequestsParams extends Equatable {
  final String clientId;

  const GetMyRequestsParams({required this.clientId});

  @override
  List<Object?> get props => [clientId];
}
