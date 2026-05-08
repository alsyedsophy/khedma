import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Services/domain/entities/serice_request_entity.dart';
import 'package:khedma/features/Services/domain/repositories/services_repo.dart';

class GetRequestsByCategoryUseCase
    implements
        UseCase<List<ServiceRequestEntity>, GetRequestsByCategoryParams> {
  final ServicesRepo servicesRepo;

  GetRequestsByCategoryUseCase({required this.servicesRepo});

  @override
  Future<Either<Failure, List<ServiceRequestEntity>>> call(
    GetRequestsByCategoryParams params,
  ) => servicesRepo.getRequestsByCategory(params.category);
}

class GetRequestsByCategoryParams extends Equatable {
  final ServiceCategory category;

  const GetRequestsByCategoryParams({required this.category});

  @override
  List<Object?> get props => [category];
}
