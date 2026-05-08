import 'package:equatable/equatable.dart';
import 'package:khedma/features/Services/domain/entities/service_listing_entity.dart';

/// حالات الخدمات المباشرة
abstract class ServiceListingState extends Equatable {
  const ServiceListingState();
  @override
  List<Object?> get props => [];
}

class ServiceListingInitial extends ServiceListingState {}

class ServiceListingLoading extends ServiceListingState {}

/// تم تحميل قائمة الخدمات
class ServiceListingsLoaded extends ServiceListingState {
  final List<ServiceListingEntity> listings;
  const ServiceListingsLoaded(this.listings);
  @override
  List<Object?> get props => [listings];
}

/// تم إنشاء خدمة جديدة
class ServiceListingCreated extends ServiceListingState {
  final ServiceListingEntity listing;
  const ServiceListingCreated(this.listing);
  @override
  List<Object?> get props => [listing];
}

/// تم تحديث حالة التوفر لخدمة
class ServiceListingAvailabilityUpdated extends ServiceListingState {
  final ServiceListingEntity updatedListing;
  const ServiceListingAvailabilityUpdated(this.updatedListing);
  @override
  List<Object?> get props => [updatedListing];
}

/// تم حذف خدمة
class ServiceListingDeleted extends ServiceListingState {
  final String listingId;
  const ServiceListingDeleted(this.listingId);
  @override
  List<Object?> get props => [listingId];
}

class ServiceListingError extends ServiceListingState {
  final String message;
  const ServiceListingError(this.message);
  @override
  List<Object?> get props => [message];
}
