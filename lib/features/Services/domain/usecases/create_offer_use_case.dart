import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/Services/domain/entities/service_offer_entity.dart';
import 'package:khedma/features/Services/domain/repositories/services_repo.dart';

class CreateOfferUseCase
    implements UseCase<ServiceOfferEntity, CreateOfferParams> {
  final ServicesRepo servicesRepo;

  CreateOfferUseCase({required this.servicesRepo});

  @override
  Future<Either<Failure, ServiceOfferEntity>> call(CreateOfferParams params) =>
      servicesRepo.createOffer(
        requestId: params.requestId,
        price: params.price,
        description: params.description,
        providerId: params.providerId,
        providerName: params.providerName,
        providerImageUrl: params.providerImageUrl,
      );
}

class CreateOfferParams extends Equatable {
  final String requestId;
  final double price;
  final String description;
  final String providerId;
  final String providerName;
  final String? providerImageUrl;

  const CreateOfferParams({
    required this.requestId,
    required this.price,
    required this.description,
    required this.providerId,
    required this.providerName,
    this.providerImageUrl,
  });

  @override
  List<Object?> get props => [
    requestId,
    price,
    description,
    providerId,
    providerName,
    providerImageUrl,
  ];
}

// required String requestId,
//     required double price,
//     required String description,
//     required String providerId,
//     required String providerName,
//     String? providerImageUrl,
