import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/features/Services/domain/usecases/services_usecases.dart';
import 'package:khedma/features/Services/presentation/cubits/Listings/service_listing_state.dart';

/// Cubit لإدارة الخدمات المباشرة (Service Listings)
/// - لمقدم الخدمة: إنشاء خدمة، عرض خدماته، تحديث التوفر، حذف
/// - للعميل: عرض جميع الخدمات المتاحة، البحث/التصفية
class ServiceListingCubit extends Cubit<ServiceListingState> {
  final CreateServiceListingUseCase _createServiceListing;
  final GetAllServiceListingsUseCase _getAllServiceListings;
  final GetMyServiceListingsUseCase _getMyServiceListings;
  final UpdateServiceListingAvailabilityUseCase _updateAvailability;
  final DeleteServiceListingUseCase _deleteServiceListing;

  ServiceListingCubit({
    required CreateServiceListingUseCase createServiceListing,
    required GetAllServiceListingsUseCase getAllServiceListings,
    required GetMyServiceListingsUseCase getMyServiceListings,
    required UpdateServiceListingAvailabilityUseCase updateAvailability,
    required DeleteServiceListingUseCase deleteServiceListing,
  }) : _createServiceListing = createServiceListing,
       _getAllServiceListings = getAllServiceListings,
       _getMyServiceListings = getMyServiceListings,
       _updateAvailability = updateAvailability,
       _deleteServiceListing = deleteServiceListing,
       super(ServiceListingInitial());

  Future<void> createListing(CreateServiceListingParams params) async {
    emit(ServiceListingLoading());
    final result = await _createServiceListing(params);
    result.fold(
      (failure) => emit(ServiceListingError(failure.message)),
      (listing) => emit(ServiceListingCreated(listing)),
    );
  }

  Future<void> loadAllListings() async {
    emit(ServiceListingLoading());
    final result = await _getAllServiceListings(NoParams());
    result.fold(
      (failure) => emit(ServiceListingError(failure.message)),
      (listings) => emit(ServiceListingsLoaded(listings)),
    );
  }

  Future<void> loadMyListings(String providerId) async {
    emit(ServiceListingLoading());
    final result = await _getMyServiceListings(
      GetMyServiceListingsParams(providerId: providerId),
    );
    result.fold(
      (failure) => emit(ServiceListingError(failure.message)),
      (listings) => emit(ServiceListingsLoaded(listings)),
    );
  }

  Future<void> updateAvailability(String listingId, bool isAvailable) async {
    emit(ServiceListingLoading());
    final result = await _updateAvailability(
      UpdateServiceListingAvailabilityParams(
        listingId: listingId,
        isAvailable: isAvailable,
      ),
    );
    result.fold(
      (failure) => emit(ServiceListingError(failure.message)),
      (listingUpdated) =>
          emit(ServiceListingAvailabilityUpdated(listingUpdated)),
    );
  }

  Future<void> deleteListing(String listingId) async {
    emit(ServiceListingLoading());
    final result = await _deleteServiceListing(
      DeleteServiceListingParams(listingId: listingId),
    );
    result.fold(
      (failure) => emit(ServiceListingError(failure.message)),
      (_) => emit(ServiceListingDeleted(listingId)),
    );
  }
}
