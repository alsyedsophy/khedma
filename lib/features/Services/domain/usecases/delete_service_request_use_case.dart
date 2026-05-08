import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Services/domain/repositories/services_repo.dart';

class DeleteServiceRequestUseCase
    implements UseCase<void, DeleteServiceRequestParams> {
  final ServicesRepo servicesRepo;

  DeleteServiceRequestUseCase({required this.servicesRepo});

  @override
  Future<Either<Failure, void>> call(DeleteServiceRequestParams params) =>
      servicesRepo.deleteServiceRequest(params.requestId);
}

class DeleteServiceRequestParams extends Equatable {
  final String requestId;

  const DeleteServiceRequestParams({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}
