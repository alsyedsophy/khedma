import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Services/domain/entities/serice_request_entity.dart';
import 'package:khedma/features/Services/domain/entities/service_listing_entity.dart';
import 'package:khedma/features/Services/domain/repositories/services_repo.dart';

class CreateServiceListingUseCase
    implements UseCase<ServiceListingEntity, CreateServiceListingParams> {
  final ServicesRepo servicesRepo;

  CreateServiceListingUseCase({required this.servicesRepo});

  @override
  Future<Either<Failure, ServiceListingEntity>> call(
    CreateServiceListingParams params,
  ) => servicesRepo.createServiceListing(
    title: params.title,
    description: params.description,
    categoryId: params.categoryId,
    category: params.category,
    price: params.price,
    city: params.city,
    governorate: params.governorate,
    providerId: params.providerId,
    providerName: params.providerName,
    providerImageUrl: params.providerImageUrl,
  );
}

class CreateServiceListingParams extends Equatable {
  final String title;
  final String description;
  final String categoryId;
  final ServiceCategory category;
  final double price;
  final String city;
  final String governorate;
  final String providerId;
  final String providerName;
  final String? providerImageUrl;

  const CreateServiceListingParams({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.category,
    required this.price,
    required this.city,
    required this.governorate,
    required this.providerId,
    required this.providerName,
    this.providerImageUrl,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    category,
    price,
    city,
    governorate,
    providerId,
    providerName,
    providerImageUrl,
  ];
}
