import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Services/domain/entities/serice_request_entity.dart';
import 'package:khedma/features/Services/domain/repositories/services_repo.dart';

class CreateServiceRequestUseCase
    implements UseCase<ServiceRequestEntity, CreateServiceRequestParams> {
  final ServicesRepo servicesRepo;

  CreateServiceRequestUseCase({required this.servicesRepo});
  @override
  Future<Either<Failure, ServiceRequestEntity>> call(
    CreateServiceRequestParams params,
  ) => servicesRepo.createServiceRequest(
    title: params.title,
    description: params.description,
    categoryId: params.categoryId,
    category: params.category,
    city: params.city,
    governorate: params.governorate,
    budget: params.budget,
    clientId: params.clientId,
    clientName: params.clientName,
    clientImageUrl: params.clientImageUrl,
  );
}

class CreateServiceRequestParams extends Equatable {
  final String title;
  final String description;
  final String categoryId;
  final ServiceCategory category;
  final String city;
  final String governorate;
  final double? budget;
  final String clientId;
  final String clientName;
  final String? clientImageUrl;

  const CreateServiceRequestParams({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.category,
    required this.city,
    required this.governorate,
    this.budget,
    required this.clientId,
    required this.clientName,
    this.clientImageUrl,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    category,
    city,
    governorate,
    budget,
    clientId,
    clientName,
    clientImageUrl,
  ];
}
