import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Services/domain/entities/serice_request_entity.dart';
import 'package:khedma/features/Services/domain/repositories/services_repo.dart';

class UpdateRequestStatusUseCase
    implements UseCase<ServiceRequestEntity, UpdateRequestStatusParams> {
  final ServicesRepo servicesRepo;

  UpdateRequestStatusUseCase({required this.servicesRepo});

  @override
  Future<Either<Failure, ServiceRequestEntity>> call(
    UpdateRequestStatusParams params,
  ) => servicesRepo.updateRequestStatus(params.requestId, params.status);
}

class UpdateRequestStatusParams extends Equatable {
  final String requestId;
  final ServiceRequestStatus status;

  const UpdateRequestStatusParams({
    required this.requestId,
    required this.status,
  });

  @override
  List<Object?> get props => [requestId, status];
}

// ===================================
// الافضل انى ارجع ال service_request ولا اتفذ steam افضل
