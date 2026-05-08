import 'package:dartz/dartz.dart';
import 'package:khedma/core/Utils/accept_offer_result.dart';
import 'package:khedma/features/Services/data/datasources/service_remote_data_surce.dart';
import 'package:khedma/features/Services/data/models/service_request_model.dart';
import 'package:khedma/features/Services/domain/entities/serice_request_entity.dart';
import 'package:khedma/features/Services/domain/repositories/services_repo.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/service_offer_entity.dart';
import '../../domain/entities/service_listing_entity.dart';

import '../models/service_offer_model.dart';
import '../models/service_listing_model.dart';

class ServiceRepoImpl implements ServicesRepo {
  final ServiceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ServiceRepoImpl({required this.remoteDataSource, required this.networkInfo});

  // ========== Service Requests ==========
  @override
  Future<Either<Failure, ServiceRequestEntity>> createServiceRequest({
    required String title,
    required String description,
    required String categoryId,
    required ServiceCategory category,
    required String city,
    required String governorate,
    double? budget,
    required String clientId,
    required String clientName,
    String? clientImageUrl,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final requestModel = ServiceRequestModel(
        id: '',
        clientId: clientId,
        clientName: clientName,
        clientImageUrl: clientImageUrl,
        title: title,
        description: description,
        categoryId: categoryId,
        category: category,
        status: ServiceRequestStatus.open,
        city: city,
        governorate: governorate,
        budget: budget,
        createdAt: DateTime.now(),
        offersCount: 0,
      );
      final created = await remoteDataSource.createServiceRequest(requestModel);
      return Right(created);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceRequestEntity>>> getMyRequests(
    String clientId,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final requests = await remoteDataSource.getRequestsByClient(clientId);
      return Right(requests);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceRequestEntity>>> getOpenRequests() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final requests = await remoteDataSource.getOpenRequests();
      return Right(requests);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceRequestEntity>>> getRequestsByCategory(
    ServiceCategory category,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final requests = await remoteDataSource.getRequestsByCategory(category);
      return Right(requests);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ServiceRequestEntity>> updateRequestStatus(
    String requestId,
    ServiceRequestStatus status,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final request = await remoteDataSource.updateRequestStatus(
        requestId,
        status,
      );
      return Right(request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteServiceRequest(String requestId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      await remoteDataSource.deleteServiceRequest(requestId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ========== Offers ==========
  @override
  Future<Either<Failure, ServiceOfferEntity>> createOffer({
    required String requestId,
    required double price,
    required String description,
    required String providerId,
    required String providerName,
    String? providerImageUrl,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final offerModel = ServiceOfferModel(
        id: '',
        requestId: requestId,
        providerId: providerId,
        providerName: providerName,
        providerImageUrl: providerImageUrl,
        price: price,
        description: description,
        isAccepted: false,
        createdAt: DateTime.now(),
      );
      final created = await remoteDataSource.createOffer(offerModel);
      return Right(created);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceOfferEntity>>> getOffersForRequest(
    String requestId,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final offers = await remoteDataSource.getOffersForRequest(requestId);
      return Right(offers);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceOfferEntity>>> getMyOffers(
    String providerId,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final offers = await remoteDataSource.getOffersByProvider(providerId);
      return Right(offers);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AcceptOfferResult>> acceptOffer(
    String offerId,
    String requestId,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final result = await remoteDataSource.acceptOffer(offerId, requestId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rejectOffer(String offerId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      await remoteDataSource.rejectOffer(offerId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ========== Service Listings ==========
  @override
  Future<Either<Failure, ServiceListingEntity>> createServiceListing({
    required String title,
    required String description,
    required String categoryId,
    required ServiceCategory category,
    required double price,
    required String city,
    required String governorate,
    required String providerId,
    required String providerName,
    String? providerImageUrl,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final listingModel = ServiceListingModel(
        id: '',
        providerId: providerId,
        providerName: providerName,
        providerImageUrl: providerImageUrl,
        title: title,
        description: description,
        categoryId: categoryId,
        category: category,
        price: price,
        city: city,
        governorate: governorate,
        isAvailable: true,
        createdAt: DateTime.now(),
      );
      final created = await remoteDataSource.createServiceListing(listingModel);
      return Right(created);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceListingEntity>>>
  getAllServiceListings() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final listings = await remoteDataSource.getAllServiceListings();
      return Right(listings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceListingEntity>>> getMyServiceListings(
    String providerId,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final listings = await remoteDataSource.getServiceListingsByProvider(
        providerId,
      );
      return Right(listings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ServiceListingEntity>>
  updateServiceListingAvailability(String listingId, bool isAvailable) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final serviceUpdated = await remoteDataSource
          .updateServiceListingAvailability(listingId, isAvailable);
      return Right(serviceUpdated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteServiceListing(String listingId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      await remoteDataSource.deleteServiceListing(listingId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
