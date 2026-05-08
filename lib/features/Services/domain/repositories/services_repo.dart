import 'package:dartz/dartz.dart';
import 'package:khedma/core/Utils/accept_offer_result.dart';
import 'package:khedma/features/Services/domain/entities/serice_request_entity.dart';
import '../../../../core/errors/failures.dart';
import '../entities/service_offer_entity.dart';
import '../entities/service_listing_entity.dart';

abstract class ServicesRepo {
  // Service Requests
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
  });
  Future<Either<Failure, List<ServiceRequestEntity>>> getMyRequests(
    String clientId,
  );
  Future<Either<Failure, List<ServiceRequestEntity>>> getOpenRequests();
  Future<Either<Failure, List<ServiceRequestEntity>>> getRequestsByCategory(
    ServiceCategory category,
  );
  Future<Either<Failure, ServiceRequestEntity>> updateRequestStatus(
    String requestId,
    ServiceRequestStatus status,
  );
  Future<Either<Failure, void>> deleteServiceRequest(String requestId);

  // Offers
  Future<Either<Failure, ServiceOfferEntity>> createOffer({
    required String requestId,
    required double price,
    required String description,
    required String providerId,
    required String providerName,
    String? providerImageUrl,
  });
  Future<Either<Failure, List<ServiceOfferEntity>>> getOffersForRequest(
    String requestId,
  );
  Future<Either<Failure, List<ServiceOfferEntity>>> getMyOffers(
    String providerId,
  );
  // عايز اراجع البيانات اللى بترجع مره اخرى بعدين
  Future<Either<Failure, AcceptOfferResult>> acceptOffer(
    String offerId,
    String requestId,
  );
  Future<Either<Failure, void>> rejectOffer(String offerId);

  // Service Listings
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
  });
  Future<Either<Failure, List<ServiceListingEntity>>> getAllServiceListings();
  Future<Either<Failure, List<ServiceListingEntity>>> getMyServiceListings(
    String providerId,
  );
  Future<Either<Failure, ServiceListingEntity>>
  updateServiceListingAvailability(String listingId, bool isAvailable);
  Future<Either<Failure, void>> deleteServiceListing(String listingId);
}
